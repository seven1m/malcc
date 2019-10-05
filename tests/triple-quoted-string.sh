#!/usr/bin/env bash

set -e

expected="\"\\nhello world\\n\\\"stuff\\\"\\nline 2\\n\"
\"\\n  here is a string\\n\""

actual=`./malcc tests/triple-quoted-string.mal 2>&1`

echo "Testing the reader understands triple-quoted strings"
if [[ "$actual" == "$expected" ]]; then
  echo "  pass"
else
  echo "FAILURE:"
  echo "expected: $expected"
  echo "actual:   $actual"
  exit 1
fi
