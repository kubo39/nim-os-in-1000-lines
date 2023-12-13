# Error: arguments can only be given if the '--run' option is selected

```console
$ ./run.sh
+ QEMU=qemu-system-riscv32
+ nim c kernel.nim --out:kernel.elf
Hint: used config file '/home/kubo39/dev/nim/Nim/config/nim.cfg' [Conf]
Hint: used config file '/home/kubo39/dev/nim/Nim/config/config.nims' [Conf]
Hint: used config file '/home/kubo39/dev/nim-os-in-1000-lines/nim.cfg' [Conf]
Error: arguments can only be given if the '--run' option is selected
```

should be `nim c --out:kernel.elf kernel.nim`.

# ld.lld: error: unable to find library -ldl

```console
$ ./run.sh
+ QEMU=qemu-system-riscv32
+ nim c --out:kernel.elf kernel.nim
Hint: used config file '/home/kubo39/dev/nim/Nim/config/nim.cfg' [Conf]
Hint: used config file '/home/kubo39/dev/nim/Nim/config/config.nims' [Conf]
Hint: used config file '/home/kubo39/dev/nim-os-in-1000-lines/nim.cfg' [Conf]
..............................................
Hint:  [Link]
ld.lld: error: unable to find library -ldl
clang: error: ld.lld command failed with exit code 1 (use -v to see invocation)
Error: execution of an external program failed: 'clang   -o /home/kubo39/dev/nim-os-in-1000-lines/kernel.elf  /home/kubo39/dev/nim-os-in-1000-lines/build/@m..@snim@sNim@slib@ssystem.nim.c.o /home/kubo39/dev/nim-os-in-1000-lines/build/@mkernel.nim.c.o   --target=riscv32 -Wl,-Tkernel.ld -Wl,-Map=kernel.map -nostdlib -static  -ldl'
```

諦めて `--noLinking` を利用した。
