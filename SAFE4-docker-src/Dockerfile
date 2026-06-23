FROM debian:bullseye-slim

ARG SAFE4_VERSION
ARG BUILD_DATE
ARG VCS_REF

LABEL org.opencontainers.image.title="SAFE4" \
      org.opencontainers.image.description="SAFE4 official Linux package runtime image" \
      org.opencontainers.image.version="${SAFE4_VERSION}" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.revision="${VCS_REF}" \
      org.opencontainers.image.source="safe4"

WORKDIR /opt

ADD safe4.linux.latest.tar.gz /opt/

RUN set -eu; \
	pkg_dir="$(find /opt -maxdepth 1 -type d -name 'safe4-linux-*' | head -n 1)"; \
	test -n "$pkg_dir"; \
	mv "$pkg_dir" /opt/safe4; \
	chmod +x /opt/safe4/bin/geth /opt/safe4/start.sh /opt/safe4/monitor.sh; \
	cp /opt/safe4/start.sh /opt/safe4/start.original.sh; \
	{ \
		echo '#!/bin/sh'; \
		echo 'set -eu'; \
		echo 'cd "$(dirname "$0")"'; \
		echo 'chmod +x ./bin/geth'; \
		echo ''; \
		echo 'chain_type=""'; \
		echo 'if [ "${1:-}" = "--safetest" ]; then'; \
		echo '	chain_type="--safetest"'; \
		echo '	shift'; \
		echo 'fi'; \
		echo ''; \
		echo 'if [ -z "$chain_type" ]; then'; \
		echo '	rm -rf /root/.safe4/geth/nodes'; \
		echo 'else'; \
		echo '	rm -rf /root/.safe4/safetest/geth/nodes'; \
		echo 'fi'; \
		echo ''; \
		echo 'if [ "$#" -eq 0 ]; then'; \
		echo '	exec ./bin/geth $chain_type --rpc.evmtimeout 600s'; \
		echo 'elif [ "$#" -eq 1 ]; then'; \
		echo '	exec ./bin/geth $chain_type --nat "extip:$1" --rpc.evmtimeout 600s'; \
		echo 'else'; \
		echo '	mkdir -p /root/.safe4'; \
		echo '	cp ./bin/static-nodes.json /root/.safe4/static-nodes.json'; \
		echo '	exec ./bin/geth $chain_type --nat "extip:$1" --rpc.evmtimeout 300s --maxpeers 400 --maxpendpeers 400 --unlock "$2" --password ./bin/password.txt --mine --miner.etherbase "$2"'; \
		echo 'fi'; \
	} > /opt/safe4/start.sh; \
	chmod +x /opt/safe4/start.sh

WORKDIR /opt/safe4

EXPOSE 30303/tcp 30303/udp 8545/tcp 8546/tcp

ENTRYPOINT ["./start.sh"]
