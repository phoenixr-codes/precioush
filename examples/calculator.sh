#!/usr/bin/env sh

. /usr/local/bin/preciou.sh

main() {
  var n1 = "$(call readln)"
  case "$n1" in
    "quit")
      exit 0
      ;;
  esac

  var op = "$(call readln)"
  case "$op" in
    "quit")
      exit 0
      ;;
  esac

  var n2 = "$(call readln)"
  case "$n2" in
    "quit")
      exit 0
      ;;
  esac

  case "$op" in
    "+")
      println "$(call num_sum "$n1" "$n2")"
      ;;
  esac
}

main "$@"
