#!/bin/bash

BOOTSTRAP_FILE="bootstrap.conf"
BOOTSTRAP_PATH="`pwd`/${BOOTSTRAP_FILE}"

# Bootstrap file is needed to set environment variables for docker-compose
if [[ ! -a "${BOOTSTRAP_PATH}" ]]; then
    echo "Please create '${BOOTSTRAP_FILE}' file to continue." 1>&2
    exit 1
fi

# Must pass at least one argument to docker-compose
if [[ ! $1 ]]; then
    echo "Usage: dcompose <docker_compose_arg1> [<docker_compose_arg2>, ...]" 1>&2
    exit 1
fi

# Check to see if docker-compose is installed and install if necessary
hash docker-compose 2>/dev/null || {
    echo "\nInstalling docker-compose.."

    if [[ $(id -u) != "0" ]]; then
        sudo mkdir -p /opt/bin
        sudo curl -oL https://github.com/docker/compose/releases/download/1.5.2/docker-compose-`uname -s`-`uname -m`
        sudo chmod +x /opt/bin/docker-compose
    fi
}

# Export environment variables
source "${BOOTSTRAP_PATH}"

# Run docker-compose commands
docker-compose "$@"