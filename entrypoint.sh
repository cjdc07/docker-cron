#!/bin/sh

env >> /etc/environment

printenv

# execute CMD
echo "$@"
exec "$@"
