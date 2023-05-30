# frozen_string_literals: true

State = Struct.new(:cells, :pos) do
  def read_cur_cell
    if self.pos >= self.cells.length
      0
    else
      self.cells[self.pos]
    end
  end

  def write_cur_cell(value)
    if self.pos >= self.cells.length
      self.cells.fill(0, self.cells.length, self.pos + 1)
    end

    self.cells[self.pos] = value
  end

  def inc_cur_cell() = self.write_cur_cell((self.read_cur_cell + 1) % 256)
  def dec_cur_cell() = self.write_cur_cell((self.read_cur_cell - 1) % 256)
end

program = IO.read(ARGV.first)

state = State.new([], 0)

def error!(msg)
  STDERR.puts(msg)
  exit 1
end

instr_pointer = 0

while instr_pointer < program.length
  command = program[instr_pointer]

  case command
  when '+'
    state.inc_cur_cell
  when '-'
    state.dec_cur_cell
  when '>'
    state.pos += 1
  when '<'
    error!("Attempted to decrement data pointer below 0 at position #{instr_pointer}") if state.pos == 0
    state.pos -= 1
  when '.'
    print(state.read_cur_cell.chr)
  when ','
    state.write_cur_cell(STDIN.readchar)
  when '['
    if state.read_cur_cell.zero?
      depth = 0
      pos = instr_pointer

      loop do
        pos += 1

        case program[pos]
        when '['
          depth += 1
        when ']'
          if depth > 0
            depth -= 1
          else
            instr_pointer = pos
            break
          end
        when nil
          error!("Unmatched '[' at position #{instr_pointer}")
        end
      end
    end
  when ']'
    unless state.read_cur_cell.zero?
      depth = 0
      pos = instr_pointer

      loop do
        pos -= 1

        case program[pos]
        when ']'
          depth += 1
        when '['
          if depth > 0
            depth -= 1
          else
            instr_pointer = pos
            break
          end
        when nil
          error!("Unmatched ']' at position #{instr_pointer}")
        end
      end
    end
  end

  instr_pointer += 1
end

