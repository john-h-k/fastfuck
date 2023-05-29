#!/bin/sh

cwd=$(pwd)

if [ "$#" -eq 0 ]; then
	dirs=$(basename $(echo languages/*))
else
	dirs="$@"
fi

echo "" > RESULTS.txt

for lang in $dirs
do
	if ! [ -d "languages/$lang" ]; then
		echo "lang '$lang' doesn't exist!"
		exit 1
	fi
	
	cd "languages/$lang"
	echo "Building $lang..."
	./bench.sh prepare
	echo "Executing $lang..."
	start=$(date +%s)
	./bench.sh run "$cwd/bench/mandelbrot.b"
	end=$(date +%s)
	cd "$cwd"

	elapsed=$((end - start))
	echo "\`$lang\` took ${elapsed}s"

	echo "$lang -- $elapsed" >> RESULTS.txt
done