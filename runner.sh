#!bin/bash
lex $1.l
gcc lex.yy.c -ll
./a.out

# Path: main.l