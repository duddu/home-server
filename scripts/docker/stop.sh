#!/bin/zsh

set -e

echo "⏳ Stopping docker..."
osascript -e 'quit app "Docker"' &&
  echo "🛑 Docker stopped successfully" ||
  (echo "❌ Cannot stop docker" && exit 1)