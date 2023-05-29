use std::{
    fs,
    io::{self, Write},
    path::PathBuf,
};

use anyhow::Result;
use clap::Parser;

mod brainfuck;

use brainfuck::Interpreter;

#[derive(Parser)]
#[command(name = "rustfuck")]
#[command(author = "John Harry Kelly <johnharrykelly@gmail.com>")]
#[command(version = "1.0")]
#[command(
    help_template = "{name}: {about-section}Version: {version}\nWritten by {author-with-newline}\n{usage-heading} {usage}\n{all-args} {tab}"
)]
#[command(about, long_about = None)]
struct Args {
    /// The file to execute
    /// If not provided, will enter REPL mode
    file: Option<PathBuf>,
}

fn main() -> Result<()> {
    human_panic::setup_panic!();

    let args = Args::parse();

    let mut interpreter = Interpreter::new(io::stdin(), io::stderr(), io::stdout());

    if let Some(file) = args.file {
        let content = fs::read_to_string(file)?;
        interpreter.execute(content.as_bytes())
    } else {
        repl(interpreter)
    }
}

// # of cells shown either side of current one
const CELLS_SHOWN: usize = 5;

fn repl(mut interpreter: Interpreter) -> Result<()> {
    let mut line = String::new();

    loop {
        print!("> ");
        io::stdout().flush()?;

        let mut additional = String::new();
        io::stdin().read_line(&mut additional)?;

        if additional.trim() == "q" {
            println!("Terminating...");
            break;
        }

        line.push_str(&additional);

        // Need to do a check for unmatched braces so we don't execute a malformed line
        let line_bytes = line.as_bytes();
        if line_bytes.iter().filter(|&&b| b == b'[').count()
            != line_bytes.iter().filter(|&&b| b == b']').count()
        {
            println!("(unterminated `[` or `]` - enter next line)");
            continue;
        }

        if let Err(err) = interpreter.execute(line_bytes) {
            eprintln!("Error: {}", err);
            eprintln!("Line was discarded");
        }

        line.clear();

        let state = interpreter.state();

        let mut cell_row = String::new();

        if state.pos > CELLS_SHOWN {
            cell_row.push_str("...");
        }

        let start_pos = state.pos.saturating_sub(CELLS_SHOWN);

        for cell_index in start_pos..state.pos + CELLS_SHOWN + 1 {
            cell_row.push_str(&format!("|{:03}", state.read_cell(cell_index)));
        }

        println!("\n{}|...", cell_row);

        // Each cell is 3 char with a 1-byte prefix
        let mut cur_cell_pos = (state.pos - start_pos) * 4;

        if state.pos > CELLS_SHOWN {
            cur_cell_pos += 3;
        }

        println!("{:1$}^^^", "", cur_cell_pos + 1);
    }

    Ok(())
}
