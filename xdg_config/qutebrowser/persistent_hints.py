import hashlib
import json
from pathlib import Path

from qutebrowser.api import cmdutils
from qutebrowser.browser import hints
from qutebrowser.config import config
from qutebrowser.keyinput import modeman
from qutebrowser.utils import message, objreg, standarddir, usertypes


HINTS_FILE = Path(standarddir.config()) / "persistent-hints.json"

_pending_hint_key = None


# ---------------------------------------------------------------------------
# Preserve original methods across module reloads
# ---------------------------------------------------------------------------

HintManager = hints.HintManager

if not hasattr(HintManager, "_persistent_hints_original_hint_strings"):
    HintManager._persistent_hints_original_hint_strings = (
        HintManager._hint_strings
    )

if not hasattr(HintManager, "_persistent_hints_original_fire"):
    HintManager._persistent_hints_original_fire = HintManager._fire

_original_hint_strings = (
    HintManager._persistent_hints_original_hint_strings
)
_original_fire = HintManager._persistent_hints_original_fire


# ---------------------------------------------------------------------------
# Persistence
# ---------------------------------------------------------------------------

def _load_hints():
    try:
        with HINTS_FILE.open("r", encoding="utf-8") as file:
            data = json.load(file)
            return data if isinstance(data, dict) else {}
    except FileNotFoundError:
        return {}
    except (OSError, json.JSONDecodeError) as error:
        message.error(f"Cannot load persistent hints: {error}")
        return {}


def _save_hints(data):
    HINTS_FILE.parent.mkdir(parents=True, exist_ok=True)

    temporary = HINTS_FILE.with_suffix(".tmp")

    with temporary.open("w", encoding="utf-8") as file:
        json.dump(data, file, indent=2, sort_keys=True)

    temporary.replace(HINTS_FILE)


# ---------------------------------------------------------------------------
# Element identification
# ---------------------------------------------------------------------------

def _origin(url):
    scheme = url.scheme().lower()
    host = url.host().lower()

    if not scheme or not host:
        return None

    port = url.port(-1)

    default_ports = {
        "http": 80,
        "https": 443,
    }

    if port != -1 and port != default_ports.get(scheme):
        return f"{scheme}://{host}:{port}"

    return f"{scheme}://{host}"


def _fingerprint(element):
    attributes = {}

    for name in (
        "id",
        "name",
        "type",
        "role",
        "aria-label",
        "title",
        "placeholder",
        "href",
        "value",
    ):
        try:
            if name in element:
                value = element[name].strip()
                if value:
                    attributes[name] = value
        except Exception:
            pass

    identity = {
        "tag": element.tag_name(),
        "attributes": attributes,
        "text": str(element).strip(),
    }

    serialized = json.dumps(
        identity,
        sort_keys=True,
        ensure_ascii=False,
    )

    return hashlib.sha256(serialized.encode("utf-8")).hexdigest()


def _site_mappings(url):
    origin = _origin(url)

    if origin is None:
        return None, None

    data = _load_hints()
    return data, data.setdefault(origin, {})


# ---------------------------------------------------------------------------
# Persistent hint generation
# ---------------------------------------------------------------------------

def _persistent_hint_strings(self, elements):
    strings = _original_hint_strings(self, elements)

    context = self._context

    if context is None or context.hint_mode != "letter":
        return strings

    data, mappings = _site_mappings(context.baseurl)

    if not mappings:
        return strings

    fingerprints = [_fingerprint(elem) for elem in elements]

    counts = {
        fingerprint: fingerprints.count(fingerprint)
        for fingerprint in set(fingerprints)
    }

    assignments = {}

    for index, fingerprint in enumerate(fingerprints):
        key = mappings.get(fingerprint)

        if (
            isinstance(key, str)
            and key
            and all(c in config.val.hints.chars for c in key)
            and counts[fingerprint] == 1
        ):
            assignments[index] = key

    used_keys = set()
    valid_assignments = {}

    for index, key in assignments.items():
        if key not in used_keys:
            valid_assignments[index] = key
            used_keys.add(key)

    if not valid_assignments:
        return strings

    alphabet = config.val.hints.chars
    available = "".join(c for c in alphabet if c not in used_keys)

    if not available:
        message.error("No characters left for automatic hints.")
        return strings

    result = [None] * len(elements)

    for index, key in valid_assignments.items():
        result[index] = key

    automatic = self._hint_linear(
        config.val.hints.min_chars,
        available,
        [
            elem
            for i, elem in enumerate(elements)
            if i not in valid_assignments
        ],
    )

    automatic_iter = iter(automatic)

    for index in range(len(result)):
        if result[index] is None:
            result[index] = next(automatic_iter)

    return result


