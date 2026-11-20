#!/usr/bin/env sh

cat ~/.local/state/hel/sequences.txt 2>/dev/null

exec "$@"
