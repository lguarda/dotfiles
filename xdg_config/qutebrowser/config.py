import configparser

from qutebrowser.utils import message

# {{{ Defaults
config.load_autoconfig()
# }}}
# {{{ Load external conf
cp = configparser.ConfigParser()
cp.read(f'{config.configdir}/quteconf.ini')

gpg_key = None
try:
    gpg_key = cp['default']['keepassxc_gpg']
except KeyError:
    message.warning("missing default.keepassxc_gpg in quteconf.ini keepassxc will not work")
    pass
# }}}
# {{{ Bindings
# keepassxc integration
if gpg_key is not None:
    config.bind('pw', f'spawn --userscript qute-keepassxc --key {gpg_key}', mode='normal')
else:
    config.bind('pw', 'message-error "missing default.keepassxc_gpg in quteconf.ini keepassxc will not work"', mode='normal')

# open current url in new window
config.bind('gw', 'open -w {url}', mode='normal')
# Toggle darkmode
config.bind('<Shift-D>', 'config-cycle -u {url:domain} colors.webpage.darkmode.enabled', mode='normal')
# }}}
# {{{ settings
c.content.blocking.adblock.lists = ['https://easylist.to/easylist/easylist.txt', 'https://easylist.to/easylist/easyprivacy.txt', 'https://easylist-downloads.adblockplus.org/easylistdutch.txt', 'https://easylist-downloads.adblockplus.org/abp-filters-anti-cv.txt', 'https://www.i-dont-care-about-cookies.eu/abp/', 'https://secure.fanboy.co.nz/fanboy-cookiemonster.txt']
c.content.pdfjs = True # pdf viewer install libjs-pdf
c.qt.args.append('widevine-path=/usr/lib/chromium/libwidevinecdm.so')
c.content.autoplay = True
# {{{ them
c.colors.webpage.preferred_color_scheme = "dark"
c.colors.webpage.bg = "black"
c.colors.webpage.darkmode.enabled = False # disable by default
# }}}
# }}}
# vim: fdm=marker
