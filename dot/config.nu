$env.EDITOR = "hx"

$env.config = {
    show_banner: false
    rm: { always_trash: true }
}

def findrep [from, to] { fd --type file --exec sd $from $to }
def bg [cmd] { bash -c $"($cmd) &" }
def ghclone [repo_name] { git clone $"git@github.com:jakkos-net/($repo_name)" }
def ghpush [new_repo_name] {
  , gh repo create $new_repo_name --private --source=. --remote=upstream
  git push --set-upstream upstream master
}
def dlvids [url] { , gallery-dl --filter "extension not in ('jpg', 'jpeg', 'png', 'webp', 'zip', 'rar')" $url }

alias zz = cd ./..
alias h = hx
alias j = just
alias g = gitui
alias up = sudo nixos-rebuild switch --flake "."
alias fu = sudo nix flake update
alias fixnix = sudo nix-store --verify --check-contents --repair
alias y = yazi
alias gitdoc = , watchexec -d 30s "git stage -A; git commit -m 'auto-commit on file change'; git pull --rebase; git push"
alias rust_clean = , cargo-sweep sweep --recursive --time 7 ~/

