#!/usr/bin/env sh

. /usr/local/bin/preciou.sh

var minimum = 0
var maximum = 100
var secret = "$(call random_int "$minimum" "$maximum")"

while true; do
  println "Guess the number between $minimum and $maximum"
  var answer = "$(call readln)"
  [ "$answer" -gt "$secret" ] && [ "$answer" -lt "$maximum" ] && var maximum = "$answer"
  [ "$answer" -lt "$secret" ] && [ "$answer" -gt "$minimum" ] && var minimum = "$answer"
  [ "$answer" -eq "$secret" ] && break
done

println "Correct! The secret number is $secret!"

