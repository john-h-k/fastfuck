#!/bin/sh

case "$1" in
	prepare)
		;;
	run)
		node brainfuck.js $2
		;;
	*)
		echo "bad command $1"
		exit 1
		;;
esac
