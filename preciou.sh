#!/usr/bin/env sh

# preciou.sh © 2025 by Jonas da Silva is licensed under CC BY 4.0

# vim:foldmethod=marker
# shellcheck shell=sh

# @name preciou.sh
# @version 0.1.0
# @brief Swiss Army Knife for POSIX Shell

# TODO: set -e

__storage__="${TMPDIR:=/tmp}/precioush-storage"
mkdir -p "$__storage__"
__result__="$__storage__/result"

# @section core
# @description Essential general functions.

# {{{

panic() {
  [ "$#" -lt 2 ] || arguments_error "Expected at most 1 argument; got $#"
  eprint "Program panicked"
  [ "$#" -eq 1 ] && eprint ": $1"
  eprintln
  exit 1
}

# @description Writes a line to standard output.
println() {
  [ "$#" -lt 2 ] || arguments_error "Expected at most 1 argument; got $#"
  [ "$#" -eq 1 ] && printf "%s\n" "$1"
  [ "$#" -eq 0 ] && printf "\n"
}

# @description Writes a line to standard error.
eprintln() {
  [ "$#" -lt 2 ] || arguments_error "Expected at most 1 argument; got $#"
  [ "$#" -eq 1 ] && printf "%s\n" "$1" >&2
  [ "$#" -eq 0 ] && printf "\n" >&2
}

# @description Writes text to standard output.
print() {
  [ "$#" -lt 2 ] || arguments_error "Expected at most 1 argument; got $#"
  [ "$#" -eq 1 ] && printf "%s" "$1"
  [ "$#" -eq 0 ] && nop
}

# @description Writes text to standard error.
eprint() {
  [ "$#" -lt 2 ] || arguments_error "Expected at most 1 argument; got $#"
  [ "$#" -eq 1 ] && printf "%s" "$1" >&2
  [ "$#" -eq 0 ] && nop
}

# @description Reads one line from standard input.
readln() {
  read -r input
  printf "%s" "$input" > "$__result__"
}

# @description Reads a single character from standard input.
readch() {
  stty -icanon -echo
  dd bs=1 count=1 2>/dev/null > "$__result__"
  stty icanon echo
}

# @description Does nothing.
# This can be useful for some functions as they are required to have at least one statement.
nop() {
  return 0
}

ret() {
  printf "%s" "$1" > "$__result__"
}

# }}}

# @section syntax
# @description Syntactic sugar for shell scripts.

# {{{

var() {
  [ "$#" -eq 3 ] || arguments_error "Expected 3 arguments; got $#"
  _key="$1"; shift
  _equ="$1"; shift
  _val="$1"; shift

  [ "$_equ" != "=" ] && syntax_error "Expected \`=\`; got \`$_equ\`"
  
  eval "$_key=$_val"
}

const() {
  [ "$#" -eq 3 ] || arguments_error "Expected 3 arguments; got $#"
  _key="$1"; shift
  _equ="$1"; shift
  _val="$1"; shift

  [ "$_equ" != "=" ] && syntax_error "Expected \`=\`; got \`$_equ\`"
  
  eval "$_key=$_val"
}

call() {
  printf "" > "$__result__"
  if [ "$PRECIOUSH_SAFE_RESULT" = "1" ]; then
    # This is very slow
    random_garbage
    _garbage="$(cat "$__result__")"
    printf "" > "$__result__"
  fi
  "$@"
  cat "$__result__"
  printf "%s" "$_garbage" > "$__result__"
}

# }}}

# @section development
# @description Useful functions that are commonly used during development.

# {{{

# @description Marks unfininished code.
#
# @example
#    todo
#
# @example
#    todo "Implement this later"
#
# @example
#    todo "Implement this later, for now, we use 5" 5
todo() {
  # FIXME: this function NEVER exits
  [ "$#" -le 2 ] || arguments_error "Expected at most 2 arguments; got $#"
  eprint "Not yet implemented"
  [ "$#" -ge 1 ] && eprint ": $1"
  eprintln
  if [ "$#" -ge 2 ]; then
    ret "$2"
  else
    exit 1
  fi
}

# @description Marks unimplemented code.
unimplemented() {
  eprint "Not yet implemented"
  [ "$#" -eq 1 ] && eprint ": $1"
  eprintln
  exit 1
}

# @description Marks unreachable code.
unreachable() {
  eprint "Reached unreachable code"
  [ "$#" -eq 1 ] && eprint ": $1"
  eprintln
  exit 1
}

