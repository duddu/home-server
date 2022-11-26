#!/bin/zsh

set -e

docker system info &> /dev/null &&
  echo "⏭ Docker running" &&
  exit 0

cd "${0%/*}"

osascript -e 'tell application "System Events" to (name of processes) contains "Docker"' &> /dev/null &&
  zsh ./stop.sh

echo "⏳ Waiting for docker..."

open --background -a Docker

VM_READY=0
for i in `seq 60`
do
  sleep 5
  docker system info &> /dev/null &&
    echo "🐳 Docker ready" &&
    VM_READY=1 &&
    break
done
if test "$VM_READY" = 0
then
  echo "❌ Docker failed to start"
  exit 1
fi