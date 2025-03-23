#!/usr/bin/env sh

. /usr/local/bin/preciou.sh

println "-> bit_or"
expect_eq "$(call bit_or 0 0)" 0
expect_eq "$(call bit_or 0 1)" 1
expect_eq "$(call bit_or 0 1)" 1
expect_eq "$(call bit_or 1 1)" 1
expect_eq "$(call bit_or 0 0 0)" 0
expect_eq "$(call bit_or 0 0 1)" 1
expect_eq "$(call bit_or 0 1 0)" 1
expect_eq "$(call bit_or 0 1 1)" 1
expect_eq "$(call bit_or 1 0 0)" 1
expect_eq "$(call bit_or 1 0 1)" 1
expect_eq "$(call bit_or 1 1 0)" 1
expect_eq "$(call bit_or 1 1 1)" 1
println

println "-> bit_and"
expect_eq "$(call bit_and 0 0)" 0
expect_eq "$(call bit_and 0 1)" 0
expect_eq "$(call bit_and 1 0)" 0
expect_eq "$(call bit_and 1 1)" 1
expect_eq "$(call bit_and 0 0 0)" 0
expect_eq "$(call bit_and 0 0 1)" 0
expect_eq "$(call bit_and 0 1 0)" 0
expect_eq "$(call bit_and 0 1 1)" 0
expect_eq "$(call bit_and 1 0 0)" 0
expect_eq "$(call bit_and 1 0 1)" 0
expect_eq "$(call bit_and 1 1 0)" 0
expect_eq "$(call bit_and 1 1 1)" 1
println

println "-> bit xor"
expect_eq "$(call bit_xor 0 0)" 0
expect_eq "$(call bit_xor 0 1)" 1
expect_eq "$(call bit_xor 1 0)" 1
expect_eq "$(call bit_xor 1 1)" 0
expect_eq "$(call bit_xor 0 0 0)" 0
expect_eq "$(call bit_xor 0 0 1)" 1
expect_eq "$(call bit_xor 0 1 0)" 1
expect_eq "$(call bit_xor 0 1 1)" 1
expect_eq "$(call bit_xor 1 0 0)" 1
expect_eq "$(call bit_xor 1 0 1)" 1
expect_eq "$(call bit_xor 1 1 0)" 1
expect_eq "$(call bit_xor 1 1 1)" 0
println
