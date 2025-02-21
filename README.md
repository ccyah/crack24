## About

A 24-game cracker implemented with minimal dependencies.

It generates all possible combinations of the "+", "-", "*", and "/" operations on a set of input integers, aiming to reach the target integer (typically 24).

It's a toy project for me to learn ocaml. Not much codes or tests but a lot of trial and err. 

## Usage

```
% dune exec -- crack24 --help
crack24 -t <target> -- <n1> <n2> [<nn>]...
  -t Target integer
  -- List of integers to play with
  -help  Display this list of options
  --help  Display this list of options

```

## Example

```
% dune exec -- crack24 -t 24 -- 2 3 7 8
Target: 24
Numbers: 2 3 7 8
All possible paths:
8+7 -> 15-3 -> 2*12 -> 24
2+7 -> 8*9 -> 72/3 -> 24
2+7 -> 9/3 -> 3*8 -> 24
2+7 -> 3/9 -> 8/(1/3) -> 24
2+7 -> 8/3 -> 9*(8/3) -> 24
2+7 -> 3/8 -> 9/(3/8) -> 24
8-2 -> 7-3 -> 4*6 -> 24
2-8 -> 3-7 -> -6*-4 -> 24
7/3 -> (7/3)-2 -> 8/(1/3) -> 24
7-3 -> 4+8 -> 2*12 -> 24
7-3 -> 8-2 -> 4*6 -> 24
3-7 -> 2-8 -> -6*-4 -> 24
3-7 -> 8--4 -> 2*12 -> 24
8/3 -> 2+7 -> (8/3)*9 -> 24
8-3 -> 5+7 -> 2*12 -> 24
3/8 -> 2+7 -> 9/(3/8) -> 24
3-8 -> 7--5 -> 2*12 -> 24
```

## TODO

1. change to big int operation
2. support irratinal nums?
