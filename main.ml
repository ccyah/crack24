let target = ref 0
let nums = ref []
let usage_msg = "crack24 -t <target> -- <n1> <n2> [<nn>]..."

let parse_numbers args =
  try List.map int_of_string args with
  | Failure _ -> failwith "Invalid number provided. Please provide integers only."
;;

let speclist =
  [ "-t", Arg.Set_int target, "Target integer"
  ; ( "--"
    , Arg.Rest_all (fun args -> nums := parse_numbers args)
    , "List of integers to play with" )
  ]
;;

let anon_fun _ = failwith "Please use the flags! See --help for usage."

let () =
  Arg.parse speclist anon_fun usage_msg;
  if !nums = [] then failwith "No numbers provided. See --help for usage.";
  Printf.printf "Target: %d\nNumbers: " !target;
  List.iter (Printf.printf "%d ") !nums;
  print_newline ();
  match Solver.it_takes_two !target !nums with
  | [] -> print_endline "No possible path found."
  | paths ->
    print_endline "All possible paths:";
    List.iter (fun path -> Printf.printf "%s%d\n" path !target) paths
;;