# @description Signals a breakpoint.
# During runtime one can press `c`, `d` or `q` to continue the program, dump variables or quit the program
# respectively.
breakpoint() {
  println "Reached breakpoint"
  while true; do
    println "[c]ontinue / [d]ump variables / [q]uit"
    var _action = "$(call readch)"
    case "$_action" in
      "c")
        break
        ;;
      "d")
        set
        ;;
      "q")
        exit 0
        ;;
      *)
        eprintln "Unknown action \`$_action\`"
        ;;
    esac
  done
}

# }}}

# @section tests
# @description Functions intended for tests.

# {{{

# @description Reports whether two values are equal.
expect_eq() {
  [ "$#" -eq 2 ] || arguments_error "Expected 2 arguments; got $#"
  _lhs=$1; shift
  _rhs=$1; shift

  if [ "$_lhs" = "$_rhs" ]; then
    eprintln "$(call make_green "[SUCCESS] expect_eq \`$_lhs\` \`$_rhs\`")"
  else
    eprintln "$(call make_red "[FAILURE] expect_eq \`$_lhs\` \`$_rhs\`")"
  fi
  return 0
}

# @description Reports whether two values are not equal.
expect_ne() {
  [ "$#" -eq 2 ] || arguments_error "Expected 2 arguments; got $#"
  _lhs=$1; shift
  _rhs=$1; shift

  if [ "$_lhs" != "$_rhs" ]; then
    eprintln "$(call make_green "[SUCCESS] expect_ne \`$_lhs\` \`$_rhs\`")"
  else
    eprintln "$(call make_red "[FAILURE] expect_ne \`$_lhs\` \`$_rhs\`")"
  fi
  return 0
}

# }}}

# @section log
# @description Logging utilities.

# {{{

# TODO: flexible logging format where user can use a f-string like environment variable, or even better a function?

PRECIOUSH_LOG_LEVEL="${PRECIOUSH_LOG_LEVEL:=info}"

_log() {
  [ "$#" -eq 3 ] || arguments_error "Expected 2 arguments; got $#"
  _prefix=$1; shift
  _color=$1; shift
  _message=$1; shift

  print "$_prefix $_color$_message"
  println "$ansi_reset"
}

log_level_to_int() {
  [ "$#" -eq 1 ] || arguments_error "Expected 1 argument; got $#"
  _level=$1; shift

  case "$_level" in
    "trace")
      ret 10
      ;;
    "debug")
      ret 20
      ;;
    "info")
      ret 30
      ;;
    "warn")
      ret 40
      ;;
    "error")
      ret 50
      ;;
    "critical")
      ret 60
      ;;
    *)
      value_error "Unknown log level \`$_level\`"
      ;;
  esac
}

log_trace() {
  [ "$#" -eq 1 ] || arguments_error "Expected 1 argument; got $#"
  _message=$1; shift

  if [ "$(call log_level_to_int "$PRECIOUSH_LOG_LEVEL")" -le "$(call log_level_to_int "trace")" ]; then
    _log "$(printf "\xf0\x9f\x91\xa3")" "$ansi_purple" "$_message"
  fi
}

log_debug() {
  [ "$#" -eq 1 ] || arguments_error "Expected 1 argument; got $#"
  _message=$1; shift

  if [ "$(call log_level_to_int "$PRECIOUSH_LOG_LEVEL")" -le "$(call log_level_to_int "debug")" ]; then
    _log "$(printf "\xf0\x9f\x90\x9b")" "$ansi_cyan" "$_message"
  fi
}

log_info() {
  [ "$#" -eq 1 ] || arguments_error "Expected 1 argument; got $#"
  _message=$1; shift

  if [ "$(call log_level_to_int "$PRECIOUSH_LOG_LEVEL")" -le "$(call log_level_to_int "info")" ]; then
    _log "$(printf "\xe2\x84\xb9\xef\xb8\x8f")" "$ansi_blue" "$_message"
  fi
}

log_warn() {
  [ "$#" -eq 1 ] || arguments_error "Expected 1 argument; got $#"
  _message=$1; shift

  if [ "$(call log_level_to_int "$PRECIOUSH_LOG_LEVEL")" -le "$(call log_level_to_int "warn")" ]; then
    _log "$(printf "\xe2\x9a\xa0\xef\xb8\x8f")" "$ansi_yellow" "$_message"
  fi
}

log_error() {
  [ "$#" -eq 1 ] || arguments_error "Expected 1 argument; got $#"
  _message=$1; shift

  if [ "$(call log_level_to_int "$PRECIOUSH_LOG_LEVEL")" -le "$(call log_level_to_int "error")" ]; then
    _log "$(printf "\xe2\x9d\x8c")" "$ansi_red" "$_message"
  fi
}

log_critical() {
  [ "$#" -eq 1 ] || arguments_error "Expected 1 argument; got $#"
  _message=$1; shift

  if [ "$(call log_level_to_int "$PRECIOUSH_LOG_LEVEL")" -le "$(call log_level_to_int "critical")" ]; then
    _log "$(printf "\xf0\x9f\x92\xa5")" "$ansi_red" "$_message"
  fi
}

# }}}

# @section fs
# @description File system related utilities.

# {{{

writeln() {
  _file="$1"; shift
  _text="$1"; shift

  printf "%s\n" "$_text" >> "$_file"
}

# }}}

# @section iterators
# @description Utilities for working with iterators.

# {{{

range() {
  [ "$#" -eq 2 ] || arguments_error "Expected 2 arguments; got $#"
  _lower_bound=$1; shift
  _upper_bound=$2; shift

  # TODO: if _lower_bound <= _upper_bound, count backwards

  _i="$_lower_bound"
  _output=""

  while [ "$_i" -le "$_upper_bound" ]; do
    _output="$_output $_i"
    _i=$((_i + 1))
  done

  printf "%s" "$_output" > "$__result__"
}

# }}}

# @section error
# @description Functions for throwing errors.

# {{{

# @description Raises a syntax error.
syntax_error() {
  [ "$#" -eq 1 ] || arguments_error "Expected 1 argument; got $#"
  _message=$1; shift

  eprintln "Syntax Error: $_message"
  exit 1
}

arguments_error() {
  [ "$#" -eq 1 ] || arguments_error "Expected 1 argument; got $#"
  _message=$1; shift

  eprintln "Arguments Error: $_message"
  exit 1
}

value_error() {
  [ "$#" -eq 1 ] || arguments_error "Expected 1 argument; got $#"
  _message=$1; shift

  eprintln "Value Error: $_message"
  exit 1
}

# }}}

# @section rand
# @description Functions related to randomness.

# {{{

# @description Evaluates a random byte.
random_byte() {
  # TODO: pipe to od -An -tu1 like below?
  dd if=/dev/urandom bs=1 count=1 2>/dev/null > "$__result__"
}

# @description Evaluates a random byte that is not NULL.
random_byte_non_null() {
  while true; do
    _byte=$(dd if=/dev/urandom bs=1 count=1 2>/dev/null | od -An -tu1)
    [ "$_byte" -ne 0 ] && break
  done
  printf "%s" _byte > "$__result__"
}

# @description Evaluates random noise data.
random_garbage() {
  random_uint8
  _quantity="$(cat "$__result__")"
  _i=0
  while [ "$_i" -le "$_quantity" ]; do
    random_byte_non_null
    _random_byte="$(cat "$__result__")"
    printf "%s" "$_random_byte" >> "$__result__"
    _i=$((_i + 1))
  done
}

# @description Evaluates a random integer.
# @arg $1 integer The lower bound.
# @arg $2 integer The upper bound.
random_int() {
  _lower_bound="$1"; shift
  _upper_bound="$1"; shift

  awk -v min="$_lower_bound" -v max="$_upper_bound" 'BEGIN {srand(); print int(min + rand() * (max - min + 1))}' > "$__result__"
}

# @description Evaluates a random ASCII character.
random_ascii() {
  todo "random_ascii"
}

random_uint8() {
  random_int 0 256
}

random_sint8() {
  random_int -128 127
}

# }}}

# @section math
# @description Math related functions and constants.

# {{{

const pi = "3.14159265358979323846264338327950288"

# @description Performs addition on integers.
int_add() {
  [ "$#" -eq 2 ] || arguments_error "Expected 2 arguments; got $#"
  _a="$1"; shift
  _b="$1"; shift

  # TODO: check if args are integers

  printf "%s" $((_a+_b)) > "$__result__"
}

int_sub() {
  [ "$#" -eq 2 ] || arguments_error "Expected 2 arguments; got $#"
  _a="$1"; shift
  _b="$1"; shift

  # TODO: check if args are integers

  printf "%s" $((_a-_b)) > "$__result__"
}

int_mul() {
  [ "$#" -eq 2 ] || arguments_error "Expected 2 arguments; got $#"
  _a="$1"; shift
  _b="$1"; shift

  # TODO: check if args are integers

  printf "%s" $((_a*_b)) > "$__result__"
}

int_div() {
  [ "$#" -eq 2 ] || arguments_error "Expected 2 arguments; got $#"
  _a="$1"; shift
  _b="$1"; shift

  # TODO: check if args are integers

  printf "%s" $((_a/_b)) > "$__result__"
}


# @description Performs addition on numbers.
num_add() {
  todo "num_add"
}

# @description Performs subtraction on numbers.
num_sub() {
  todo "num_sub"
}

# @description Performs multiplication on numbers.
num_mul() {
  todo "num_mul"
}

# }}}

# @section binary
# @description Utitlities for working with binary data.

# {{{

bit_and() {
  printf "0" > "$__result__"
  while [ "$#" -gt 0 ]; do
    case "$1" in
      "0")
        printf "0" > "$__result__"
        break
        ;;
      "1")
        printf "1" > "$__result__"
        shift
        ;;
      *)
        value_error "Expected \`0\` or \`1\`; got \`$1\`"
        ;;
    esac
  done
}

bit_or() {
  printf "0" > "$__result__"
  while [ "$#" -gt 0 ]; do
    case "$1" in
      "0")
        printf "0" > "$__result__"
        shift
        ;;
      "1")
        printf "1" > "$__result__"
        break
        ;;
      *)
        value_error "Expected \`0\` or \`1\`; got \`$1\`"
        ;;
    esac
  done
}

bit_xor() {
  print "$(call bit_and "$(call bit_or "$@")" "$(call bit_not "$(call bit_and "$@")")")" > "$__result__"
}


bit_not() {
  [ "$#" -eq 1 ] || arguments_error "Expected 1 argument; got $#"
  case "$1" in
    "0")
      printf "1" > "$__result__"
      ;;
    "1")
      printf "0" > "$__result__"
      ;;
    *)
      value_error "Expected \`0\` or \`1\`; got \`$1\`"
      ;;
  esac
}

# }}}

# @section ansi
# @description ANSI escape sequences helpers.

# {{{

const ansi_reset = "$(printf "\e[0m")"

const ansi_green = "$(printf "\e[32m")"

# @description Applies green color on text.
make_green() {
  [ "$#" -eq 1 ] || arguments_error "Expected 1 argument; got $#"
  printf "%s%s%s" "$ansi_green" "$1" "$ansi_reset" > "$__result__"
}

const ansi_red = "$(printf "\e[31m")"

make_red() {
  [ "$#" -eq 1 ] || arguments_error "Expected 1 argument; got $#"
  printf "%s%s%s" "$ansi_red" "$1" "$ansi_reset" "$1" > "$__result__"
}

const ansi_blue = "$(printf "\e[34m")"

make_blue() {
  [ "$#" -eq 1 ] || arguments_error "Expected 1 argument; got $#"
  printf "%s%s%s" "$ansi_red" "$1" "$ansi_reset" "$1" > "$__result__"
}

const ansi_black = "$(printf "\e[30m")"

make_black() {
  [ "$#" -eq 1 ] || arguments_error "Expected 1 argument; got $#"
  printf "%s%s%s" "$ansi_black" "$1" "$ansi_reset" "$1" > "$__result__"
}

const ansi_yellow = "$(printf "\e[33m")"

make_yellow() {
  [ "$#" -eq 1 ] || arguments_error "Expected 1 argument; got $#"
  printf "%s%s%s" "$ansi_yellow" "$1" "$ansi_reset" "$1" > "$__result__"
}

const ansi_purple = "$(printf "\e[35m")"

make_purple() {
  [ "$#" -eq 1 ] || arguments_error "Expected 1 argument; got $#"
  printf "%s%s%s" "$ansi_purple" "$1" "$ansi_reset" "$1" > "$__result__"
}

const ansi_cyan = "$(printf "\e[36m")"

make_cyan() {
  [ "$#" -eq 1 ] || arguments_error "Expected 1 argument; got $#"
  printf "%s%s%s" "$ansi_cyan" "$1" "$ansi_reset" "$1" > "$__result__"
}

const ansi_white = "$(printf "\e[37m")"

make_white() {
  [ "$#" -eq 1 ] || arguments_error "Expected 1 argument; got $#"
  printf "%s%s%s" "$ansi_white" "$1" "$ansi_reset" "$1" > "$__result__"
}

# }}}

# @section ui
# @description UI Utitlities.

# {{{



# }}}

