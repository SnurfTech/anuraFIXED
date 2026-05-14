#!/bin/bash

for i in "$@"; do
  case "$i" in
    -x)
      export EXTREME=1
      ;;
    -a)
      export AUTO=1
      ;;
  esac
done

#fix the uuidgen command not found error
sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y uuid-runtime gcc-multilib jq

#install
git submodule update --init

if [[ $EXTREME == 1 ]]; then
  sed -i '/const app = express();/a \
\
app.all("/dns-query", async (req, res) => { \
    try { \
        const targetUrl = new URL("https://cloudflare-dns.com/dns-query"); \
        if (req.query.dns) targetUrl.searchParams.set("dns", req.query.dns); \
        const chunks = []; \
        for await (const chunk of req) chunks.push(chunk); \
        const rawBody = Buffer.concat(chunks); \
        const cfResponse = await fetch(targetUrl.toString(), { \
            method: req.method, \
            headers: { \
                "Accept": "application/dns-message", \
                "Content-Type": "application/dns-message", \
                "User-Agent": "curl/8.5.0", \
            }, \
            body: req.method === "POST" && rawBody.length > 0 ? rawBody : undefined, \
        }); \
        const data = await cfResponse.arrayBuffer(); \
        res.setHeader("Content-Type", "application/dns-message"); \
        res.setHeader("Access-Control-Allow-Origin", "*"); \
        res.status(cfResponse.status).send(Buffer.from(data)); \
    } catch (error) { \
        console.error("DNS Proxy Error:", error); \
        res.status(502).send("DNS Proxy Error"); \
    } \
});' server/server.js
  sed -i "s|cloudflare-dns.com|$CODESPACE_NAME-8000.app.github.dev|g" v86/src/browser/fake_network.js
fi

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

if [[ $AUTO == 1 ]]; then
  echo "make server" >> ~/.bashrc
fi
