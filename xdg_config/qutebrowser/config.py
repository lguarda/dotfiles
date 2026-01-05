import configparser

from qutebrowser.utils import message

# {{{ Defaults
config.load_autoconfig()
# }}}
# {{{ Load external conf
cp = configparser.ConfigParser()
cp.read(f"{config.configdir}/quteconf.ini")

gpg_key = None
try:
    gpg_key = cp["default"]["keepassxc_gpg"]
except KeyError:
    message.warning(
        "missing default.keepassxc_gpg in quteconf.ini keepassxc will not work"
    )
    pass
# }}}
# {{{ Bindings
# Ctrl+j = down in command-line completion
config.bind('<Alt-j>', 'completion-item-focus next', mode='command')
# Ctrl+k = up in command-line completion
config.bind('<Alt-k>', 'completion-item-focus prev', mode='command')
# keepassxc integration
if gpg_key is not None:
    config.bind(
        "pw", f"spawn --userscript qute-keepassxc --key {gpg_key}", mode="normal"
    )
    config.bind(
        "p<Shift-w>", f"spawn --userscript qute-keepassxc --key {gpg_key} --selection", mode="normal"
    )
else:
    config.bind(
        "pw",
        'message-error "missing default.keepassxc_gpg in quteconf.ini keepassxc will not work"',
        mode="normal",
    )

# open current url in new window
config.bind("gw", "open -w {url}", mode="normal")
# Toggle darkmode
config.bind(
    "<Shift-D>",
    "config-cycle -u {url:domain} colors.webpage.darkmode.enabled",
    mode="normal",
)
config.bind("gd", "download-open dragon", mode="normal")
config.bind("<Shift-j>", "tab-prev", mode="normal")
config.bind("<Shift-k>", "tab-next", mode="normal")
# }}}
# {{{ settings
c.content.blocking.adblock.lists = [
    "https://easylist.to/easylist/easylist.txt",
    "https://easylist.to/easylist/easyprivacy.txt",
    "https://easylist-downloads.adblockplus.org/easylistdutch.txt",
    "https://easylist-downloads.adblockplus.org/abp-filters-anti-cv.txt",
    "https://www.i-dont-care-about-cookies.eu/abp/",
    "https://secure.fanboy.co.nz/fanboy-cookiemonster.txt",
]
c.content.pdfjs = True  # pdf viewer install libjs-pdf
c.qt.args.append("widevine-path=/usr/lib/chromium/libwidevinecdm.so")
c.content.autoplay = True
# {{{ them
c.colors.webpage.preferred_color_scheme = "dark"
c.colors.webpage.bg = "black"
c.colors.webpage.darkmode.enabled = False  # disable by default
c.aliases["mpv"] = "spawn --userscript view_in_mpv"
# }}}
# }}}
# vim: fdm=marker
# ruff: noqa: F821
