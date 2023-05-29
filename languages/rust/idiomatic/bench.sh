#!/bin/sh

case "$1" in
	prepare)
		cargo rustc --release -- -C target-cpu=native
		;;
	run)
		./target/release/brainfuck $2
		;;
	*)
		echo "bad command $1"
		exit 1
		;;
esac
