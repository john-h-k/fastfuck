#!/bin/sh

case "$1" in
	prepare)
		mkdir -p target
		swiftc -O -target-cpu native -o target/brainfuck brainfuck.swift
		;;
	run)
		./target/brainfuck $2
		;;
	*)
		echo "bad command $1"
		exit 1
		;;
esac
