
import java.nio.file.*;
import java.io.*;
import java.util.*;

public class Brainfuck {
    static class State {
        ArrayList<Integer> cells = new ArrayList<>();
        int pos = 0;

        int readCurCell() {
            if (this.pos >= this.cells.size()) {
                return 0;
            } else {
                return this.cells.get(this.pos);
            }
        }

        void writeCurCell(int value) {
            while (this.pos >= this.cells.size()) {
                this.cells.add(0);
            }

            this.cells.set(this.pos, value);
        }

        void incCurCell() {
            this.writeCurCell(this.readCurCell() + 1);
        }

        void decCurCell() {
            this.writeCurCell(this.readCurCell() - 1);
        }
    }

    public static void main(String[] args) throws IOException {
        if (args.length != 1) {
            System.err.println("You must provide a filename as an argument");
            System.exit(1);
        }

        String program = Files.readString(Path.of(args[0]));

        State state = new State();

        int instrPointer = 0;

        while (instrPointer < program.length()) {
            char command = program.charAt(instrPointer);

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
                        System.err.println("Attempted to decrement data pointer below 0 at position " + instrPointer);
                        System.exit(1);
                    }
                    state.pos--;
                    break;
                case '.':
                    System.out.print((char) state.readCurCell());
                    break;
                case ',':
                    throw new UnsupportedOperationException("',' command is not supported");
                case '[':
                    if (state.readCurCell() == 0) {
                        int depth = 1;
                        int pos = instrPointer;

                        while (depth > 0) {
                            pos++;

                            if (program.charAt(pos) == '[') {
                                depth++;
                            } else if (program.charAt(pos) == ']') {
                                depth--;
                            }

                            if (depth > 0 && pos == program.length()) {
                                System.err.println("Unmatched '[' at position " + instrPointer);
                                System.exit(1);
                            }
                        }

                        instrPointer = pos;
                    }
                    break;
                case ']':
                    if (state.readCurCell() != 0) {
                        int depth = 1;
                        int pos = instrPointer;

                        while (depth > 0) {
                            pos--;

                            if (program.charAt(pos) == ']') {
                                depth++;
                            } else if (program.charAt(pos) == '[') {
                                depth--;
                            }

                            if (depth > 0 && pos < 0) {
                                System.err.println("Unmatched ']' at position " + instrPointer);
                                System.exit(1);
                            }
                        }

                        instrPointer = pos;
                    }
                    break;
            }

            instrPointer++;
        }
    }
}
