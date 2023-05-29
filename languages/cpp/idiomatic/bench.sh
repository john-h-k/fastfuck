#!/bin/sh

case "$1" in
	prepare)
		mkdir -p target
		clang++ -std=c++20 -Ofast -DNODEBUG brainfuck.cpp -o target/brainfuck
		;;
	run)
		./target/brainfuck $2
		;;
	*)
		echo "bad command $1"
		exit 1
		;;
esac
