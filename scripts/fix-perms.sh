#!/bin/bash


# # # # # # # # # # #
# If you are in mac and you lsp is giving error saying 'lsp.log is to log' do the following:

# 1. Create a file nvim.conf in '/etc/newsyslog.d/nvim.conf'
# 2. Past the below code:
# /Users/niranjanshk/.local/state/nvim/lsp.log 644 0 1000 * Z /Users/niranjanshk/.config/nvim/dummy.pid 1 /Users/niranjanshk/.config/nvim/scripts/fix-perms.sh
#
# # # # # # # # # # #

chown niranjanshk:staff /Users/niranjanshk/.local/state/nvim/lsp.log*

