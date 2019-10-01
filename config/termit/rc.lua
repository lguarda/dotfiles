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

setOptions(defaults)

function toggleSearch()
    toggleMenubar()
    findDlg()
end

bindKey('CtrlShift-c', copy)
bindKey('CtrlShift-v', paste)
bindKey('CtrlShift-r', reconfigure)
--bindKey('Ctrl-F', toggleSearch)
bindKey('Ctrl-N', findNext)
bindKey('Ctrl-P', findPrev)
bindKey('Ctrl-F', findDlg)

--bindKey('Ctrl-Page_Up', prevTab)
--bindKey('Ctrl-Page_Down', nextTab)
--bindKey('Ctrl-F', findDlg)
--bindKey('Ctrl-2', function () print('Hello2!') end)
--bindKey('Ctrl-3', function () print('Hello3!') end)
--bindKey('Ctrl-3', nil) -- remove previous binding
