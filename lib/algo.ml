let take_two (xs : int list) =
  let rec aux acc curr n remains xs =
    if n = 2
    then (List.rev curr, remains @ xs) :: acc
    else (
      match xs with
      | [] -> acc
      | h :: t ->
        let acc = (*take*) aux acc (h :: curr) (n + 1) remains t in
        (*no take*) aux acc curr n (h :: remains) t)
  in
  aux [] [] 0 [] xs |> List.rev
;;

let take_one xs =
  let rec aux acc l r =
    match r with
    | [] -> acc
    | h :: t ->
      let acc = (h, l @ t) :: acc in
      aux acc (h :: l) t
  in
  aux [] [] xs |> List.rev
;;

(*let permutate xs =*)
(*  let xs = List.sort xs in*)
(*    let rec aux acc xs =*)
(*  let cases = take_one xs in*)
(*    match cases with*)
(*  | [] -> acc*)
