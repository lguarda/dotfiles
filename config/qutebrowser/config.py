# {{{ Defaults
config.load_autoconfig()
# }}}
# {{{ Bindings
# keepassxc integration
config.bind('<Alt-Shift-u>', 'spawn --userscript qute-keepassxc --key F642ED23246F9615EE30AB9CA340000F06B5AD89', mode='insert')
config.bind('pw', 'spawn --userscript qute-keepassxc --key F642ED23246F9615EE30AB9CA340000F06B5AD89', mode='normal')
# }}}
# {{{ settings
c.content.blocking.adblock.lists = ['https://easylist.to/easylist/easylist.txt', 'https://easylist.to/easylist/easyprivacy.txt', 'https://easylist-downloads.adblockplus.org/easylistdutch.txt', 'https://easylist-downloads.adblockplus.org/abp-filters-anti-cv.txt', 'https://www.i-dont-care-about-cookies.eu/abp/', 'https://secure.fanboy.co.nz/fanboy-cookiemonster.txt']
c.content.pdfjs = True # pdf viewer install libjs-pdf
c.qt.args.append('widevine-path=/usr/lib/chromium/libwidevinecdm.so')
c.colors.webpage.darkmode.enabled = False # really awful disable for now
c.content.autoplay = True
# }}}
# vim: fdm=marker
