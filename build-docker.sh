#!/bin/sh
set -e

set -x
cargo build --release || exit 1
sudo docker build --pull -t fizz-bot . || exit 1

