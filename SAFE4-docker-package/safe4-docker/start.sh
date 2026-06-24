#!/bin/sh
set -eu

cd "$(dirname "$0")"

usage() {
	cat <<'EOF'
Usage:
  ./start.sh
  ./start.sh <public-ip>
  ./start.sh <public-ip> <supernode-address>
  ./start.sh --safetest
  ./start.sh --safetest <public-ip>
  ./start.sh --safetest <public-ip> <supernode-address>

Environment:
  SAFE4_IMAGE=shuqijkx/safe4:latest
EOF
}

case "${1:-}" in
	-h|--help|help)
		usage
		exit 0
		;;
esac

if [ "$#" -gt 3 ]; then
	usage >&2
	exit 64
fi

if [ "$#" -gt 0 ] && [ "$1" = "--safetest" ]; then
	if [ "$#" -gt 3 ]; then
		usage >&2
		exit 64
	fi
elif [ "$#" -gt 0 ]; then
	case "$1" in
		-*)
			usage >&2
			exit 64
			;;
	esac
fi

if ! command -v docker >/dev/null 2>&1; then
	echo "docker command not found. Please install Docker first." >&2
	exit 127
fi

compose() {
	if docker compose version >/dev/null 2>&1; then
		docker compose -f docker-compose.yml -f .safe4-compose.args.yml "$@"
	elif command -v docker-compose >/dev/null 2>&1; then
		docker-compose -f docker-compose.yml -f .safe4-compose.args.yml "$@"
	else
		echo "docker compose not found. Please install Docker Compose." >&2
		exit 127
	fi
}

write_compose_args() {
	{
		printf 'services:\n'
		printf '  safe4:\n'
		printf '    command: ['
		first=1
		for arg in "$@"; do
			escaped="$(printf '%s' "$arg" | sed 's/\\/\\\\/g; s/"/\\"/g')"
			if [ "$first" -eq 1 ]; then
				first=0
			else
				printf ', '
			fi
			printf '"%s"' "$escaped"
		done
		printf ']\n'
	} > .safe4-compose.args.yml
}

mkdir -p /root/.safe4

SAFE4_IMAGE="${SAFE4_IMAGE:-shuqijkx/safe4:latest}"
export SAFE4_IMAGE

write_compose_args "$@"

compose pull safe4 || echo "Image pull failed or skipped; trying to start with local image: $SAFE4_IMAGE" >&2
compose up -d --remove-orphans

echo "SAFE4 started."
echo "View logs: docker logs -f safe4"
echo "Stop node: ./stop.sh"
