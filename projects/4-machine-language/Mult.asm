// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)
// The algorithm is based on repetitive addition.

    // R2 = 0
    @R2
    M=0

// if R0 == 0: goto end
(TEST)
    @R0
    D=M
    @END
    D;JEQ

(LOOP)
    // R2 = R2 + R1
    @R2
    D=M
    @R1
    D=D+M
    @R2
    M=D
    // R0 -= 1
    @R0
    M=M-1
    // goto TEST
    @TEST
    0;JMP

(END)
    @END
    0;JMP
