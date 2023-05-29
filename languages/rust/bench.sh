#!/bin/sh

case "$1" in
	prepare)
		cargo build --release --manifest-path rustfuck/Cargo.toml
		;;
	run)
		./rustfuck/target/release/rustfuck $2
		;;
	*)
		echo "bad command $1"
		exit 1
		;;
esac
