#!/bin/sh

if [ "Darwin arm64" = "$(uname -om)" ]; then
	echo "Apple Silicon detected - using openjdk (you may need to \`brew install jdk\`)"
	JAVA="$(brew --prefix openjdk)/bin/java"
	JAVAC="$(brew --prefix openjdk)/bin/javac"
else
	JAVA="java"
	JAVAC="javac"
fi

case "$1" in
	prepare)
		$JAVAC -d target Brainfuck.java
		;;
	run)
		$JAVA -cp target Brainfuck $2
		;;
	*)
		echo "bad command $1"
		exit 1
		;;
esac
