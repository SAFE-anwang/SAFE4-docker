#!/bin/sh
set -eu

cd "$(dirname "$0")"

if [ ! -f .safe4-compose.args.yml ]; then
	cat > .safe4-compose.args.yml <<'EOF'
services:
  safe4:
    command: []
EOF
fi

if ! command -v docker >/dev/null 2>&1; then
	echo "docker command not found." >&2
	exit 127
fi

if docker compose version >/dev/null 2>&1; then
	docker compose -f docker-compose.yml -f .safe4-compose.args.yml down
elif command -v docker-compose >/dev/null 2>&1; then
	docker-compose -f docker-compose.yml -f .safe4-compose.args.yml down
else
	echo "docker compose not found." >&2
	exit 127
fi

echo "SAFE4 stopped."
