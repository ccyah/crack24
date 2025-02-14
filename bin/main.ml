let target = 24
let extend_path prev_path a b op = Printf.sprintf "%s%d%s%d;" prev_path a op b

let it_takes_two nums =
  let rec aux acc nums curr_path =
    match nums with
    | [] -> None
    | [ x ] -> if x = target then Some (curr_path :: acc) else Some acc
    | h :: t ->
      let first = h in
      let rec pick_second acc prev nums =
        match nums with
        | [] -> Some acc
        | h :: t ->
          let second = h in
          (* do plus *)
          let res =
            aux
              acc
              (((first + second) :: prev) @ t)
              (extend_path curr_path first second "+")
          in
          let res =
            Option.bind res (fun x ->
              aux
                x
                (((first - second) :: prev) @ t)
                (extend_path curr_path first second "-"))
          in
          let res =
            Option.bind res (fun x ->
              aux
                x
                (((first * second) :: prev) @ t)
                (extend_path curr_path first second "*"))
          in
          Option.bind res (fun x -> pick_second x (h :: prev) t)
      in
      pick_second acc [] t
  in
  aux [] nums ""
;;

let () = print_newline ()

let () =
  match it_takes_two [ 1; 2; 3; 4 ] with
  | None -> print_endline "none"
  | Some paths -> List.iter (fun x -> print_endline x) paths
;;
