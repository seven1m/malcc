#ifndef __MAL_UTIL__
#define __MAL_UTIL__

#include <stddef.h>

#include "env.h"
#include "types.h"

#define UNUSED(x) (void)(x)

#define mal_assert(val, message) if (!(val)) { return mal_error(message); }

char* long_long_to_string(long long num);
size_t num_char_len(long long num);
char* string(char *str);
void add_core_ns_to_env(MalEnv *env);
MalType* program_arguments_as_vector(int argc, char *argv[]);
MalType* read_file(char *filename);

#endif
