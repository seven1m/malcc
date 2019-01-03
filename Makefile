OS:=$(shell uname)
CC=gcc
CFLAGS=-Itinycc -Wall -Wextra -Werror -g
LDLIBS=-ledit

ALL_STEPS=step0_repl
CURRENT_STEP_NUMBER=0

.PHONY: all clean test test-current cloc docker-build

all: $(ALL_STEPS)

step0_repl: step0_repl.o

clean:
	rm -f $(ALL_STEPS) *.o

test: test0

RUN_TEST_CMD=mal/runtest.py --rundir mal/tests --hard --deferrable --optional --start-timeout 1 --test-timeout 1

test0: all
	$(RUN_TEST_CMD) step0_repl.mal ../../step0_repl

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
