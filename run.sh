#!/bin/sh

cwd=$(pwd)

for lang in languages/**
do
	cd "$lang"
	echo "Building $lang..."
	./bench.sh prepare
	echo "Executing $lang..."
	start=$(date +%s)
	./bench.sh run "$cwd/bench/mandelbrot.b"
	end=$(date +%s)
	cd "$cwd"

	elapsed=$((end - start))
	echo "`$lang` took ${elapsed}s"
done