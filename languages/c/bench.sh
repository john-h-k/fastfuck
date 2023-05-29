#!/bin/sh

case "$1" in
	prepare)
		clang -Ofast -DNODEBUG brainfuck.c -o brainfuck
		;;
	run)
		./brainfuck $2
		;;
	*)
		echo "bad command $1"
		exit 1
		;;
esac
