SAFE4 Docker user package
=========================

This package lets users run SAFE4 with simple scripts instead of long Docker
commands.

User package files:

  start.sh
  stop.sh
  docker-compose.yml
  README-docker.txt

start.sh automatically creates .safe4-compose.args.yml for the selected startup
parameters. Users do not need to edit that generated file.

The Docker image is:

  shuqijkx/safe4:latest

The image is built from the official SAFE4 Linux package:

  safe4.linux.latest.tar.gz

Inside the image, SAFE4 starts through:

  /opt/safe4/start.sh

The parameters are the same as the official SAFE4 start.sh.


Install Docker
--------------

The server must have Docker and Docker Compose installed.

Check:

  docker version
  docker compose version


Start SAFE mainnet common node
------------------------------

  chmod +x start.sh stop.sh
  ./start.sh

This creates /root/.safe4 on the host and starts the SAFE4 container.
The startup parameters are written to .safe4-compose.args.yml automatically.


Start SAFE mainnet masternode
-----------------------------

  ./start.sh <public-ip>

Example:

  ./start.sh 1.2.3.4


Start SAFE mainnet supernode
----------------------------

  ./start.sh <public-ip> <supernode-address>

Example:

  ./start.sh 1.2.3.4 0x963879154e7b7472c712006a8f48e9dba59ced1e


Start safetest common node
--------------------------

  ./start.sh --safetest


Start safetest masternode
-------------------------

  ./start.sh --safetest <public-ip>


Start safetest supernode
------------------------

  ./start.sh --safetest <public-ip> <supernode-address>


View logs
---------

  docker logs -f safe4

If your server has Docker Compose v1 and you prefer compose logs:

  docker-compose logs -f safe4


Stop SAFE4
----------

  ./stop.sh


Data directory
--------------

Host data directory:

  /root/.safe4

Container data directory:

  /root/.safe4

docker-compose.yml maps them together:

  /root/.safe4:/root/.safe4


Use a fixed image version
-------------------------

By default start.sh uses:

  shuqijkx/safe4:latest

To run a fixed version:

  SAFE4_IMAGE=shuqijkx/safe4:v2.1.2 ./start.sh

For masternode:

  SAFE4_IMAGE=shuqijkx/safe4:v2.1.2 ./start.sh 1.2.3.4


Build and publish image
=======================

Builder package files:

  Dockerfile
  .dockerignore
  docker-compose.yml
  safe4.linux.latest.tar.gz
  scripts/build-image.sh
  scripts/push-image.sh
  start.sh
  stop.sh
  README-docker.txt

Build:

  chmod +x scripts/*.sh start.sh stop.sh
  ./scripts/build-image.sh

The image version is detected from the top-level package directory name inside
safe4.linux.latest.tar.gz, for example:

  safe4-linux-v2.1.2 -> v2.1.2

Push to Docker Hub:

  docker login
  ./scripts/push-image.sh shuqijkx/safe4

This pushes both:

  shuqijkx/safe4:<version>
  shuqijkx/safe4:latest
