$env.config = {
    show_banner: false # true or false to enable or disable the welcome banner at startup
    rm: {
        always_trash: true # always act as if -t was given. Can be overridden with -p
    }
}

alias zz = z ../
alias h = hx
alias j = just
alias g = gitui
alias b = bacon
alias up = sudo nixos-rebuild switch --flake ~/nixos#machine
alias fu = sudo nix flake update
alias ns = nix-shell -p
alias y = yazi
alias gitdoc = watchexec -d 30000 "git stage -A; git commit -m 'auto-commit on file change'; git pull --rebase; git push"
alias arch = distrobox enter arch

def zh [dir] {
  z $dir
  h
}

def fup [] {
  fu
  up
}

def resetarch [] {
  distrobox stop arch
  distrobox rm arch
  distrobox create -i docker.io/archlinux:latest -n arch
  arch
}

def nsr [pkg cmd] {
  nix-shell -p $pkg --run $"($pkg) ($cmd)"
}

def ghclone [repo_name] {
  git clone $"git@github.com:jakkos-net/($repo_name)" 
}

def ghpush [new_repo_name] {
  gh repo create $new_repo_name --private --source=. --remote=upstream
  git push --set-upstream upstream master
}

def findrep [from, to] {
  fd --type file --exec sd $from $to
}

def csview [file] {
  ^csview $file | less -S
}
