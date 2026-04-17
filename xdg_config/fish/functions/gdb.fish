function gdb --wraps gdb --description 'alias to gdbdash'
  env ASAN_OPTIONS=detect_leaks=0 gdb -nh -ix ~/.config/gdb/gdbdashinit $argv
end
