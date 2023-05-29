<h1 align="center">rustfuck</h1>
<div align="center">
 <strong>
  A simple brainfuck interpreter and REPL written in Rust
 </strong>
</div>

## Why?

I wanted to write a brainfuck interpreter. They are inherently quite useless

## What does it have?

`rustfuck` can execute both brainfuck files (using `rustfuck <file>`) as well as containing a simple REPL for brainfuck
that can be used to toy around with brainfuck more easily. To use the REPL, simply run `rustfuck`. It is extremely simple to use:

* `q` (or `Ctrl-c`) to quit
* Any arbitrary text will be ignored (as it would be in brainfuck)
* Hitting enter with no input/non brainfuck input will simply show the current interpreter state
* Entering brainfuck commands will, well, execute them

There is an example `hello_world.bf` in the [examples](./examples). It is taken from the informative Wikipedia page for [brainfuck](https://en.wikipedia.org/wiki/Brainfuck).
