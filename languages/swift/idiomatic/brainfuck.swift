
import Foundation

let MAX_CELL_SIZE = 30000

struct State {
    var cells: [UInt8] = Array(repeating: 0, count: MAX_CELL_SIZE)
    var pos: Int = 0
}

func error(_ msg: String) -> Never {
    print(msg)
    exit(1)
}

func readCurCell(_ state: inout State) -> UInt8 {
    return state.cells[state.pos]
}

func writeCurCell(_ state: inout State, value: UInt8) {
    state.cells[state.pos] = value
}

func incCurCell(_ state: inout State) {
    writeCurCell(&state, value: readCurCell(&state) &+ 1)
}

func decCurCell(_ state: inout State) {
    writeCurCell(&state, value: readCurCell(&state) &- 1)
}

func main(args: [String]) {
    let argc = args.count

    if argc != 2 {
        error("You must provide a filename as an argument")
    }

    let fileURL = URL(fileURLWithPath: args[1])

    guard let program_str = try? String(contentsOf: fileURL) else {
        error("Could not open file")
    }

	let program = [UInt8](program_str.utf8);

    var state = State()
    var instr_pointer = 0

    while instr_pointer < program.count {
        let command = program[instr_pointer]

        switch UnicodeScalar(command) {
        case "+":
            incCurCell(&state)
        case "-":
            decCurCell(&state)
        case ">":
            state.pos += 1
        case "<":
            if state.pos == 0 {
                error("Attempted to decrement data pointer below 0")
            }
            state.pos -= 1
        case ".":
            print(UnicodeScalar(readCurCell(&state)), terminator: "")
        case ",":
            writeCurCell(&state, value: UInt8(getchar()))
        case "[":
            if readCurCell(&state) == 0 {
                var depth = 1
                while depth > 0 && instr_pointer < program.count {
                    instr_pointer += 1
                    if UnicodeScalar(program[instr_pointer]) == "[" {
                        depth += 1
                    } else if UnicodeScalar(program[instr_pointer]) == "]" {
                        depth -= 1
                    }
                }
            }
        case "]":
            if readCurCell(&state) != 0 {
                var depth = 1
                while depth > 0 && instr_pointer >= 0 {
                    instr_pointer -= 1
                    if UnicodeScalar(program[instr_pointer]) == "]" {
                        depth += 1
                    } else if UnicodeScalar(program[instr_pointer]) == "[" {
                        depth -= 1
                    }
                }
            }
        default:
            break
        }
        instr_pointer += 1
    }
}

let arguments = CommandLine.arguments
main(args: arguments)
