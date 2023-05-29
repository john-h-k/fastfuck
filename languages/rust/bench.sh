#!/bin/sh

case "$1" in
	prepare)
		cargo rustc --release --manifest-path rustfuck/Cargo.toml -- -C target-cpu=native
		;;
	run)
		./rustfuck/target/release/rustfuck $2
		;;
	*)
		echo "bad command $1"
		exit 1
		;;
esac
