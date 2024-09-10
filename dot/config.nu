$env.PROMPT_COMMAND = {||
    let dir = if ($env.PWD | path split | zip ($nu.home-path | path split) | all { $in.0 == $in.1 }) {
            ($env.PWD | str replace $nu.home-path "~") # replace homepath with ~
        } else {
            $env.PWD
        }
    $"(ansi blue_bold)($dir)(git_branch)" | str replace --all (char path_sep) $"(ansi light_blue_bold)(char path_sep)(ansi blue_bold)"
}

def git_branch [] {
    let x = do { git status } | complete
    if $x.exit_code == 0 {
        $x.stdout | split row "\n" | first | str replace "On branch " $"(ansi white)|(ansi magenta)"
    } else {
        ""
    }
}

$env.EDITOR = "hx"

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
alias gitdoc = , watchexec -d 30s "git stage -A; git commit -m 'auto-commit on file change'; git pull --rebase; git push"
def findrep [from, to] { fd --type file --exec sd $from $to }
def bg [cmd] { bash -c $"($cmd) &" }

def ghclone [repo_name] { git clone $"git@github.com:jakkos-net/($repo_name)" }
def ghpush [new_repo_name] {
  , gh repo create $new_repo_name --private --source=. --remote=upstream
  git push --set-upstream upstream master
}
