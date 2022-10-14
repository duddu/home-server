#!/bin/bash

set -e

(./websocketd --port=8889 --devconsole tail -f rust-api.log) & 
script -fq -c ./home-server-rust-api rust-api.log