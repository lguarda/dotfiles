function lsanoff --wraps=ASAN_OPTIONS=detect_leaks=0 --description 'alias lsanoff=ASAN_OPTIONS=detect_leaks=0'
  ASAN_OPTIONS=detect_leaks=0 $argv
        
end
