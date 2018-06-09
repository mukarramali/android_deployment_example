#!/usr/bin/env bash
set -xeuo pipefail

app_name=app_name
container_name=androidcontainer

if [ ! "$(docker ps -q -f name=${container_name})" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=${container_name})" ]; then
        # cleanup
        docker rm $container_name
    fi
    # run your container
    docker run -v ${PWD}:/${app_name}/ --name ${container_name} -w /${app_name} -d -i -t mukarramali98/androidbase
fi

docker exec ${container_name} ruby /${app_name}/scripts/compile.rb -k /${app_name}/config.yaml

