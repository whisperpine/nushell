#---------- ATTENTION ----------#
# This file shouldn't be expected to take effect.
# You may use it as a templete to write your own "custom.nu".
#---------- ATTENTION ----------#

## Press Ctrl-O to edit command line in nvim.
$env.EDITOR = "nvim"

## To add entries to PATH
use std "path add"
path add ~/.local/bin
# path add ~/.cargo/bin
