OS:=$(shell uname)
CC=gcc
CFLAGS=-Itinycc -Wall -Wextra -Werror -g
LDLIBS=-ledit -ltermcap -lgc -lpcre -ldl

.PHONY: all clean test test-current cloc docker-build

all: malcc

malcc: malcc.o core.o env.o hashmap.o printer.o reader.o types.o util.o tinycc/libtcc.a

tinycc/libtcc.a:
	cd tinycc && ./configure && make

clean:
	rm -f malcc *.o
	cd tinycc && make clean

mal-in-mal: all
	cd mal/mal && ../../malcc --compile stepA_mal.mal ../../mal-in-mal

test: test2 test3 test4 test5 test6 test7 test8 test9 testA test-malcc test-self-hosted test-supplemental test-mal-in-mal

RUN_TEST_CMD=mal/runtest.py --rundir mal/tests --hard --deferrable --optional --start-timeout 1 --test-timeout 1

test2: all
	$(RUN_TEST_CMD) step2_eval.mal ../../malcc

test3: all
	$(RUN_TEST_CMD) step3_env.mal ../../malcc

test4: all
	$(RUN_TEST_CMD) step4_if_fn_do.mal ../../malcc

test5: all
	$(RUN_TEST_CMD) step5_tco.mal ../../malcc

test6: all
	$(RUN_TEST_CMD) step6_file.mal ../../malcc
	mal/run_argv_test.sh ./malcc

test7: all
	$(RUN_TEST_CMD) step7_quote.mal ../../malcc

test8: all
	$(RUN_TEST_CMD) step8_macros.mal ../../malcc

test9: all
	$(RUN_TEST_CMD) step9_try.mal ../../malcc

testA: all
	$(RUN_TEST_CMD) step2_eval.mal ../../malcc
	$(RUN_TEST_CMD) step3_env.mal ../../malcc
	$(RUN_TEST_CMD) step4_if_fn_do.mal ../../malcc
	$(RUN_TEST_CMD) step5_tco.mal ../../malcc
	$(RUN_TEST_CMD) step6_file.mal ../../malcc
	$(RUN_TEST_CMD) step7_quote.mal ../../malcc
	$(RUN_TEST_CMD) step8_macros.mal ../../malcc
	$(RUN_TEST_CMD) step9_try.mal ../../malcc
	$(RUN_TEST_CMD) stepA_mal.mal ../../malcc

test-malcc: all
	$(RUN_TEST_CMD) step2_eval.mal ../../malcc
	$(RUN_TEST_CMD) step3_env.mal ../../malcc
	$(RUN_TEST_CMD) step4_if_fn_do.mal ../../malcc
	$(RUN_TEST_CMD) step5_tco.mal ../../malcc
	$(RUN_TEST_CMD) step6_file.mal ../../malcc
	$(RUN_TEST_CMD) step7_quote.mal ../../malcc
	$(RUN_TEST_CMD) step8_macros.mal ../../malcc
	$(RUN_TEST_CMD) step9_try.mal ../../malcc
	$(RUN_TEST_CMD) stepA_mal.mal ../../malcc

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

test-supplemental: all
	$(RUN_TEST_CMD) --test-timeout 30 ../../tests/utf-8.mal ../../malcc
	$(RUN_TEST_CMD) --test-timeout 30 ../../tests/regex.mal ../../malcc
	./tests/triple-quoted-string.sh
	$(RUN_TEST_CMD) --test-timeout 30 ../../tests/c-interop.mal ../../malcc

test-mal-in-mal: mal-in-mal
	$(RUN_TEST_CMD) --test-timeout 30 step2_eval.mal ../../mal-in-mal
	$(RUN_TEST_CMD) --test-timeout 30 step3_env.mal ../../mal-in-mal
	$(RUN_TEST_CMD) --test-timeout 30 step4_if_fn_do.mal ../../mal-in-mal
	$(RUN_TEST_CMD) --test-timeout 30 step5_tco.mal ../../mal-in-mal
	$(RUN_TEST_CMD) --test-timeout 30 step6_file.mal ../../mal-in-mal
	$(RUN_TEST_CMD) --test-timeout 30 step7_quote.mal ../../mal-in-mal
	$(RUN_TEST_CMD) --test-timeout 30 step8_macros.mal ../../mal-in-mal
	$(RUN_TEST_CMD) --test-timeout 30 step9_try.mal ../../mal-in-mal
	$(RUN_TEST_CMD) --test-timeout 30 stepA_mal.mal ../../mal-in-mal

perf: all
	cd mal/tests && ../../malcc perf1.mal && ../../malcc perf2.mal && ../../malcc perf3.mal

cloc:
	cloc --exclude-dir='tinycc,mal' --not-match-f='hashmap.*|step.*' .

docker-build:
	docker build . -t malcc

RUN_DOCKER_CMD=docker run --security-opt seccomp=unconfined -t -i --rm -v $(PWD):/malcc malcc

docker-bash: docker-build
	$(RUN_DOCKER_CMD) bash

docker-test: docker-build
	$(RUN_DOCKER_CMD) make test

docker-test-supplemental: docker-build
	$(RUN_DOCKER_CMD) make test-supplemental

docker-watch: docker-build
	$(RUN_DOCKER_CMD) bash -c "ls *.c *.h Makefile | entr -c -s 'make test'"

update-mal-directory:
	rm -rf /tmp/mal mal
	mkdir mal
	git clone https://github.com/kanaka/mal.git /tmp/mal
	cp -r /tmp/mal/LICENSE /tmp/mal/Makefile /tmp/mal/README.md /tmp/mal/core.mal /tmp/mal/mal /tmp/mal/perf.mal /tmp/mal/run_argv_test.sh /tmp/mal/runtest.py /tmp/mal/tests mal/
