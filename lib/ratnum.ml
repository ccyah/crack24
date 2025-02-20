type t = { dom : int; dedom : int; original : bool }

let rec gcd_aux (a : int) (b : int) = if a = 0 then b else gcd_aux (b mod a) a
let gcd (a : int) (b : int) = if a < b then gcd_aux a b else gcd_aux b a

let add (a : t) (b : t) =
  (* 1. make both dedoms the same *)
  let gcd1 = gcd a.dedom b.dedom in
  (* try my best to avoid overflow here *)
  let dedom = a.dedom * (b.dedom / gcd1) in
  (* 2. do binary operation on both scaled doms *)
  let dom = (b.dedom / gcd1 * a.dom) + (a.dedom / gcd1 * b.dom) in
  let gcd2 = gcd dom dedom in
  (* 3. shrink final dom and dedom *)
  let dom = dom / gcd2 in
  let dedom = dedom / gcd2 in
  { dom; dedom; original = false }

let sub a b = add a { b with dom = -1 * b.dom }

let mul a b =
  let gcd1 = gcd a.dom b.dedom in
  let a_dom = a.dom / gcd1 in
  let b_dedom = b.dedom / gcd1 in
  let gcd2 = gcd a.dedom b.dom in
  let b_dom = b.dom / gcd2 in
  let a_dedom = a.dedom / gcd2 in
  { dom = a_dom * b_dom; dedom = a_dedom * b_dedom; original = false }

let div a b =
  let b_inv = { dom = b.dedom; dedom = b.dom; original = b.original } in
  mul a b_inv

let compare a b = (sub a b).dom
let eq a b = compare a b = 0
let is_zero (x : t) = match x with { dom; _ } -> dom = 0

let to_string x =
  if x.dedom = 1 then Printf.sprintf "%d" x.dom
  else Printf.sprintf "(%d/%d)" x.dom x.dedom
