# aliases and custom commands for nushell

alias j = just
alias g = gitui
alias up = sudo nixos-rebuild switch --flake ~/nixos#machine
alias fu = sudo nix flake update
alias ns = nix-shell -p
alias tldr = tldr --update
alias y = yazi
alias gd = watchexec -d 30000 "git stage -A; git commit -m 'auto-commit on file change'; git pull --rebase; git push"

def nr [pkg cmd] {
  nix-shell -p $pkg --run $"($pkg) ($cmd)"
}

def gcm [repo_name] {
  git clone $"git@github.com:jakkos-net/($repo_name)" 
}

def gpr [new_repo_name] {
  gh repo create $new_repo_name --private --source=. --remote=upstream
  git push --set-upstream upstream master
}

def far [from, to] {
  fd --type file --exec sd $from $to
}
