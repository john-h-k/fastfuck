#!/bin/sh

case "$1" in
	prepare)
		dotnet build -c release
		;;
	run)
		dotnet run -c release --no-build -- $2
		;;
	*)
		echo "bad command $1"
		exit 1
		;;
esac
