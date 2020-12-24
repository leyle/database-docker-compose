#!/bin/bash

for d in ./*/
do
    cd "$d"
    ./stop.sh
    cd ../
done

docker ps
