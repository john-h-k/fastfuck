
package main

// Made by https://github.com/404dcd

import (
	"fmt"
	"io/ioutil"
	"os"
)

var memory []int
var lenmem int = 0
var ptr int = 0
var diff int = 1 // diff := ptr - lenmem + 1

func write(val int) {
	if diff > 0 {
		memory = append(memory, make([]int, diff)...)
		lenmem += diff
		diff = 0
	}
	memory[ptr] = val
}

func read() int {
	if diff > 0 {
		return 0
	}
	return memory[ptr]
}

func main() {
	program, _ := ioutil.ReadFile(os.Args[1])
	lenprog := len(program)

	openStack := make([]int, 0, 512)
	jumps := make([]int, lenprog)
	instrPointer := 0
	var temp int
	for i, v := range program {
		if v == '[' {
			openStack = append(openStack, i)
			instrPointer++
		} else if v == ']' {
			temp = openStack[instrPointer-1]
			openStack = openStack[:instrPointer-1]
			instrPointer--
			jumps[i] = temp
			jumps[temp] = i
		}
	}
	if instrPointer != 0 {
		os.Exit(1)
	}

	memory = make([]int, 0)

	for instrPointer < lenprog {
		command := program[instrPointer]

		switch command {
		case '+':
			write(read() + 1)
		case '-':
			write(read() - 1)
		case '>':
			ptr++
			diff++
		case '<':
			if ptr == 0 {
				os.Exit(1)
			}
			ptr--
			diff--
		case '.':
			fmt.Printf("%c", read())
		case ',':
			var value int
			fmt.Scanf("%c", &value)
			write(value)
		case '[':
			if read() == 0 {
				instrPointer = jumps[instrPointer]
			}
		case ']':
			if read() != 0 {
				instrPointer = jumps[instrPointer]
			}
		}
		instrPointer++
	}
}
