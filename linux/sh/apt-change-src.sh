#!/bin/bash

prefix=/etc/apt/sources.list

if [ -z $1 ]; then
    echo "please pass argument as one of follow:"
    for file in $prefix.*; do
        if [ -f "$file" ]; then
            echo "${file/$prefix./  }"
        fi
    done
elif [ -f "$prefix.$1" ]; then
    cp -f "$prefix.$1" "$prefix"
    apt-get update
else
    echo Unknown argument >& 2
fi
