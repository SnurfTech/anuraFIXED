#!/bin/bash
#fix the uuidgen command not found error
export DEBIAN_FRONTEND=noninteractive
sudo apt update
sudo apt upgrade -y
sudo apt install -y uuid-runtime gcc-multilib jq

#install
git submodule update --init
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env" # to import rustup in current shell
rustup install nightly-2024-10-01
rustup override set nightly-2024-10-01
rustup target add wasm32-unknown-unknown --toolchain nightly-2024-10-01
rustup target add i686-unknown-linux-gnu --toolchain nightly-2024-10-01
rustup target add wasm32-unknown-unknown --toolchain nightly
rustup target add i686-unknown-linux-gnu --toolchain nightly
make all
sed -i 's|/lib/api/Filesystem.js|/lib/api/filesystem/Filesystem.js|g' public/anura-sw.js
sed -i 's|/lib/api/LocalFS.js|/lib/api/filesystem/LocalFS.js|g' public/anura-sw.js
