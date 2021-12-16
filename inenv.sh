#!/bin/env bash
podman run --rm --env HOST_OS=Linux -v /home/privtoph/src/tushan:/tushan -w /tushan -it ada-build:latest "$@"
