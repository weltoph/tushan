#!/bin/env bash
podman run --rm --env HOST_OS=Linux -v $(pwd):/tushan -w /tushan -it ada-build:latest "$@"
