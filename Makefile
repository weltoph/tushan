.PHONY: tests docs

tests:
	gprbuild -p -Ptushan
	./bin/run_tests

docs:
	gnatdoc -Ptushan --no-subprojects
