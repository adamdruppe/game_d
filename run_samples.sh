#!/bin/bash

echo "Wich sample to run:"

select d in samples/*; do test -n ">> $d" && break; echo ">>> Invalid Selection"; done

result=$(basename $d)

echo "Running $d -> $result"

dub run :$result --arch=x86_64 --build=debug