# malcc

Mal (Make A Lisp) C Compiler

[![build status](https://builds.sr.ht/~tim/malcc.svg)](https://builds.sr.ht/~tim/malcc)

## Overview

[Mal](https://github.com/kanaka/mal) is Clojure inspired Lisp interpreter
created by Joel Martin.

**malcc** is an incremental compiler implementation for the Mal language.
It uses the [Tiny C Compiler](https://bellard.org/tcc/) as the compiler backend
and has full support for the Mal language, including macros, tail-call elimination,
and even run-time eval.

## Building and Running

malcc has been tested on Ubuntu 18.04 and macOS 10.14 Mojave. To build the
software:

```bash
git submodule update --init
make all
```

To run the REPL:

```bash
→ ./stepA_mal
Mal [malcc]
user> (+ 1 2)
3
user> ^D
```

...or to load and run a mal file:

```bash
→ ./stepA_mal examples/fib.mal
55
12586269025
```

## Speed

malcc is fast! Running the microbenchmarks on my Macbook Pro yields an
order-of-magnitude speedup for long-running code vs the C++ implementation:

**C++:**

```
→ ../cpp/stepA_mal perf1.mal
"Elapsed time: 1 msecs"
→ ../cpp/stepA_mal perf2.mal
"Elapsed time: 2 msecs"
→ ../cpp/stepA_mal perf3.mal
iters over 10 seconds: 12415
```

**malcc:**

```
→ ../../stepA_mal perf1.mal
"Elapsed time: 0 msecs"
→ ../../stepA_mal perf2.mal
"Elapsed time: 3 msecs"
→ ../../stepA_mal perf3.mal
iters over 10 seconds: 226216
```

Note: I'm not sure if this is a fair comparison, but I could not coax the C
intepreter implementation of mal to run the perf3 test, so I figured the C++
implementation was the next-best thing.

## Approach

I followed the Mal guide to implement malcc, using the same steps that any
other implementation would follow. Naturally, since malcc is a compiler
rather than a straight interpreter, there are some differences from other
implementations:

1. Additional functions not specified in the Mal guide are employed to
   generate the C code that is passed to the TinyCC compiler. These functions
   all start with `gen_` and should be fairly self-explanatory.
2. `load-file` is implemented as a special form rather than a simple function.
   This is because macros defined in a file must be found and compiled during
   code generation--they cannot be discovered at run-time.
3. I chose to publish malcc in a separate repository and have structured it to
   suit my taste. A copy of the mal implementation of mal and the mal tests
   were copied into the `mal` directory to provide test coverage.

## License

This project's sourcecode is copyrighted by Tim Morgan and licensed under the
MIT license, included in the `LICENSE` file in this repository.

The subdirectory `mal` contains a copy of the Mal language repository and is
copyrighted by Joel Martin and released under the Mozilla Public License 2.0
(MPL 2.0). The text of the MPL 2.0 license is included in the `mal/LICENSE`
file.
