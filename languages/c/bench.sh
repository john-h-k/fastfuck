#!/bin/sh

case "$1" in
	prepare)
		mkdir -p target
		clang -Ofast -DNODEBUG brainfuck.c -o target/brainfuck
		;;
	run)
		./target/brainfuck $2
		;;
	*)
		echo "bad command $1"
		exit 1
		;;
esac
