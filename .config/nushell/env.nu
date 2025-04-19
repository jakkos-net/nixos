$env.CARAPACE_BRIDGES = 'argcomplete'
mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu

zoxide init nushell | save -f ~/.zoxide.nu
