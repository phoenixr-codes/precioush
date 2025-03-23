#!/usr/bin/env sh

. /usr/local/bin/preciou.sh

PRECIOUSH_LOG_LEVEL="trace" # enable all log messages

log_trace "This is a trace message"
log_debug "This is a debug message"
log_info "This is an info message"
log_warn "This is a warning message"
log_error "This is an error message"
log_critical "This is a critical message"
