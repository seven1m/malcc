#include <assert.h>
#include <gc.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/time.h>

#include "env.h"
#include "core.h"
#include "reader.h"
#include "printer.h"
#include "types.h"
#include "util.h"

struct hashmap* core_ns() {
  struct hashmap *ns = GC_MALLOC(sizeof(struct hashmap));
  hashmap_init(ns, hashmap_hash_string, hashmap_compare_string, 100);
  hashmap_set_key_alloc_funcs(ns, hashmap_alloc_key_string, NULL);
  hashmap_put(ns, "+", core_add);
  hashmap_put(ns, "-", core_sub);
  hashmap_put(ns, "*", core_mul);
  hashmap_put(ns, "/", core_div);
  hashmap_put(ns, "count", core_count);
  hashmap_put(ns, "prn", core_prn);
  hashmap_put(ns, "list", core_list);
  hashmap_put(ns, "list?", core_is_list);
  hashmap_put(ns, "empty?", core_is_empty);
  hashmap_put(ns, "=", core_is_equal);
  hashmap_put(ns, ">", core_is_gt);
  hashmap_put(ns, ">=", core_is_gte);
  hashmap_put(ns, "<", core_is_lt);
  hashmap_put(ns, "<=", core_is_lte);
  hashmap_put(ns, "pr-str", core_pr_str);
  hashmap_put(ns, "str", core_str);
  hashmap_put(ns, "println", core_println);
  return ns;
}

MalType* core_add(MalEnv *env, size_t argc, MalType **args) {
  UNUSED(env);
  if (argc == 0) {
    return mal_number(0);
  } else {
    long long result = args[0]->number;
    for (size_t i=1; i<argc; i++) {
      result += args[i]->number;
    }
    return mal_number(result);
  }
}

MalType* core_sub(MalEnv *env, size_t argc, MalType **args) {
  UNUSED(env);
  assert(argc > 0);
  long long result = args[0]->number;
  for (size_t i=1; i<argc; i++) {
    result -= args[i]->number;
  }
  return mal_number(result);
}

MalType* core_mul(MalEnv *env, size_t argc, MalType **args) {
  UNUSED(env);
  if (argc == 0) {
    return mal_number(1);
  } else {
    long long result = args[0]->number;
    for (size_t i=1; i<argc; i++) {
      result *= args[i]->number;
    }
    return mal_number(result);
  }
}

MalType* core_div(MalEnv *env, size_t argc, MalType **args) {
  UNUSED(env);
  assert(argc > 0);
  long long result = args[0]->number;
  for (size_t i=1; i<argc; i++) {
    result /= args[i]->number;
  }
  return mal_number(result);
}

MalType* core_count(MalEnv *env, size_t argc, MalType **args) {
  UNUSED(env);
  mal_assert(argc == 1, "Expected 1 argument to count");
  MalType *arg = args[0];
  switch (arg->type) {
    case MAL_EMPTY_TYPE:
    case MAL_NIL_TYPE:
      return mal_number(0);
    case MAL_CONS_TYPE:
      return mal_number(mal_list_len(arg));
    case MAL_VECTOR_TYPE:
      return mal_number(mal_vector_len(arg));
    default:
      printf("Object type to count not supported\n");
      return mal_nil();
  }
}

MalType* core_prn(MalEnv *env, size_t argc, MalType **args) {
  UNUSED(env);
  MalType *out = mal_string("");
  for (size_t i=0; i<argc; i++) {
    mal_string_append(out, pr_str(args[i], 1));
    if (i < argc-1) mal_string_append_char(out, ' ');
  }
  printf("%s\n", out->str);
  return mal_nil();
}

MalType* core_list(MalEnv *env, size_t argc, MalType **args) {
  UNUSED(env);
  MalType *vec = mal_vector();
  for (size_t i=0; i<argc; i++) {
    mal_vector_push(vec, args[i]);
  }
  return mal_vector_to_list(vec);
}

MalType* core_is_list(MalEnv *env, size_t argc, MalType **args) {
  UNUSED(env);
  mal_assert(argc == 1, "Expected 1 argument to list?");
  MalType *arg = args[0];
  return is_empty(arg) || is_cons(arg) ? mal_true() : mal_false();
}

MalType* core_is_empty(MalEnv *env, size_t argc, MalType **args) {
  UNUSED(env);
  mal_assert(argc == 1, "Expected 1 argument to empty?");
  MalType *arg = args[0];
  if (is_empty(arg)) return mal_true();
  if (is_vector(arg) && arg->vec_len == 0) return mal_true();
  return mal_false();
}

MalType* core_is_equal(MalEnv *env, size_t argc, MalType **args) {
  UNUSED(env);
  mal_assert(argc == 2, "Expected 2 argument to =");
  return is_equal(args[0], args[1]) ? mal_true() : mal_false();
}

MalType* core_is_gt(MalEnv *env, size_t argc, MalType **args) {
  UNUSED(env);
  mal_assert(argc == 2, "Expected 2 argument to >");
  MalType *arg1 = args[0];
  MalType *arg2 = args[1];
  mal_assert(is_number(arg1) && is_number(arg2), "Both arguments to > must be numbers");
  return arg1->number > arg2->number ? mal_true() : mal_false();
}

MalType* core_is_gte(MalEnv *env, size_t argc, MalType **args) {
  UNUSED(env);
  mal_assert(argc == 2, "Expected 2 argument to >=");
  MalType *arg1 = args[0];
  MalType *arg2 = args[1];
  mal_assert(is_number(arg1) && is_number(arg2), "Both arguments to >= must be numbers");
  return arg1->number == arg2->number || arg1->number > arg2->number ? mal_true() : mal_false();
}

MalType* core_is_lt(MalEnv *env, size_t argc, MalType **args) {
  UNUSED(env);
  mal_assert(argc == 2, "Expected 2 argument to <");
  MalType *arg1 = args[0];
  MalType *arg2 = args[1];
  mal_assert(is_number(arg1) && is_number(arg2), "Both arguments to < must be numbers");
  return arg1->number < arg2->number ? mal_true() : mal_false();
}

MalType* core_is_lte(MalEnv *env, size_t argc, MalType **args) {
  UNUSED(env);
  mal_assert(argc == 2, "Expected 2 argument to <=");
  MalType *arg1 = args[0];
  MalType *arg2 = args[1];
  mal_assert(is_number(arg1) && is_number(arg2), "Both arguments to <= must be numbers");
  return arg1->number == arg2->number || arg1->number < arg2->number ? mal_true() : mal_false();
}

MalType* core_pr_str(MalEnv *env, size_t argc, MalType **args) {
  UNUSED(env);
  MalType *out = mal_string("");
  for (size_t i=0; i<argc; i++) {
    mal_string_append(out, pr_str(args[i], 1));
    if (i < argc-1) mal_string_append_char(out, ' ');
  }
  return out;
}

MalType* core_str(MalEnv *env, size_t argc, MalType **args) {
  UNUSED(env);
  MalType *out = mal_string("");
  for (size_t i=0; i<argc; i++) {
    mal_string_append(out, pr_str(args[i], 0));
  }
  return out;
}

MalType* core_println(MalEnv *env, size_t argc, MalType **args) {
  UNUSED(env);
  MalType *out = mal_string("");
  for (size_t i=0; i<argc; i++) {
    mal_string_append(out, pr_str(args[i], 0));
    if (i < argc-1) mal_string_append_char(out, ' ');
  }
  printf("%s\n", out->str);
  return mal_nil();
}
