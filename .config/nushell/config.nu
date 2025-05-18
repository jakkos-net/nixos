$env.EDITOR = "hx"
$env.config = {
    show_banner: false
    hooks: {
        # direnv, after we `load-env` we have to fix the path as it's given as a string not a list
        pre_prompt: [{|| direnv export json | from json | default {} | load-env; $env.PATH = $env.PATH | split row (char env_sep)}]
    }
}
$env.PROMPT_COMMAND = {||
    let dir = if ($env.PWD | path split | zip ($nu.home-path | path split) | all { $in.0 == $in.1 }) {
            ($env.PWD | str replace $nu.home-path "~") # replace homepath with ~
        } else {
            $env.PWD
        }
    $"(ansi blue_bold)($dir)(get_git_branch)" | str replace --all (char path_sep) $"(ansi light_blue_bold)(char path_sep)(ansi blue_bold)"
}

def get_git_branch [] {
    let x = do { git status } | complete
    if $x.exit_code == 0 {
        $x.stdout | split row "\n" | first | str replace "On branch " $"(ansi white)|(ansi magenta)"
    } else {
        ""
    }
}
def findrep [from, to] { fd --type file --exec sd $from $to }
def bg [cmd] { bash -c $"($cmd) &" }
def ghclone [repo_name] { git clone $"git@github.com:jakkos-net/($repo_name)" }
def ghpush [new_repo_name] {
  , gh repo create $new_repo_name --private --source=. --remote=upstream
  git push --set-upstream upstream master
}
def dlvids [url] { , gallery-dl --filter "extension not in ('jpg', 'jpeg', 'png', 'webp', 'zip', 'rar', 'gif')" $url }
def pkgbins [pkg] { nix-locate "/bin/" -p $pkg }
def nixgc [] {
    sudo nix-collect-garbage -d # run for system
    nix-collect-garbage -d # run for user
    nix-store --optimize
}
def up [] {
    sudo nixos-rebuild switch --flake "."
    sudo fwupdmgr get-updates --no-unreported-check
}
def fwup [] {
    sudo fwupdmgr update
}
def rup [] {
    http get https://github.com/nix-community/nix-index-database/releases/latest/download/index-x86_64-linux |
    save -f ($env.HOME + "/.cache/nix-index/files")
}
def r [prog ...args] {
    try {
      nix run github:NixOS/nixpkgs/nixpkgs-unstable#($prog) -- ...$args
    } catch {
        , $prog ...$args
    }
}
alias zz = cd ./..
alias h = hx
alias j = just
alias g = gitui
alias fu = sudo nix flake update
alias da = direnv allow
alias fixnix = sudo nix-store --verify --check-contents --repair
alias gitdoc = , watchexec -d 30s "git stage -A; git commit -m 'auto-commit on file change'; git pull --rebase; git push"
alias rust_clean = , cargo-sweep sweep --recursive --time 7 ~/

# integrations with other cli tools
def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
}
source ~/.cache/carapace/init.nu
source ~/.zoxide.nu
