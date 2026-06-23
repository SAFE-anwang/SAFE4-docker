#!/usr/bin/env bash
set -euo pipefail

PACKAGE="${PACKAGE:-safe4.linux.latest.tar.gz}"
IMAGE_NAME="${IMAGE_NAME:-safe4}"

if [[ ! -f "$PACKAGE" ]]; then
	echo "Package not found: $PACKAGE" >&2
	exit 1
fi

SAFE4_VERSION="$(
	tar -tzf "$PACKAGE" \
		| sed -n 's#^\(safe4-linux-v[^/]*\)/.*#\1#p' \
		| head -n 1 \
		| sed 's/^safe4-linux-//'
)"

if [[ -z "$SAFE4_VERSION" ]]; then
	echo "Unable to detect SAFE4 version from $PACKAGE" >&2
	exit 1
fi

BUILD_DATE="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
VCS_REF="$(git rev-parse --short HEAD 2>/dev/null || echo unknown)"

docker build \
	--build-arg "SAFE4_VERSION=${SAFE4_VERSION}" \
	--build-arg "BUILD_DATE=${BUILD_DATE}" \
	--build-arg "VCS_REF=${VCS_REF}" \
	-t "${IMAGE_NAME}:${SAFE4_VERSION}" \
	-t "${IMAGE_NAME}:latest" \
	.

echo "Built ${IMAGE_NAME}:${SAFE4_VERSION} and ${IMAGE_NAME}:latest"
