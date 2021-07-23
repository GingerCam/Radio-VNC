#!/bin/bash

if [[ -d "functions/" ]]; then
    for file in functions/*.sh; do
        source $file
    done
else
    echo "Functions folder doesn't exist"
fi
