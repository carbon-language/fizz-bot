#!/bin/sh

cargo build --release || exit 1
sudo docker build . -t fizz-bot

