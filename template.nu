#---------- ATTENTION ----------#
# This file shouldn't be expected to take effect.
# You may use it as a templete to write your own ~/.config/nushell/custom.nu.
#---------- ATTENTION ----------#

##  Used by custom command "proxy".
# $env.PROXY_HTTP = "http://localhost:7890"
## Set up proxy by default.
# $env.ALL_PROXY = $env.PROXY_HTTP

## Press Ctrl-O to edit command line in nvim.
$env.EDITOR = nvim

## To add entries to PATH (on Windows you might use Path), you can use the following pattern:
$env.PATH = ($env.PATH | split row (char esep) | prepend '~/.local/bin')
# $env.PATH = ($env.PATH | split row (char esep) | prepend '~/.cargo/bin')
# $env.PATH = ($env.PATH | split row (char esep) | prepend '~/.local/share/bob/nvim-bin')
