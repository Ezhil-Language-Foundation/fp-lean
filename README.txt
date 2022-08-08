Functional Programming in Lean

This repository contains the in-progress book, Functional Programming in Lean, by David Thrane Christiansen.

All contents are copyright (C) Microsoft Corporation.

The book's build has been tested with:

1. Lean 4 (see the version in lean-toolchain in examples/)
2. mdbook version 0.4.17
3. Python 3.10.4
4. Pandoc 2.14.0.3
5. expect (tested with v5.45.4 but any version from the last decade should work)

To check the code examples, change to the "examples" directory and run "lake build".

To build the book, change to the "functional-programming-lean" directory and run "mdbook build". After this, "book/html/index.html" contains a multi-page Web version of the book, and "book/pandoc" contains epub and PDF versions.
