# malcc

Mal (Make A Lisp) C Compiler

## Overview

[Mal](https://github.com/kanaka/mal) is Clojure inspired Lisp interpreter
created by Joel Martin.

This project is an incremental compiler implementation for the Mal language.
It uses the [Tiny C Compiler](https://bellard.org/tcc/) as the compiler backend
and has full support for the language, including macros, tail-call elimination,
and even run-time eval.

## License

This project's sourcecode is copyrighted by Tim Morgan and licensed under the
MIT license, included in the `LICENSE` file in this repository.

The subdirectory `mal` contains a copy of the Mal language repository and is
copyrighted by Joel Martin and released under the Mozilla Public License 2.0
(MPL 2.0). The text of the MPL 2.0 license is included in the `mal/LICENSE`
file.
