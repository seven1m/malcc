#ifndef __MAL_CORE__
#define __MAL_CORE__

#include <stddef.h>

#include "env.h"
#include "types.h"

struct hashmap* core_ns();
MalType* core_add(MalEnv *env, size_t argc, MalType **args);
MalType* core_sub(MalEnv *env, size_t argc, MalType **args);
MalType* core_mul(MalEnv *env, size_t argc, MalType **args);
MalType* core_div(MalEnv *env, size_t argc, MalType **args);
MalType* core_count(MalEnv *env, size_t argc, MalType **args);
MalType* core_prn(MalEnv *env, size_t argc, MalType **args);
MalType* core_list(MalEnv *env, size_t argc, MalType **args);
MalType* core_is_list(MalEnv *env, size_t argc, MalType **args);
MalType* core_is_empty(MalEnv *env, size_t argc, MalType **args);
MalType* core_is_equal(MalEnv *env, size_t argc, MalType **args);
MalType* core_is_gt(MalEnv *env, size_t argc, MalType **args);
MalType* core_is_gte(MalEnv *env, size_t argc, MalType **args);
MalType* core_is_lt(MalEnv *env, size_t argc, MalType **args);
MalType* core_is_lte(MalEnv *env, size_t argc, MalType **args);
MalType* core_pr_str(MalEnv *env, size_t argc, MalType **args);
MalType* core_str(MalEnv *env, size_t argc, MalType **args);
MalType* core_println(MalEnv *env, size_t argc, MalType **args);
MalType* core_read_string(MalEnv *env, size_t argc, MalType **args);
MalType* core_slurp(MalEnv *env, size_t argc, MalType **args);
MalType* core_atom(MalEnv *env, size_t argc, MalType **args);
MalType* core_is_atom(MalEnv *env, size_t argc, MalType **args);
MalType* core_deref(MalEnv *env, size_t argc, MalType **args);
MalType* core_reset(MalEnv *env, size_t argc, MalType **args);
MalType* core_swap(MalEnv *env, size_t argc, MalType **args);
MalType* core_cons(MalEnv *env, size_t argc, MalType **args);
MalType* core_concat(MalEnv *env, size_t argc, MalType **args);

#endif
