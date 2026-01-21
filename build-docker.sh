#!/bin/sh
set -e

cargo build --release
sudo docker build --pull -t fizz-bot .

