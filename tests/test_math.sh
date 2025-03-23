#!/usr/bin/env sh

. /usr/local/bin/preciou.sh

println "-> int_add"
expect_eq "$(call int_add 40 2)" 42
expect_eq "$(call int_add 2 -44)" -42
println

println "-> int_sub"
expect_eq "$(call int_sub 50 20)" 30
expect_eq "$(call int_sub 20 50)" -30
println

println "-> int_mul"
expect_eq "$(call int_mul 5 4)" 20
expect_eq "$(call int_mul -2 -4)" 8
expect_eq "$(call int_mul -10 2)" -20
println

println "-> int_div"
expect_eq "$(call int_div 10 5)" 2
expect_eq "$(call int_div 2 3)" 0
expect_eq "$(call int_div -5 5)" -1
println
