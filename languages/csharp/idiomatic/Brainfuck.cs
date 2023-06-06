using System;
using System.IO;
using System.Runtime.CompilerServices;

public class Program
{
    public static void Main(string[] args)
    {
        if (args.Length != 1)
        {
            Error("You must provide a filename as an argument");
        }

        var program = LoadFile(args[0]);
        RunLoop(program);
    }

    static string LoadFile(string filePath)
    {
        try
        {
            return File.ReadAllText(filePath);
        }
        catch
        {
            Error("Could not load file");
            return null!;
        }
    }

    public static void RunLoop(string program)
    {
        var pos = 0;
        var instr_pointer = 0;
        var cells = new int[512];

        while (instr_pointer < program.Length)
        {
            var command = program[instr_pointer];

            switch (command)
            {
                case '+':
                    WriteCurCell(pos, ref cells, ReadCurCell(pos, cells) + 1);
                    break;
                case '-':
                    WriteCurCell(pos, ref cells, ReadCurCell(pos, cells) - 1);
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
                    Console.Write((char)ReadCurCell(pos, cells));
                    break;
                case ',':
                    WriteCurCell(pos, ref cells, Console.Read());
                    break;
                case '[':
                    if (ReadCurCell(pos, cells) == 0)
                    {
                        var depth = 1;
                        while (depth > 0 && instr_pointer < program.Length)
                        {
                            instr_pointer++;
                            switch (program[instr_pointer])
                            {
                                case '[':
                                    depth++;
                                    break;
                                case ']':
                                    depth--;
                                    break;
                            }
                        }
                    }
                    break;
                case ']':
                    if (ReadCurCell(pos, cells) != 0)
                    {
                        var depth = 1;
                        while (depth > 0 && instr_pointer >= 0)
                        {
                            instr_pointer--;
                            switch (program[instr_pointer])
                            {
                                case ']':
                                    depth++;
                                    break;
                                case '[':
                                    depth--;
                                    break;
                            }
                        }
                    }
                    break;
            }

            instr_pointer++;
        }
    }

    public static int ReadCurCell(int pos, int[] cells)
    {
        if ((uint)pos >= (uint)cells.Length)
        {
            return 0;
        }
        else
        {
            return cells[pos];
        }
    }


    public static void WriteCurCell(int pos, ref int[] cells, int value)
    {
        var cells1 = cells;
        if ((uint)pos >= (uint)cells1.Length)
        {
            WriteCurCellWithResize(pos, ref cells, value);
        }
        else
        {
            cells1[pos] = value;
        }
    }

    private static void WriteCurCellWithResize(int pos, ref int[] cells, int value)
    {
        Array.Resize(ref cells, pos * 2);
        cells[pos] = value;
    }

    static void Error(string msg)
    {
        Console.Error.WriteLine(msg);
        Environment.Exit(1);
    }
}