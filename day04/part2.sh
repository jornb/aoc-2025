#!/usr/bin/env bash
set -e

nasm -felf64 part2.asm
ld part2.o

cat input.txt | ./a.out
