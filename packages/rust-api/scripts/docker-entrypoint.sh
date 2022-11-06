#!/bin/bash

set -e

LOG_FILE=rust-api.log

(websocketd --port=9091 --devconsole tail -f $LOG_FILE) & 
script -fq -c "$@" $LOG_FILE