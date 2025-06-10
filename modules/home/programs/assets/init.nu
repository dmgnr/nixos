let __is_escape_value = {|x| $x | str replace --all "\\" "\\\\" | str replace --all ";" "\\x3b" | str replace --all "\n" '\x0a' | str replace --all "\e" "\\x1b" | str replace --all "\a" "\\x07" }
let __is_original_PROMPT_COMMAND = if 'PROMPT_COMMAND' in $env { $env.PROMPT_COMMAND } else { "" }
let __is_original_PROMPT_INDICATOR = if 'PROMPT_INDICATOR' in $env { $env.PROMPT_INDICATOR } else { "" }

let __is_update_cwd = { 
    let pwd = do $__is_escape_value $env.PWD
    $"\e]6973;CWD;($pwd)\a" 
}
let __is_report_prompt = { 
    let __is_indicatorCommandType = $__is_original_PROMPT_INDICATOR | describe
    mut __is_prompt_ind = if $__is_indicatorCommandType == "closure" { do $__is_original_PROMPT_INDICATOR } else { $__is_original_PROMPT_INDICATOR }
    let __is_esc_prompt_ind = do $__is_escape_value $__is_prompt_ind
    $"\e]6973;PROMPT;($__is_esc_prompt_ind)\a"
}
let __is_custom_PROMPT_COMMAND = {
    let promptCommandType = $__is_original_PROMPT_COMMAND | describe
    mut cmd = if $promptCommandType == "closure" { do $__is_original_PROMPT_COMMAND } else { $__is_original_PROMPT_COMMAND }
    let pwd = do $__is_update_cwd
    let prompt = do $__is_report_prompt
    if 'ISTERM_TESTING' in $env {
        $cmd = ""
    }
    $"\e]6973;PS\a($cmd)($pwd)($prompt)"
}
$env.PROMPT_COMMAND = $__is_custom_PROMPT_COMMAND

let __is_original_PROMPT_INDICATOR = if 'PROMPT_INDICATOR' in $env { $env.PROMPT_INDICATOR } else { "" }
let __is_custom_PROMPT_INDICATOR = {
    let indicatorCommandType = $__is_original_PROMPT_INDICATOR | describe
    mut ind = if $indicatorCommandType == "closure" { do $__is_original_PROMPT_INDICATOR } else { $__is_original_PROMPT_INDICATOR }
    if 'ISTERM_TESTING' in $env {
        $ind = "> "
    }
    $"($ind)\e]6973;PE\a"
}
$env.PROMPT_INDICATOR = $__is_custom_PROMPT_INDICATOR

# pay-respects
def --env f [] {
	let dir = (with-env {
        _PR_LAST_COMMAND: (history | last).command,
        _PR_ALIAS: (help aliases | select name expansion | each ({ |row| $row.name + "=" + $row.expansion }) | str join (char nl)),
        _PR_SHELL: nu,
        _PR_PACKAGE_MANAGER: nix
    } { ~/.nix-profile/bin/pay-respects })
	cd $dir
}

$env.config.hooks.command_not_found = {
    |command: string|
	let dir = (with-env {
        _PR_LAST_COMMAND: $command,
        _PR_ALIAS: (help aliases | select name expansion | each ({ |row| $row.name + "=" + $row.expansion }) | str join (char nl)),
        _PR_SHELL: nu,
        _PR_PACKAGE_MANAGER: nix,
        _PR_MODE: cnf
    } { ~/.nix-profile/bin/pay-respects })
	cd $dir
}

# Useful commands

# Set hyprpaper wallpaper
# 
# Don't pass a path to use the default wallpaper
def wallpaper [
    path?: path,     # path to the wallpaper
    --screen: string # screen to set the wallpaper for, defaults to all
] {
    if $path == null {
        systemctl --user restart hyprpaper
    } else if ($path | path exists) {
        hyprctl hyprpaper preload $path
        hyprctl hyprpaper wallpaper $"($screen),($path)"
    } else {
        echo $"Wallpaper path does not exist: ($path)"
    }
}

# Rank most used commands from history
def rank [
    --last: int = 500 # number of last commands to consider, defaults to 500
    --limit: int = 20 # number of commands to return, defaults to 20
] {
    history | last $last
     | group-by { get command | split words | get -i 0 }
     | transpose cmd list
     | par-each {{ "command": $in.cmd, "count": ($in.list | length) }}
     | sort-by count --reverse
     | first $limit
}

# Useful commands transformed to nu format
def --wrapped mount [...args] { 
    if ($args | length) > 0 {
        ^mount ...$args
    } else {
        ^mount | parse "{t} on {path} type {type} ({param})" | reject t
    }
}

def --wrapped git [...args] {
    if ($args | length) == 0 {
        ^git
    } else if $args.0 == "log" {
        return (git log --pretty=%h»¦«%s»¦«%aN»¦«%aE»¦«%aD ...($args | skip 1) | lines | split column "»¦«" commit subject name email date | upsert date {|d| $d.date | into datetime})
    } else {
        ^git ...$args
    }
}

# Wrapper around nix commands with some aliases
def --wrapped nix [...args] {
    if ($args | length) == 0 {
        ^nix
    } else if $args.0 == "switch" {
        nh os switch $env.NH_FLAKE ...($args | skip 1)
    } else if $args.0 == "clean" {
        nh clean user ...($args | skip 1)
    } else if $args.0 == "repl" {
        if ($args | length) == 1 {
            ^nix repl $"($env.NH_FLAKE)#nixosConfigurations.(hostname)"
        } else {
            ^nix ...$args
        }
    } else if $args.0 == "shell" {
        ^nix shell ...($args | each {
            if ($in | str starts-with "-") or ($in | str contains "#") {
                $in
            } else $"nixpkgs#($in)"
        } | skip 1)
    } else {
        ^nix ...$args
    }
}

if $env.LAUNCHER? == "1" {
    $env.config.hooks.pre_execution = {
        hyprctl -q "dispatch resizeactive 0 200"
    }
    $env.config.hooks.display_output = {
        $env.config.hooks.display_output = {table}
        clear
        let output = ($in | table)
        print $output
        if ($env.CMD_DURATION_MS | into int) < 3000 {
            hyprctl -q "dispatch moveactive 0 -200"
            sleep 0.2sec
            print $output # Print it again because the resize won't show it
            input listen -t ["key"]
        }
        exit
    }
} else {
    # Initialize Inshellisense
    is
    if $env.ISTERM? != "1" {
        exit
    } else {
        clear
    }
}