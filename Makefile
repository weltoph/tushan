.PHONY: main tests

tests:
	gprbuild -P tests
	./dist/run_tests

main:
	gprbuild -P main
