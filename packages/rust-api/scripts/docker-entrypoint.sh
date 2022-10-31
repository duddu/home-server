#!/bin/bash

set -e

LOG_FILE=rust-api.log

(websocketd --port=9092 --devconsole tail -f $LOG_FILE) & 
script -fq -c "$@" $LOG_FILE