.PHONY: docs tests

docs: tests
	./inenv.sh gnatdoc -Ptushan --no-subprojects

tests:
	./inenv.sh gprbuild -p -Ptushan
	./inenv.sh ./bin/run_tests
