#!/bin/bash
set -e

if [ "$1" = 'redis-server' ]; then
	chown -R cloudcss .
	exec gosu cloudcss "$@"
fi

exec "$@"