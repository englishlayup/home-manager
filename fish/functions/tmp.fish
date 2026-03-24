function tmp --description 'create temporary workspace'
    if string match "$argv[1]" = "view"
        cd /tmp/workspaces && cd (ls -t | fzf --preview 'ls -A {}') && return 0
    end
    set r /tmp/workspaces/(xxd -l3 -ps /dev/urandom)
    mkdir -p $r && pushd $r
    git init $r
end
