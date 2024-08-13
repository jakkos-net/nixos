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
