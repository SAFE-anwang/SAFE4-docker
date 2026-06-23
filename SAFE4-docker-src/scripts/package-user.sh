#!/usr/bin/env bash
set -euo pipefail

PACKAGE_NAME="${PACKAGE_NAME:-safe4-docker.tar.gz}"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

mkdir -p "$tmp_dir/safe4-docker"
cp start.sh stop.sh docker-compose.yml README-docker.txt "$tmp_dir/safe4-docker/"
chmod +x "$tmp_dir/safe4-docker/start.sh" "$tmp_dir/safe4-docker/stop.sh"

tar -czf "$PACKAGE_NAME" -C "$tmp_dir" safe4-docker

echo "Created $PACKAGE_NAME"
