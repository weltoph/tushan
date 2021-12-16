.PHONY: docs tests build-environment

docs: tests build-environment
	./inenv.sh gnatdoc -Ptushan --no-subprojects

tests: build-environment
	./inenv.sh gprbuild -p -Ptushan
	./inenv.sh ./bin/run_tests

build-environment: Dockerfile
	podman build -t ada-build:latest .
