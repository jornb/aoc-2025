#!/usr/bin/env bash
set -e

nasm -felf64 part1.asm
ld part1.o

cat input.txt | ./a.out
