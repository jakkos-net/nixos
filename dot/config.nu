$env.config = {
    show_banner: false # true or false to enable or disable the welcome banner at startup
    rm: { always_trash: true } # always act as if -t was given. Can be overridden with -p}
}

alias zz = cd ./..
alias h = hx
alias j = just
alias g = gitui
alias up = sudo nixos-rebuild switch --flake "."
alias fu = sudo nix flake update
alias y = yazi
alias gitdoc = watchexec -d 30000 "git stage -A; git commit -m 'auto-commit on file change'; git pull --rebase; git push"

def findrep [from, to] { fd --type file --exec sd $from $to }
def bg [cmd] { bash -c $"($cmd) &" }
def ghclone [repo_name] { git clone $"git@github.com:jakkos-net/($repo_name)" }

def ghpush [new_repo_name] {
  gh repo create $new_repo_name --private --source=. --remote=upstream
  git push --set-upstream upstream master
}
