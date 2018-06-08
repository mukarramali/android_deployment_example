#!/usr/bin/env bash
set -xeuo pipefail

docker_image=mukarramali98/androidbase

docker build -t ${docker_image} -f ./scripts/Dockerfile .
