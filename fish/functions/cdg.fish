function cdg --description 'cd relative to git root'
    if test (count $argv) -eq 1
        cd (git rev-parse --show-toplevel 2>/dev/null)/$argv[1]
    else if test (count $argv) -eq 0
        cd (git rev-parse --show-toplevel 2>/dev/null)
    end
end