HintManager._hint_strings = _persistent_hint_strings


# ---------------------------------------------------------------------------
# Save selected element instead of clicking it
# ---------------------------------------------------------------------------

def _persistent_fire(self, keystr):
    global _pending_hint_key

    if _pending_hint_key is None:
        return _original_fire(self, keystr)

    key = _pending_hint_key
    _pending_hint_key = None

    context = self._context

    if context is None:
        message.error("No active hint session.")
        return

    label = context.labels.get(keystr)

    if label is None:
        message.error("Selected hint does not exist.")
        return

    data, mappings = _site_mappings(context.baseurl)

    if mappings is None:
        message.error("Cannot determine website origin.")
        return

    fingerprint = _fingerprint(label.elem)

    for existing_fingerprint, existing_key in list(mappings.items()):
        if (
            existing_key == key
            or existing_fingerprint == fingerprint
        ):
            del mappings[existing_fingerprint]

    mappings[fingerprint] = key

    try:
        _save_hints(data)
    except OSError as error:
        message.error(f"Cannot save persistent hint: {error}")
        return

    origin = _origin(context.baseurl)

    modeman.leave(
        self._win_id,
        usertypes.KeyMode.hint,
        "persistent hint saved",
        maybe=True,
    )

    message.info(f"Saved '{key}' for {origin}")


HintManager._fire = _persistent_fire


# ---------------------------------------------------------------------------
# Command implementations
# ---------------------------------------------------------------------------

def _hint_save_impl(self, key):
    global _pending_hint_key

    if not key or any(c not in config.val.hints.chars for c in key):
        raise cmdutils.CommandError(
            "Hint must contain only characters from hints.chars."
        )

    if self._context is not None:
        raise cmdutils.CommandError(
            "Exit the current hint session first."
        )

    _pending_hint_key = key

    try:
        self.start(
            group="all",
            target=hints.Target.normal,
            mode="letter",
        )
    except Exception:
        _pending_hint_key = None
        raise


def _hint_reset_impl(self, key):
    if not key or any(c not in config.val.hints.chars for c in key):
        raise cmdutils.CommandError(
            "Hint must contain only characters from hints.chars."
        )

    tabbed_browser = objreg.get(
        "tabbed-browser",
        scope="window",
        window=self._win_id,
    )

    url = tabbed_browser.current_url()

    data, mappings = _site_mappings(url)

    if mappings is None:
        raise cmdutils.CommandError("Cannot determine website origin.")

    fingerprints = [
        fingerprint
        for fingerprint, saved_key in mappings.items()
        if saved_key == key
    ]

    if not fingerprints:
        raise cmdutils.CommandError(
            f"No persistent hint '{key}' on {_origin(url)}."
        )

    for fingerprint in fingerprints:
        del mappings[fingerprint]

    if not mappings:
        del data[_origin(url)]

    _save_hints(data)

    message.info(f"Removed persistent hint '{key}'.")


# ---------------------------------------------------------------------------
# Register commands exactly once
# ---------------------------------------------------------------------------

if not globals().get("_persistent_commands_registered", False):

    @cmdutils.register(
        instance="hintmanager",
        scope="window",
        name="hint-save",
    )
    def hint_save(self, key):
        """Select an element and assign it a persistent hint."""
        _hint_save_impl(self, key)

    @cmdutils.register(
        instance="hintmanager",
        scope="window",
        name="hint-reset",
    )
    def hint_reset(self, key):
        """Remove a persistent hint from the current website."""
        _hint_reset_impl(self, key)

    _persistent_commands_registered = True
