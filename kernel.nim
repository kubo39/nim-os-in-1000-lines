{.used.}

var
    bss {.importc: "__bss".}: ptr cchar
    bss_end {.importc: "__bss_end".}: ptr cchar
    stack_top {.importc: "__stack_top".}: ptr cchar

proc memset(buf: pointer, c: char, n: csize_t): pointer {.exportc.} =
    var p: ptr uint8 = cast[ptr uint8](buf)
    for i in 0..n:
        (cast[ptr uint8](cast[uint](p) + i.uint))[] = cast[uint8](c)
    return buf

proc kernel_main() {.exportc.} =
    discard memset(cast[pointer](bss.addr), 0.char,
        cast[uint](cast[pointer](bss_end.addr)) - cast[uint](cast[pointer](bss.addr))
    )
    while true:
        discard

proc boot() {.exportc, asmNoStackFrame, codegenDecl: """__attribute__((section(".text.boot"))) $# $#$#""".} =
    asm """
        mv sp, %[stack_top]
        j kernel_main
        :
        : [stack_top] "r" (`stack_top`)
    """
