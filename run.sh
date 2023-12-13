#!/bin/bash
set -xue

# QEMUへのファイルパス
QEMU=qemu-system-riscv32

nim c --out:kernel.elf kernel.nim
clang \
    -o kernel.elf \
    build/@mkernel.nim.c.o \
    --target=riscv32 \
    -I./kernel.h \
    -Wl,-Tkernel.ld \
    -Wl,-Map=kernel.map \
    -nostdlib

# QEMUを起動
$QEMU -machine virt -bios default -nographic -serial mon:stdio --no-reboot \
    -kernel kernel.elf
