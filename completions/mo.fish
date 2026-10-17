# fish completions for mo (Mole for Ubuntu)
# Installed by install.sh into ~/.config/fish/completions/mo.fish

set -l mo_cmds clean uninstall optimize analyze status purge installer update

complete -c mo -f

# global options
complete -c mo -s n -l dry-run -d 'Preview everything, delete nothing'
complete -c mo -s y -l yes -d 'Skip confirmation prompts'
complete -c mo -s V -l version -d 'Print version'
complete -c mo -s h -l help -d 'Show help'

# commands
complete -c mo -n "not __fish_seen_subcommand_from $mo_cmds" -a clean -d 'Remove caches, logs and temporary files'
complete -c mo -n "not __fish_seen_subcommand_from $mo_cmds" -a uninstall -d 'Remove an app and its leftovers'
complete -c mo -n "not __fish_seen_subcommand_from $mo_cmds" -a optimize -d 'Refresh package system, databases and caches'
complete -c mo -n "not __fish_seen_subcommand_from $mo_cmds" -a analyze -d 'Explore disk usage'
complete -c mo -n "not __fish_seen_subcommand_from $mo_cmds" -a status -d 'Live system dashboard'
complete -c mo -n "not __fish_seen_subcommand_from $mo_cmds" -a purge -d 'Delete build artifacts'
complete -c mo -n "not __fish_seen_subcommand_from $mo_cmds" -a installer -d 'Remove leftover installer files'
complete -c mo -n "not __fish_seen_subcommand_from $mo_cmds" -a update -d 'Update mole itself'

# per-command options
complete -c mo -n '__fish_seen_subcommand_from clean' -l deep -d 'Also sweep all of ~/.cache, gradle, maven'
complete -c mo -n '__fish_seen_subcommand_from clean' -l user-only -d 'Skip system-level cleaning'
complete -c mo -n '__fish_seen_subcommand_from analyze' -a '(__fish_complete_directories)' -d 'Directory'
complete -c mo -n '__fish_seen_subcommand_from analyze' -l top -x -d 'Number of entries to show'
complete -c mo -n '__fish_seen_subcommand_from analyze' -l once -d 'Print once, no interactive explorer'
complete -c mo -n '__fish_seen_subcommand_from status' -l once -d 'One snapshot instead of live dashboard'
complete -c mo -n '__fish_seen_subcommand_from status' -l interval -x -d 'Refresh interval in seconds'
complete -c mo -n '__fish_seen_subcommand_from purge' -a '(__fish_complete_directories)' -d 'Directory'
complete -c mo -n '__fish_seen_subcommand_from installer' -l all-home -d 'Also scan $HOME top level'
complete -c mo -n '__fish_seen_subcommand_from update' -l check -d 'Only compare versions'
