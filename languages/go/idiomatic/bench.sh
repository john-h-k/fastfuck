#!/bin/sh

case "$1" in
	prepare)
		go build -o target/brainfuck brainfuck.go
		;;
	run)
		./target/brainfuck $2
		;;
	*)
		echo "bad command $1"
		exit 1
		;;
esac
