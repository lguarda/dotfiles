function lsan --wraps="ASAN_OPTIONS=fast_unwind_on_malloc=0 LSAN_OPTIONS='max_leaks=1'" --description "alias lsan=ASAN_OPTIONS=fast_unwind_on_malloc=0 LSAN_OPTIONS='max_leaks=1'"
  ASAN_OPTIONS=fast_unwind_on_malloc=0 LSAN_OPTIONS='max_leaks=1' $argv
        
end
