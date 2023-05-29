let execute_bf code =
  let cell_count = 30000 in
  let cells = Array.make cell_count 0 in
  let rec find_matching_forward_bracket code_ptr depth =
    if code_ptr >= String.length code then
      invalid_arg "Unmatched brackets"
    else if code.[code_ptr] = ']' && depth = 0 then
      code_ptr
    else
      let new_ptr = code_ptr + 1 in
      let new_depth = if code.[code_ptr] = '[' then depth + 1 else if code.[code_ptr] = ']' then depth - 1 else depth in
      find_matching_forward_bracket new_ptr new_depth
  in
  let rec find_matching_backward_bracket code_ptr depth =
    if code_ptr < 0 then
      invalid_arg "Unmatched brackets"
    else if code.[code_ptr] = '[' && depth = 0 then
      code_ptr
    else
      let new_ptr = code_ptr - 1 in
      let new_depth = if code.[code_ptr] = ']' then depth + 1 else if code.[code_ptr] = '[' then depth - 1 else depth in
      find_matching_backward_bracket new_ptr new_depth
  in
  let rec loop code_ptr tape_ptr =
    if code_ptr >= String.length code then
      ()
    else:
      match code.[code_ptr] with
      | '+' -> cells.(tape_ptr) <- (cells.(tape_ptr) + 1) mod 256; loop (code_ptr + 1) tape_ptr
      | '-' -> cells.(tape_ptr) <- (cells.(tape_ptr) - 1) mod 256; loop (code_ptr + 1) tape_ptr
      | '>' -> loop (code_ptr + 1) (tape_ptr + 1)
      | '<' -> loop (code_ptr + 1) (tape_ptr - 1)
      | '.' -> print_char (Char.chr cells.(tape_ptr)); loop (code_ptr + 1) tape_ptr
      | ',' -> cells.(tape_ptr) <- int_of_char (input_char stdin); loop (code_ptr + 1) tape_ptr
      | '[' -> if cells.(tape_ptr) = 0 then loop (find_matching_forward_bracket (code_ptr + 1) 0) tape_ptr else loop (code_ptr + 1) tape_ptr
      | ']' -> if cells.(tape_ptr) <> 0 then loop (find_matching_backward_bracket (code_ptr - 1) 0) tape_ptr else loop (code_ptr + 1) tape_ptr
      | _ -> loop (code_ptr + 1) tape_ptr
  in
  loop 0 0

let () =
  if Array.length Sys.argv <> 2 then
    print_endline "Usage: brainfuck <filename>"
  else
    let filename = Sys.argv.(1) in
    try
      let chan = open_in filename in
      let code = really_input_string chan (in_channel_length chan) in
      close_in chan;
      execute_bf code
    with
    | Sys_error msg -> print_endline ("An error occurred: " ^ msg)
