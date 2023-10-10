#!/bin/bash

# This script uses the logspout and http stream tools to let you watch the docker containers
# in action.
#
# More information at https://github.com/gliderlabs/logspout/tree/master/httpstream

DOCKER_NETWORK=mongodb-dev
PORT=18000

echo Starting monitoring on all containers on the network ${DOCKER_NETWORK}

docker kill logspout 2> /dev/null 1>&2 || true
docker rm logspout 2> /dev/null 1>&2 || true

docker run -d --name="logspout" \
	--volume=/var/run/docker.sock:/var/run/docker.sock \
	--publish=127.0.0.1:${PORT}:80 \
	--network  ${DOCKER_NETWORK} \
	gliderlabs/logspout
sleep 3
curl http://127.0.0.1:${PORT}/logs
