OS:=$(shell uname)
CC=gcc
CFLAGS=-Itinycc -Wall -Wextra -Werror -g
LDLIBS=-ledit -lgc -lpcre -ldl

ALL_STEPS=step0_repl step1_read_print step2_eval step3_env step4_if_fn_do step5_tco step6_file step7_quote step8_macros step9_try stepA_mal
CURRENT_STEP_NUMBER=A

.PHONY: all clean test test-current cloc docker-build

all: $(ALL_STEPS)

step0_repl: step0_repl.o
step1_read_print: step1_read_print.o hashmap.o reader.o printer.o types.o util.o
step2_eval: step2_eval.o hashmap.o reader.o printer.o types.o util.o tinycc/libtcc.a
step3_env: step3_env.o env.o hashmap.o reader.o printer.o types.o util.o tinycc/libtcc.a
step4_if_fn_do: step4_if_fn_do.o core.o env.o hashmap.o reader.o printer.o types.o util.o tinycc/libtcc.a
step5_tco: step5_tco.o core.o env.o hashmap.o reader.o printer.o types.o util.o tinycc/libtcc.a
step6_file: step6_file.o core.o env.o hashmap.o reader.o printer.o types.o util.o tinycc/libtcc.a
step7_quote: step7_quote.o core.o env.o hashmap.o reader.o printer.o types.o util.o tinycc/libtcc.a
step8_macros: step8_macros.o core.o env.o hashmap.o reader.o printer.o types.o util.o tinycc/libtcc.a
step9_try: step9_try.o core.o env.o hashmap.o reader.o printer.o types.o util.o tinycc/libtcc.a
stepA_mal: stepA_mal.o core.o env.o hashmap.o reader.o printer.o types.o util.o tinycc/libtcc.a

tinycc/libtcc.a:
	cd tinycc && ./configure && make

clean:
	rm -f $(ALL_STEPS) *.o
	cd tinycc && make clean

test: test0 test1 test2 test3 test4 test5 test6 test7 test8 test9 testA test-self-hosted

RUN_TEST_CMD=mal/runtest.py --rundir mal/tests --hard --deferrable --optional --start-timeout 1 --test-timeout 1

test0: all
	$(RUN_TEST_CMD) step0_repl.mal ../../step0_repl

test1: all
	$(RUN_TEST_CMD) step1_read_print.mal ../../step1_read_print

test2: all
	$(RUN_TEST_CMD) step2_eval.mal ../../step2_eval

test3: all
	$(RUN_TEST_CMD) step3_env.mal ../../step3_env

test4: all
	$(RUN_TEST_CMD) step4_if_fn_do.mal ../../step4_if_fn_do

test5: all
	$(RUN_TEST_CMD) step5_tco.mal ../../step5_tco

test6: all
	$(RUN_TEST_CMD) step6_file.mal ../../step6_file
	mal/run_argv_test.sh ./step6_file

test7: all
	$(RUN_TEST_CMD) step7_quote.mal ../../step7_quote

test8: all
	$(RUN_TEST_CMD) step8_macros.mal ../../step8_macros

test9: all
	$(RUN_TEST_CMD) step9_try.mal ../../step9_try

testA: all
	$(RUN_TEST_CMD) stepA_mal.mal ../../stepA_mal

test-self-hosted: all
	$(RUN_TEST_CMD) --test-timeout 30 step2_eval.mal ../../self_hosted_run
	$(RUN_TEST_CMD) --test-timeout 30 step3_env.mal ../../self_hosted_run
	$(RUN_TEST_CMD) --test-timeout 30 step4_if_fn_do.mal ../../self_hosted_run
	$(RUN_TEST_CMD) --test-timeout 30 step5_tco.mal ../../self_hosted_run
	$(RUN_TEST_CMD) --test-timeout 30 step6_file.mal ../../self_hosted_run
	$(RUN_TEST_CMD) --test-timeout 30 step7_quote.mal ../../self_hosted_run
	$(RUN_TEST_CMD) --test-timeout 30 step8_macros.mal ../../self_hosted_run
	$(RUN_TEST_CMD) --test-timeout 30 step9_try.mal ../../self_hosted_run
	$(RUN_TEST_CMD) --test-timeout 30 stepA_mal.mal ../../self_hosted_run

test-current: test$(CURRENT_STEP_NUMBER)

cloc:
	cloc .

docker-build:
	docker build . -t malcc

RUN_DOCKER_CMD=docker run --security-opt seccomp=unconfined -t -i --rm -v $(PWD):/malcc malcc

docker-bash: docker-build
	$(RUN_DOCKER_CMD) bash

docker-test: docker-build
	$(RUN_DOCKER_CMD) make test

docker-test-current: docker-build
	$(RUN_DOCKER_CMD) make test-current

docker-watch: docker-build
	$(RUN_DOCKER_CMD) bash -c "ls *.c *.h Makefile | entr -c -s 'make test-current'"
