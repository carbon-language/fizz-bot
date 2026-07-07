#!/bin/sh
set -e

set -x
cargo build --release
sudo docker build --pull -t fizz-bot .
