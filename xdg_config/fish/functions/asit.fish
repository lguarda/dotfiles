function asit --wraps='adb shell input text' --description 'alias asit=adb shell input text'
    adb shell input text $argv
end
