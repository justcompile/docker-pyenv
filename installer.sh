#!/usr/bin/env bash

if [ ! -f /code/pyenv-versions.txt ]; then
    echo "Versions file not found, skipping"
    exit 0
fi

while read p; do
  pyenv install "$p"
done </code/pyenv-versions.txt