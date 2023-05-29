package main

import (
	"fmt"
	"io/ioutil"
	"os"
)

const MaxCellSize = 30000

type State struct {
	cells [MaxCellSize]int
	pos   int
}

func main() {
	if len(os.Args) != 2 {
		errorExit("You must provide a filename as an argument")
	}

	program, err := ioutil.ReadFile(os.Args[1])
	if err != nil {
		errorExit("Could not open file")
	}

	state := &State{}
	instrPointer := 0

	for instrPointer < len(program) {
		command := program[instrPointer]

		switch command {
		case '+':
			state.writeCurCell(state.readCurCell() + 1)
		case '-':
			state.writeCurCell(state.readCurCell() - 1)
		case '>':
			state.pos++
		case '<':
			if state.pos == 0 {
				errorExit("Attempted to decrement data pointer below 0")
			}
			state.pos--
		case '.':
			fmt.Printf("%c", state.readCurCell())
		case ',':
			var value int
			fmt.Scanf("%c", &value)
			state.writeCurCell(value)
		case '[':
			if state.readCurCell() == 0 {
				depth := 1
				for depth > 0 && instrPointer < len(program) {
					instrPointer++
					if program[instrPointer] == '[' {
						depth++
					} else if program[instrPointer] == ']' {
						depth--
					}
				}
			}
		case ']':
			if state.readCurCell() != 0 {
				depth := 1
				for depth > 0 && instrPointer >= 0 {
					instrPointer--
					if program[instrPointer] == ']' {
						depth++
					} else if program[instrPointer] == '[' {
						depth--
					}
				}
			}
		}
		instrPointer++
	}
}

func (state *State) readCurCell() int {
	if state.pos >= len(state.cells) {
		return 0
	} else {
		return state.cells[state.pos]
	}
}

func (state *State) writeCurCell(value int) {
	state.cells[state.pos] = value
}

func errorExit(msg string) {
	fmt.Fprintln(os.Stderr, msg)
	os.Exit(1)
}
