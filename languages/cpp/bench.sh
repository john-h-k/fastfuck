#!/bin/sh

case "$1" in
	prepare)
		clang++ -std=c++20 -Ofast -DNODEBUG brainfuck.cpp -o brainfuck
		;;
	run)
		./brainfuck $2
		;;
	*)
		echo "bad command $1"
		exit 1
		;;
esac
