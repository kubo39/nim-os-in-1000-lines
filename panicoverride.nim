{.push stack_trace: off, profiler:off.}

proc rawoutput(s: string) =
    discard

proc panic(s: string) =
    asm """
        wfi
    """

{.pop.}
