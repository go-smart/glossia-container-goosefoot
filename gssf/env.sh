#!/bin/sh

cd /shared

# how to handle?: --status-socket ./update.sock
INTERPRETER="go-smart-launcher"

if [ -n "${GSSA_STATUS_SOCKET+1}" ]
then
	echo "FOUND STATUS SOCKET ENV: ${GSSA_STATUS_SOCKET}"
	INTERPRETER="${INTERPRETER} --status-socket ${GSSA_STATUS_SOCKET}"
else
	echo "NO STATUS SOCKET ENV"
fi

mkdir -p output/run
ln -s `pwd`/input output/run/input
cd output/run
exec "gosling" "--interpreter" "${INTERPRETER}" "--target" "settings.xml" "$@"
