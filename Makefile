.PHONY: run-tests

SRCDIR=src
TESTDIR=src/tests

SRC=$(wildcard ${SRCDIR}/*.ad?)
TESTSRC=$(wildcard ${TESTDIR}/*.ad?)

run-tests: dist/run_tests
	dist/run_tests

dist/run_tests: ${TESTSRC} ${SRC}
	mkdir -p .build
	mkdir -p dist
	gnatmake -aIsrc -D .build -o dist/run_tests src/tests/run_tests
