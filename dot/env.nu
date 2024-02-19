$env.PROMPT_COMMAND = {||
    let home =  $nu.home-path
    # replace home with ~
    let dir = (
        if ($env.PWD | path split | zip ($home | path split) | all { $in.0 == $in.1 }) {
            ($env.PWD | str replace $home "~")
        } else {
            $env.PWD
        }
    )
    $"(ansi green_bold)($dir)(git_branch)" | str replace --all (char path_sep) $"(ansi light_green_bold)(char path_sep)(ansi green_bold)"
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
# $env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')
