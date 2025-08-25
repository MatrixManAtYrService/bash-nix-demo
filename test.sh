#!/usr/bin/env bash
echo "Bash $BASH_VERSION"

f() { break; }
for i in 1 2 3; do
    echo $i
    f
done
echo "done"
