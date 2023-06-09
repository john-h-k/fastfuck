
#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <stack>

class State {
public:
    std::vector<int> cells = std::vector<int>(1, 0);
    size_t pos = 0;

    int readCurCell() {
        if (pos >= cells.size()) {
            return 0;
        } else {
            return cells[pos];
        }
    }

    void writeCurCell(int value) {
        if (pos >= cells.size()) {
            cells.resize(pos + 1, 0);
        }
        cells[pos] = value;
    }

    void incCurCell() { 
        writeCurCell(readCurCell() + 1); 
    }

    void decCurCell() { 
        writeCurCell(readCurCell() - 1); 
    }
};

int main(int argc, char* argv[]) {
    if (argc < 2) {
        std::cerr << "Usage: " << argv[0] << " <filename>" << std::endl;
        return 1;
    }

    std::ifstream program_file(argv[1]);
    std::string program((std::istreambuf_iterator<char>(program_file)),
                         std::istreambuf_iterator<char>());
    
    State state;
    size_t instr_pointer = 0;

    while (instr_pointer < program.size()) {
        char command = program[instr_pointer];

        switch (command) {
            case '+':
                state.incCurCell();
                break;
            case '-':
                state.decCurCell();
                break;
            case '>':
                state.pos++;
                break;
            case '<':
                if (state.pos == 0) {
                    std::cerr << "Error: Attempted to decrement data pointer below 0 at position " << instr_pointer << std::endl;
                    return 1;
                }
                state.pos--;
                break;
            case '.':
                std::cout << static_cast<char>(state.readCurCell());
                break;
            case ',':
                char c;
                std::cin >> c;
                state.writeCurCell(c);
                break;
            case '[':
                if (state.readCurCell() == 0) {
                    int depth = 1;
                    while (depth > 0 && instr_pointer < program.length()) {
                        instr_pointer++;
                        if (program[instr_pointer] == '[') {
                            depth++;
                        } else if (program[instr_pointer] == ']') {
                            depth--;
                        }
                    }
                }
                break;
            case ']':
                if (state.readCurCell() != 0) {
                    int depth = 1;
                    while (depth > 0 && instr_pointer >= 0) {
                        instr_pointer--;
                        if (program[instr_pointer] == ']') {
                            depth++;
                        } else if (program[instr_pointer] == '[') {
                            depth--;
                        }
                    }
                }
                break;
            default:
                break;
        }
        instr_pointer++;
    }
    return 0;
}
