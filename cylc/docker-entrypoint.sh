#!/bin/bash

set -e

# Kick-off the at-daemon
sudo service atd start > /dev/null

if [ -z "$1" ]
then
    exec "/bin/bash"
else
    exec "$1"
fi
