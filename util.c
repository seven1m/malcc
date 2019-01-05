#include <assert.h>
#include <gc.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "util.h"

char* long_long_to_string(long long num) {
  char* str;
  size_t len;
  if (num == 0) {
    return string("0");
  } else {
    len = num_char_len(num);
    str = GC_MALLOC(len + 1);
    snprintf(str, len + 1, "%lli", num);
    return str;
  }
}

// note: there is a formula using log10 to calculate a number length,
// but it uses the math lib which yelled at me for using TinyCC :-/
size_t num_char_len(long long num) {
  if (num < 0) {
    return 1 + num_char_len(llabs(num));
  } else if (num < 10) {
    return 1;
  } else if (num < 100) {
    return 2;
  } else if (num < 1000) {
    return 3;
  } else if (num < 10000) {
    return 4;
  } else if (num < 100000) {
    return 5;
  } else if (num < 1000000) {
    return 6;
  } else if (num < 1000000000) {
    return 9;
  } else if (num < 1000000000000) {
    return 12;
  } else if (num < 1000000000000000) {
    return 15;
  } else if (num < 1000000000000000000) {
    return 18;
  } else { // up to 128 bits
    return 40;
  }
}

char* string(char *str) {
  size_t len = strlen(str);
  char *copy = GC_MALLOC(len + 1);
  snprintf(copy, len + 1, "%s", str);
  return copy;
}
