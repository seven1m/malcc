OS:=$(shell uname)
CC=gcc
CFLAGS=-Itinycc -Wall -Wextra -Werror -g
LDLIBS=-ledit -lgc -lpcre

ALL_STEPS=step0_repl step1_read_print
CURRENT_STEP_NUMBER=1

.PHONY: all clean test test-current cloc docker-build

all: $(ALL_STEPS)

step0_repl: step0_repl.o
step1_read_print: step1_read_print.o hashmap.o reader.o printer.o types.o util.o

clean:
	rm -f $(ALL_STEPS) *.o

test: test0 test1

RUN_TEST_CMD=mal/runtest.py --rundir mal/tests --hard --deferrable --optional --start-timeout 1 --test-timeout 1

test0: all
	$(RUN_TEST_CMD) step0_repl.mal ../../step0_repl

test1: all
	$(RUN_TEST_CMD) step1_read_print.mal ../../step1_read_print

test-current: test$(CURRENT_STEP_NUMBER)

cloc:
	cloc .

docker-build:
	docker build . -t malcc

DOCKER_RUN_CMD=docker run --security-opt seccomp=unconfined -t -i --rm -v $(PWD):/malcc malcc

docker-bash: docker-build
	$(DOCKER_RUN_CMD) bash

docker-test: docker-build
	$(DOCKER_RUN_CMD) make test

docker-test-current: docker-build
	$(DOCKER_RUN_CMD) make test-current

docker-watch: docker-build
	$(DOCKER_RUN_CMD) bash -c "ls *.c *.h Makefile | entr -c -s 'make test-current'"
