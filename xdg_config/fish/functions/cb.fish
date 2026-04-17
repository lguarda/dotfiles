function cb --wraps='cmake --build --preset' --description 'alias cb=cmake --build --preset'
  cmake --build --preset $argv
        
end
