#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
	echo "Usage: $0 <registry-or-namespace/safe4> [version]" >&2
	echo "Example: $0 shuqijkx/safe4 v2.1.2" >&2
	exit 1
fi

TARGET_IMAGE="$1"
PACKAGE="${PACKAGE:-safe4.linux.latest.tar.gz}"

if [[ $# -ge 2 ]]; then
	SAFE4_VERSION="$2"
else
	SAFE4_VERSION="$(
		tar -tzf "$PACKAGE" \
			| sed -n 's#^\(safe4-linux-v[^/]*\)/.*#\1#p' \
			| head -n 1 \
			| sed 's/^safe4-linux-//'
	)"
fi

if [[ -z "$SAFE4_VERSION" ]]; then
	echo "Unable to detect SAFE4 version from package directory name in $PACKAGE" >&2
	exit 1
fi

LOCAL_IMAGE="${LOCAL_IMAGE:-safe4}"

docker tag "${LOCAL_IMAGE}:${SAFE4_VERSION}" "${TARGET_IMAGE}:${SAFE4_VERSION}"
docker tag "${LOCAL_IMAGE}:${SAFE4_VERSION}" "${TARGET_IMAGE}:latest"

docker push "${TARGET_IMAGE}:${SAFE4_VERSION}"
docker push "${TARGET_IMAGE}:latest"

echo "Pushed ${TARGET_IMAGE}:${SAFE4_VERSION} and ${TARGET_IMAGE}:latest"
