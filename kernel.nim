{.used.}

var
    bss {.importc: "__bss".}: ptr cchar
    bss_end {.importc: "__bss_end".}: ptr cchar
    stack_top {.importc: "__stack_top".}: ptr cchar

type
    sbiret* {.importc: "struct sbiret", header: "kernel.h".} = object
        error: clong
        value: clong

{.emit: """
#include "kernel.h"

struct sbiret sbi_call(long arg0, long arg1, long arg2, long arg3, long arg4,
                       long arg5, long fid, long eid) {
    register long a0 __asm__("a0") = arg0;
    register long a1 __asm__("a1") = arg1;
    register long a2 __asm__("a2") = arg2;
    register long a3 __asm__("a3") = arg3;
    register long a4 __asm__("a4") = arg4;
    register long a5 __asm__("a5") = arg5;
    register long a6 __asm__("a6") = fid;
    register long a7 __asm__("a7") = eid;

    __asm__ __volatile__("ecall"
                         : "=r"(a0), "=r"(a1)
                         : "r"(a0), "r"(a1), "r"(a2), "r"(a3), "r"(a4), "r"(a5),
                           "r"(a6), "r"(a7)
                         : "memory");
    return (struct sbiret){.error = a0, .value = a1};
}
""".}

proc sbi_call(arg0: clong, arg1: clong, arg2: clong, arg3: clong,
              arg4: clong, arg5: clong, fid: clong, eid: clong): sbiret {.importc, nodecl.}

proc putchar(ch: cchar) =
    discard sbi_call(cast[clong](ch), 0, 0, 0, 0, 0, 0, 1)

proc memset(buf: pointer, c: char, n: csize_t): pointer {.exportc.} =
    var p: ptr uint8 = cast[ptr uint8](buf)
    for i in 0..n:
        (cast[ptr uint8](cast[uint](p) + i.uint))[] = cast[uint8](c)
    return buf

proc kernel_main() {.exportc.} =
    discard memset(cast[pointer](bss.addr), 0.char,
        cast[uint](cast[pointer](bss_end.addr)) - cast[uint](cast[pointer](bss.addr))
    )

    let s: cstring = "\n\nHello, World!\n"

    for ch in s:
        putchar ch

    while true:
        asm "wfi"

proc boot() {.exportc, asmNoStackFrame, codegenDecl: """__attribute__((section(".text.boot"))) $# $#$#""".} =
    asm """
        mv sp, %[stack_top]
        j kernel_main
        :
        : [stack_top] "r" (`stack_top`)
    """
