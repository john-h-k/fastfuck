class State {
  constructor() {
    this.cells = [];
    this.pos = 0;
  }

  read_cur_cell() {
    if (this.pos >= this.cells.length) {
      return 0;
    } else {
      return this.cells[this.pos];
    }
  }

  write_cur_cell(value) {
    if (this.pos >= this.cells.length) {
      for (let i = this.cells.length; i <= this.pos; i++) {
        this.cells.push(0);
      }
    }

    this.cells[this.pos] = value;
  }

  inc_cur_cell() {
    this.write_cur_cell(this.read_cur_cell() + 1);
  }

  dec_cur_cell() {
    this.write_cur_cell(this.read_cur_cell() - 1);
  }
}

function error(msg) {
  console.error(msg);
  process.exit(1);
}

const fs = require('fs');

let program = fs.readFileSync(process.argv[2], 'utf-8');

let state = new State();

let instr_pointer = 0;

while (instr_pointer < program.length) {
  let command = program[instr_pointer];

  switch (command) {
    case '+':
      state.inc_cur_cell();
      break;
    case '-':
      state.dec_cur_cell();
      break;
    case '>':
      state.pos++;
      break;
    case '<':
      if (state.pos === 0) {
        error(`Attempted to decrement data pointer below 0 at position ${instr_pointer}`);
      }
      state.pos--;
      break;
    case '.':
      process.stdout.write(String.fromCharCode(state.read_cur_cell()));
      break;
    case ',':
      readline.emitKeypressEvents(process.stdin);
      process.stdin.setRawMode(true);
      process.stdin.on('keypress', (str, key) => {
        state.write_cur_cell(str.charCodeAt(0));
      });
      break;
    case '[':
      if (state.read_cur_cell() === 0) {
        let depth = 1;

        while (depth > 0) {
          instr_pointer++;

          if (instr_pointer >= program.length) {
            error(`Unmatched '[' at position ${instr_pointer}`);
          }

          if (program[instr_pointer] === '[') {
            depth++;
          } else if (program[instr_pointer] === ']') {
            depth--;
          }
        }
      }
      break;
    case ']':
      if (state.read_cur_cell() !== 0) {
        let depth = 1;

        while (depth > 0) {
          instr_pointer--;

          if (instr_pointer < 0) {
            error(`Unmatched ']' at position ${instr_pointer}`);
          }

          if (program[instr_pointer] === ']') {
            depth++;
          } else if (program[instr_pointer] === '[') {
            depth--;
          }
        }
      }
      break;
  }

  instr_pointer++;
}
