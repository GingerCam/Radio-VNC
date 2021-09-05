#!/bin/bash

directorys=$(find . -type d -name __pycache__)

for file in $directorys; do
    rm -r $file
done
