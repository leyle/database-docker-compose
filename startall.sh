#!/bin/bash

for d in ./*/
do
    cd "$d"
    ./start.sh
    cd ../
done

docker ps
