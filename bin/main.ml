let target = ref 0
let nums = ref []
let memo = Hashtbl.create 128
let usage_msg = "crack24 -t <target> -- <n1> <n2> [<nn>]..."

let speclist =
  [ "-t", Arg.Set_int target, "target integer"
  ; ( "--"
    , Arg.Rest_all (fun x -> nums := List.map int_of_string x)
    , "list of integers to play with" )
  ]
;;

let anon_fun _ = failwith "hey use the flags! see --help"

let rec pick_first acc prev nums prev_first_opt curr_path =
  match nums with
  | [] -> acc
  | h :: t ->
    let acc =
      let do_pick_second () = pick_second acc prev t h None curr_path in
      match prev_first_opt with
      | None -> do_pick_second ()
      | Some prev_first -> if prev_first <> h then do_pick_second () else acc
    in
    pick_first acc (h :: prev) t (Some h) curr_path

and pick_second acc prev nums first prev_second_opt curr_path =
  let extend_path a b op = curr_path ^ Printf.sprintf "%d%s%d;" a op b in
  match nums with
  | [] -> acc
  | h :: t ->
    let do_opts () =
      let second = h in
      let acc =
        check acc (((first + second) :: prev) @ t) (extend_path first second "+")
      in
      let acc =
        check acc (((first - second) :: prev) @ t) (extend_path first second "-")
      in
      let acc =
        check acc (((second - first) :: prev) @ t) (extend_path second first "-")
      in
      let acc =
        check acc (((first * second) :: prev) @ t) (extend_path first second "*")
      in
      let do_division acc a b =
        if b = 0 || a mod b <> 0
        then acc
        else check acc (((a / b) :: prev) @ t) (extend_path a b "/")
      in
      let acc = do_division acc first second in
      do_division acc second first
    in
    let acc =
      match prev_second_opt with
      | None -> do_opts ()
      | Some prev_second -> if prev_second <> h then do_opts () else acc
    in
    pick_second acc (h :: prev) t first (Some h) curr_path

and check acc nums curr_path =
  let nums = List.sort compare nums in
  let nums_str = String.concat "#" (List.map string_of_int nums) in
  match Hashtbl.mem memo nums_str with
  | true ->
    let new_acc = Hashtbl.find memo nums_str in
    List.map (fun x -> curr_path ^ x) new_acc @ acc
  | false ->
    (match nums with
     | [] -> acc
     | [ x ] -> if x = !target then curr_path :: acc else acc
     | _ ->
       let new_paths = pick_first [] [] nums None "" in
       Hashtbl.add memo nums_str new_paths;
       List.map (fun x -> curr_path ^ x) new_paths @ acc)
;;

let () =
  Arg.parse speclist anon_fun usage_msg;
  Printf.printf "target: %d;\n" !target;
  Printf.printf "nums: ";
  List.iter (Printf.printf "%d;") !nums;
  print_newline ();
  match pick_first [] [] !nums None "" with
  | [] -> print_endline "no possible path"
  | paths ->
    print_endline "all possible paths:";
    List.iter print_endline paths
;;
