# preciou.sh

Swiss Army Knife for POSIX Shell

## Overview

Writes a line to standard output.

## Index

* [panic](#panic)
* [println](#println)
* [eprintln](#eprintln)
* [print](#print)
* [eprint](#eprint)
* [readln](#readln)
* [readch](#readch)
* [nop](#nop)
* [todo](#todo)
* [unimplemented](#unimplemented)
* [unreachable](#unreachable)
* [breakpoint](#breakpoint)
* [expect_eq](#expecteq)
* [expect_ne](#expectne)
* [syntax_error](#syntaxerror)
* [random_byte](#randombyte)
* [random_byte_non_null](#randombytenonnull)
* [random_garbage](#randomgarbage)
* [random_int](#randomint)
* [random_ascii](#randomascii)
* [int_add](#intadd)
* [num_add](#numadd)
* [num_sub](#numsub)
* [num_mul](#nummul)
* [make_green](#makegreen)

## core

Essential general functions.

### panic

Essential general functions.

### println

Writes a line to standard output.

### eprintln

Writes a line to standard error.

### print

Writes text to standard output.

### eprint

Writes text to standard error.

### readln

Reads one line from standard input.

### readch

Reads a single character from standard input.

### nop

Does nothing.
This can be useful for some functions as they are required to have at least one statement.

## development

Syntactic sugar for shell scripts.

### todo

Marks unfininished code.

#### Example

```bash
todo
todo "Implement this later"
todo "Implement this later, for now, we use 5" 5
```

### unimplemented

Marks unimplemented code.

### unreachable

Marks unreachable code.

### breakpoint

Signals a breakpoint.
During runtime one can press `c`, `d` or `q` to continue the program, dump variables or quit the program
respectively.

## # @sections tests

Functions intended for tests.

### expect_eq

Reports whether two values are equal.

### expect_ne

Reports whether two values are not equal.

## error

Logging utilities.

### syntax_error

Raises a syntax error.

## rand

Functions related to randomness.

### random_byte

Evaluates a random byte.

### random_byte_non_null

Evaluates a random byte that is not NULL.

### random_garbage

Evaluates random noise data.

### random_int

Evaluates a random integer.

#### Arguments

* **$1** (integer): The lower bound.
* **$2** (integer): The upper bound.

### random_ascii

Evaluates a random ASCII character.

## math

Math related functions and constants.

### int_add

Performs addition on integers.

### num_add

Performs addition on numbers.

### num_sub

Performs subtraction on numbers.

### num_mul

Performs multiplication on numbers.

## ansi

Utitlities for working with binary data.

### make_green

Applies green color on text.

