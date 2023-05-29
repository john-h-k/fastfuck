using System;
using System.IO;

public class Program
{
    private static int[] cells = new int[0];
    private static int pos = 0;

    static void Main(string[] args)
    {
        if (args.Length != 1)
        {
            Error("You must provide a filename as an argument");
        }

        string program;
        try
        {
            program = File.ReadAllText(args[0]);
        }
        catch
        {
            Error("Could not open file");
            return;
        }

        int instr_pointer = 0;

        while (instr_pointer < program.Length)
        {
            char command = program[instr_pointer];

            switch (command)
            {
                case '+':
                    WriteCurCell(ReadCurCell() + 1);
                    break;
                case '-':
                    WriteCurCell(ReadCurCell() - 1);
                    break;
                case '>':
                    pos++;
                    break;
                case '<':
                    if (pos == 0)
                    {
                        Error("Attempted to decrement data pointer below 0");
                    }
                    pos--;
                    break;
                case '.':
                    Console.Write((char)ReadCurCell());
                    break;
                case ',':
                    WriteCurCell(Console.Read());
                    break;
                case '[':
                    if (ReadCurCell() == 0)
                    {
                        int depth = 1;
                        while (depth > 0 && instr_pointer < program.Length)
                        {
                            instr_pointer++;
                            if (program[instr_pointer] == '[')
                            {
                                depth++;
                            }
                            else if (program[instr_pointer] == ']')
                            {
                                depth--;
                            }
                        }
                    }
                    break;
                case ']':
                    if (ReadCurCell() != 0)
                    {
                        int depth = 1;
                        while (depth > 0 && instr_pointer >= 0)
                        {
                            instr_pointer--;
                            if (program[instr_pointer] == ']')
                            {
                                depth++;
                            }
                            else if (program[instr_pointer] == '[')
                            {
                                depth--;
                            }
                        }
                    }
                    break;
            }

            instr_pointer++;
        }
    }

    static int ReadCurCell()
    {
        if (pos >= cells.Length)
        {
            return 0;
        }
        else
        {
            return cells[pos];
        }
    }

    static void WriteCurCell(int value)
    {
        if (pos >= cells.Length)
        {
            Array.Resize(ref cells, pos + 1);
        }

        cells[pos] = value;
    }

    static void Error(string msg)
    {
        Console.Error.WriteLine(msg);
        Environment.Exit(1);
    }
}
