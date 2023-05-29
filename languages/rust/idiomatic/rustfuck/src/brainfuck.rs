use std::io::{Read, Stderr, Stdin, Stdout, Write};

use anyhow::{bail, Result};

pub struct Interpreter {
    state: BrainfuckState,
    stdin: Stdin,
    stdout: Stdout,
    stderr: Stderr,
}

#[derive(Debug)]
pub struct BrainfuckState {
    pub cells: Vec<u8>,
    pub pos: usize,
}

#[derive(PartialEq, Eq)]
enum CellOp {
    Inc,
    Dec,
}

impl BrainfuckState {
    pub fn read_cell(&self, i: usize) -> u8 {
        // If the cell is OOB, it cannot have been written to, so must be zero
        *self.cells.get(i).unwrap_or(&0u8)
    }

    pub fn read_cur_cell(&self) -> u8 {
        self.read_cell(self.pos)
    }

    fn set_cur_cell(&mut self, val: u8) {
        if self.pos >= self.cells.len() {
            self.cells.resize(self.pos + 1, 0);
        }

        self.cells[self.pos] = val;
    }

    fn modify_cur_cell(&mut self, op: CellOp) {
        if op == CellOp::Inc {
            self.set_cur_cell(self.read_cur_cell() + 1);
        } else {
            self.set_cur_cell(self.read_cur_cell() - 1);
        }
    }
}

impl Interpreter {
    pub fn new(stdin: Stdin, stderr: Stderr, stdout: Stdout) -> Self {
        Self {
            stdin,
            stderr,
            stdout,
            state: BrainfuckState {
                cells: Vec::new(),
                pos: 0,
            },
        }
    }

    pub fn state(&self) -> &BrainfuckState {
        &self.state
    }

    pub fn execute(&mut self, program: &[u8]) -> Result<()> {
        let mut instr_pointer = 0;

        let mut stdout = self.stdout.lock();
        let mut stdin = self.stdin.lock();

        while let Some(command) = program.get(instr_pointer) {
            match *command {
                b'>' => self.state.pos += 1,
                b'<' if self.state.pos == 0 => bail!(
                    "Tried to decrement data pointer below 0 at position {}",
                    instr_pointer
                ),
                b'<' => self.state.pos -= 1,
                b'+' => self.state.modify_cur_cell(CellOp::Inc),
                b'-' => self.state.modify_cur_cell(CellOp::Dec),
                b'.' => {
                    stdout
                        .write_all(&[self.state.read_cur_cell()])
                        .expect("writing to `stdout` failed");
                }
                b',' => {
                    let mut buff = [0; 1];
                    stdin
                        .read_exact(&mut buff)
                        .expect("reading from `stdin` failed");

                    self.state.set_cur_cell(buff[0]);
                }

                b'[' if self.state.read_cur_cell() == 0 => {
                    let mut depth = 0;
                    let mut pos = instr_pointer;

                    loop {
                        pos += 1;

                        match program.get(pos) {
                            Some(b'[') => depth += 1,
                            Some(b']') if depth > 0 => depth -= 1,
                            Some(b']') => {
                                // Reached the matching bracket
                                // The next instruction we want to execute is the one AFTER this,
                                // but we increment instr_pointer at the end of the loop
                                instr_pointer = pos;
                                break;
                            }
                            None => bail!("Unmatched '[' at position {}", instr_pointer),
                            _ => {}
                        }
                    }
                }

                b']' if self.state.read_cur_cell() != 0 => {
                    let mut depth = 0;
                    let mut pos = instr_pointer;

                    loop {
                        pos -= 1;

                        match program.get(pos) {
                            Some(b']') => depth += 1,
                            Some(b'[') if depth > 0 => depth -= 1,
                            Some(b'[') => {
                                // Reached the matching bracket
                                // The next instruction we want to execute is the one AFTER this,
                                // but we increment instr_pointer at the end of the loop
                                instr_pointer = pos;
                                break;
                            }
                            None => bail!("Unmatched ']' at position {}", instr_pointer),
                            _ => {}
                        }
                    }
                }

                _ => {}
            }

            instr_pointer += 1;
        }

        Ok(())
    }
}
