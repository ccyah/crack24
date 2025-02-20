let it_takes_two int_target int_nums =
  let memo = Hashtbl.create 128 in
  let target = { Ratnum.dom = int_target; dedom = 1 } in
  let rec pick_first acc prev nums prev_first_opt curr_path =
    match nums with
    | [] -> acc
    | h :: t ->
        let acc =
          match prev_first_opt with
          | Some prev_first when Ratnum.eq prev_first h -> acc
          | _ -> pick_second acc prev t h None curr_path
        in
        pick_first acc (h :: prev) t (Some h) curr_path
  and pick_second acc prev nums first prev_second_opt curr_path =
    let extend_path a b op =
      curr_path
      ^ Printf.sprintf "%s%s%s -> " (Ratnum.to_string a) op (Ratnum.to_string b)
    in
    match nums with
    | [] -> acc
    | h :: t ->
        let second = h in
        let acc =
          match prev_second_opt with
          | Some prev_second when Ratnum.eq prev_second second -> acc
          | _ ->
              let ops =
                [ (Ratnum.add, "+"); (Ratnum.sub, "-"); (Ratnum.mul, "*") ]
              in
              let acc =
                List.fold_left
                  (fun acc (op, sym) ->
                    check acc
                      ((op first second :: prev) @ t)
                      (extend_path first second sym))
                  acc ops
              in
              let try_division acc a b =
                if Ratnum.is_zero b then acc
                else
                  check acc ((Ratnum.div a b :: prev) @ t) (extend_path a b "/")
              in
              let acc = try_division acc first second in
              if not (Ratnum.eq first second) then
                let acc =
                  check acc
                    ((Ratnum.sub second first :: prev) @ t)
                    (extend_path second first "-")
                in
                try_division acc second first
              else acc
        in
        pick_second acc (h :: prev) t first (Some h) curr_path
  and check acc nums curr_path =
    let nums = List.sort Ratnum.compare nums in
    let nums_str = String.concat "#" (List.map Ratnum.to_string nums) in
    match Hashtbl.mem memo nums_str with
    | true ->
        let new_acc = Hashtbl.find memo nums_str in
        List.map (fun x -> curr_path ^ x) new_acc @ acc
    | false -> (
        match nums with
        | [] -> acc
        | [ x ] -> if Ratnum.eq x target then curr_path :: acc else acc
        | _ ->
            let new_paths = pick_first [] [] nums None "" in
            Hashtbl.add memo nums_str new_paths;
            List.map (fun x -> curr_path ^ x) new_paths @ acc)
  in

  let nums = List.map (fun x -> { Ratnum.dom = x; dedom = 1 }) int_nums in

  check [] nums ""
