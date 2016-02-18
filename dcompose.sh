#!/bin/bash

CONFIG_FILE="dcompose.yml"
CONFIG_PATH="`pwd`/${CONFIG_FILE}"

BOOTSTRAP_FILE="bootstrap.conf"
BOOTSTRAP_PATH="`pwd`/${BOOTSTRAP_FILE}"

# Must pass at least one argument to docker-compose
if [[ ! $1 ]]; then
    echo -e "Usage: dcompose <docker_compose_arg1> [<docker_compose_arg2>, ...]\n" 1>&2
    exit 1
fi

# Ensure dcompose.yml exists
if [[ ! -a "${CONFIG_PATH}" ]]; then
    echo "Error: cannot find '${CONFIG_FILE}'" 1>&2
    exit 1
fi

# Check to see if docker-compose is installed and install if necessary
hash docker-compose 2>/dev/null || {
    echo "Installing docker-compose.."

    if [[ $(id -u) != "0" ]]; then
        sudo mkdir -p /opt/bin
        sudo curl -oL https://github.com/docker/compose/releases/download/1.5.2/docker-compose-`uname -s`-`uname -m`
        sudo chmod +x /opt/bin/docker-compose
    fi
}

# Export environment variables
if [[ ! -a "${BOOTSTRAP_PATH}" ]]; then
    echo "Warning: '${BOOTSTRAP_FILE}' was not found in project directory."
    echo "No environment variables were exported."
else
    source "${BOOTSTRAP_PATH}"
fi

# Run docker-compose commands
docker-compose -f ${CONFIG_FILE} "$@"