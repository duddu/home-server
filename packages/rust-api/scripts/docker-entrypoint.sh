#!/bin/bash

set -e

(./websocketd --port=8889 --devconsole tail -f rust-api.logs) & 
script -fq -c ./home-server-rust-api rust-api.logs