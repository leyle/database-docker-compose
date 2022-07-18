#!/bin/bash

BASE=$HOME/.config/replicaset
NUM=3
end_idx=$((NUM - 1))
for idx in $(seq 0 $end_idx);
do
    dst=$BASE/mgo${idx}
    cd $dst
    ./clean.sh
done

rm -rf $BASE/*
