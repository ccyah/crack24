let it_takes_two target nums =
  let memo = Hashtbl.create 128 in
  let rec pick_first acc prev nums prev_first_opt curr_path =
    match nums with
    | [] -> acc
    | h :: t ->
      let acc =
        if Option.is_some prev_first_opt && Option.get prev_first_opt = h
        then acc
        else pick_second acc prev t h None curr_path
      in
      pick_first acc (h :: prev) t (Some h) curr_path
  and pick_second acc prev nums first prev_second_opt curr_path =
    let extend_path a b op = curr_path ^ Printf.sprintf "%d%s%d -> " a op b in
    match nums with
    | [] -> acc
    | h :: t ->
      let second = h in
      let acc =
        if Option.is_some prev_second_opt && Option.get prev_second_opt = second
        then acc
        else (
          let acc =
            check acc (((first + second) :: prev) @ t) (extend_path first second "+")
          in
          let acc =
            check acc (((first - second) :: prev) @ t) (extend_path first second "-")
          in
          let acc =
            check acc (((first * second) :: prev) @ t) (extend_path first second "*")
          in
          let try_division acc a b =
            if b = 0 || a mod b <> 0
            then acc
            else check acc (((a / b) :: prev) @ t) (extend_path a b "/")
          in
          let acc = try_division acc first second in
          if first <> second
          then (
            let acc =
              check acc (((second - first) :: prev) @ t) (extend_path second first "-")
            in
            try_division acc second first)
          else acc)
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
       | [ x ] -> if x = target then curr_path :: acc else acc
       | _ ->
         let new_paths = pick_first [] [] nums None "" in
         Hashtbl.add memo nums_str new_paths;
         List.map (fun x -> curr_path ^ x) new_paths @ acc)
  in
  check [] nums ""
;;
