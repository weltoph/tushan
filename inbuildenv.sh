#!/bin/env bash
podman run --rm -v /home/privtoph/src/tushan:/tushan -w /tushan -it ada-build:latest "$@"
