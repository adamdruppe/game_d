#!/bin/bash

echo "Wich sample to run:"

select d
in samples/*;
do test -n ">> $d" && break; echo ">>> Invalid Selection";
done

result=$(basename $d)

echo "Running $d -> $result"

cd $d
dub run  --arch=x86_64 --build=debug