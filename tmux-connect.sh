#!/bin/bash

set -x

# example usage:
# $> ./tmux_connect_to_nodes.sh

tmux splitw -v "geth attach 'http://localhost:20000?PSI=PSA' ; bash"\; \
    splitw -h "geth attach 'http://localhost:20000?PSI=PSB' ; bash"\; \
    selectp -t 1\; \
    splitw -h "geth attach 'http://localhost:20000?PSI=PSC' ; bash"\; \
    selectp -t 1\; ;
geth attach http://localhost:20002
