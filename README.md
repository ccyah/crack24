## About

24 game cracker with minimal dependencies.

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
% dune exec -- crack24 -t 24 -- 2 3 12 8
Target: 24
Numbers: 2 3 12 8
All possible paths:
12-8 -> 2*4 -> 3*8 -> 24
12-8 -> 3*4 -> 2*12 -> 24
12-8 -> 3*2 -> 4*6 -> 24
12/2 -> 6-3 -> 3*8 -> 24
8/2 -> 12-4 -> 3*8 -> 24
8/2 -> 3*4 -> 12+12 -> 24
8-2 -> 6*12 -> 72/3 -> 24
8-2 -> 12/3 -> 4*6 -> 24
8-2 -> 3/12 -> 6/(1/4) -> 24
8-2 -> 6/3 -> 2*12 -> 24
8-2 -> 3/6 -> 12/(1/2) -> 24
2/8 -> 3/(1/4) -> 12+12 -> 24
12/3 -> 4+8 -> 2*12 -> 24
12/3 -> 8-2 -> 4*6 -> 24
3/12 -> 8-2 -> 6/(1/4) -> 24
3*8 -> 24-12 -> 2*12 -> 24
3*8 -> 24/2 -> 12+12 -> 24
2/3 -> 8/(2/3) -> 12+12 -> 24
3/2 -> 8*(3/2) -> 12+12 -> 24
3*2 -> 12-8 -> 4*6 -> 24
3*2 -> 8-6 -> 2*12 -> 24

```

## TODO

1. change to big int operation
2. support irratinal nums?
