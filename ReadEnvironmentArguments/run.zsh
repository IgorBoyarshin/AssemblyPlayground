#!/usr/bin/zsh

# nasm -f elf32 main.asm -o main.o
# ld -m elf_i386 -s -o main main.o
nasm -f elf64 main.asm -o main.o
# gcc -no-pie main.o -o main
ld -s -o main main.o
./main 5 par2 par3

rm -f main.o
rm -f main
