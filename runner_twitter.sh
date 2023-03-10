#!/bin/sh
# cron だとうまくいかない（carbon-now cli）ときなどに

while true; do
    echo "checking..."
    env/bin/python3 main.py twitter
    sleep 120
done
