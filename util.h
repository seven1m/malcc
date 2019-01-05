#ifndef __MAL_UTIL__
#define __MAL_UTIL__

#include <stddef.h>

#define UNUSED(x) (void)(x)

#define mal_assert(val, message) if (!(val)) { return mal_error(message); }

char* long_long_to_string(long long num);
size_t num_char_len(long long num);
char* string(char *str);

#endif
