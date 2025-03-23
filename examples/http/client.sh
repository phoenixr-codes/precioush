#!/usr/bin/env sh

. /usr/local/bin/preciou.sh

var url = "https://zenquotes.io/api/random/"
var response = $(call fetch "$url")
println "$response"

