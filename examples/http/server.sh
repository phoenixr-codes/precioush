#!/usr/bin/env sh

. /usr/local/bin/preciou.sh

route_home() {
  writeln "$__result__" "<!DOCTYPE html>"
  writeln "$__result__" "<html lang=\"en\">"
  writeln "$__result__" "<body>"
  writeln "$__result__" "  <p>Hello World</p>"
  writeln "$__result__" "</body>"
  writeln "$__result__" "</html>"
}

http_route "$(call route_home)" "/"
http_route "$(call route_home)" "/" "index.html"

http_launch "localhost" 5000

