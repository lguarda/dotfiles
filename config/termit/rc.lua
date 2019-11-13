defaults = {}
defaults.windowTitle = 'Termit'
defaults.startMaximized = true
defaults.hideTitlebarWhenMaximized = true
defaults.tabName = 'Terminal'
defaults.encoding = 'UTF-8'
defaults.wordCharExceptions = '- .,_/'
defaults.font = 'Monospace 12'
--defaults.foregroundColor = 'gray'
--defaults.backgroundColor = 'black'
defaults.showScrollbar = false
defaults.hideSingleTab = true
defaults.hideTabbar = false
defaults.showBorder = false
defaults.hideMenubar = true
defaults.fillTabbar = true
defaults.scrollbackLines = 1048576
defaults.geometry = '80x24'
defaults.allowChangingTitle = true
--defaults.backspaceBinding = 'AsciiBksp'
--defaults.deleteBinding = 'AsciiDel'
defaults.cursorBlinkMode = 'BlinkOff'
defaults.cursorShape = 'Ibeam'
defaults.tabPos = 'Top'
defaults.setStatusbar = function (tabInd)
    tab = tabs[tabInd]
    if tab then
        return tab.encoding..'  Bksp: '..tab.backspaceBinding..'  Del: '..tab.deleteBinding
    end
    return ''
end

local function handle_url_simple_open (url)
    -- simply opens the url
    -- requires package xdg-utils

    local url = string.gsub(url,"\n.+$", "")
    os.execute ("xdg-open '"..url.."'")
    notify (url, "opened")
end

defaults.matches = {['http[^ \'\"]+'] = handle_url_lgi }

setOptions(defaults)

local function toggleSearch()
    toggleMenubar()
    findDlg()
end

bindKey('CtrlShift-c', copy)
bindKey('CtrlShift-v', paste)
bindKey('CtrlShift-r', reconfigure)
bindKey('CtrlShift-f', toggleSearch)
bindKey('CtrlShift-n', findNext)
bindKey('CtrlShift-p', findPrev)
bindKey('Shift-Insert', function() get_primary() end)

