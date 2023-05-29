import sys

class State:
    def __init__(self):
        self.cells = []
        self.pos = 0

    def read_cur_cell(self):
        if self.pos >= len(self.cells):
            return 0
        else:
            return self.cells[self.pos]

    def write_cur_cell(self, value):
        if self.pos >= len(self.cells):
            self.cells += [0] * (self.pos + 1 - len(self.cells))

        self.cells[self.pos] = value

    def inc_cur_cell(self):
        self.write_cur_cell(self.read_cur_cell() + 1)

    def dec_cur_cell(self):
        self.write_cur_cell(self.read_cur_cell() - 1)


def error(msg):
    sys.stderr.write(msg + "\n")
    sys.exit(1)


with open(sys.argv[1], 'r') as file:
    program = file.read()

state = State()

instr_pointer = 0

while instr_pointer < len(program):
    command = program[instr_pointer]

    if command == '+':
        state.inc_cur_cell()
    elif command == '-':
        state.dec_cur_cell()
    elif command == '>':
        state.pos += 1
    elif command == '<':
        if state.pos == 0:
            error(f"Attempted to decrement data pointer below 0 at position {instr_pointer}")
        state.pos -= 1
    elif command == '.':
        print(chr(state.read_cur_cell()), end='')
    elif command == ',':
        state.write_cur_cell(ord(sys.stdin.read(1)))
    elif command == '[':
        if state.read_cur_cell() == 0:
            depth = 1
            while depth > 0:
                instr_pointer += 1
                if instr_pointer >= len(program):
                    error(f"Unmatched '[' at position {instr_pointer}")
                if program[instr_pointer] == '[':
                    depth += 1
                elif program[instr_pointer] == ']':
                    depth -= 1
    elif command == ']':
        if state.read_cur_cell() != 0:
            depth = 1
            while depth > 0:
                instr_pointer -= 1
                if instr_pointer < 0:
                    error(f"Unmatched ']' at position {instr_pointer}")
                if program[instr_pointer] == ']':
                    depth += 1
                elif program[instr_pointer] == '[':
                    depth -= 1
    instr_pointer += 1
