// Runs an infinite loop that listens to the keyboard input. 
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel. When no key is pressed, 
// the screen should be cleared.


//FUNC: SPIN WHILE NO INPUT
(spin_while_no_input)
    // first make screen white
    @make_screen_white
    0;JMP
    (return_from_make_screen_white)

(spin_while_no_input_loop)
    @KBD
    D=M
    @spin_while_no_input_loop
    D;JEQ
    // key was pressed
    @spin_while_input
    0;JMP


//FUNC: SPIN WHILE INPUT
(spin_while_input)
    // first make screen black
    @make_screen_black
    0;JMP
    (return_from_make_screen_black)

(spin_while_input_loop)
    @KBD
    D=M
    @spin_while_input_loop
    D;JNE
    // key was pressed
    @spin_while_no_input
    0;JMP


// FUNC: MAKE SCREEN BLACK
(make_screen_black)
    @current_screen_offset
    M=0

(make_screen_black_test) // have no idia how to name this
    @SCREEN
    D=A
    @current_screen_offset
    D=D+M
    @KBD
    D=D-A
    @return_from_make_screen_black
    D;JEQ

(make_screen_black_loop)
    @SCREEN
    D=A
    @current_screen_offset
    A=D+M
    M=-1
    @current_screen_offset
    M=M+1
    @make_screen_black_test
    0;JMP


// FUNC: MAKE SCREEN WHITE
(make_screen_white)
    @current_screen_offset
    M=0

(make_screen_white_test) 
    @SCREEN
    D=A
    @current_screen_offset
    D=D+M
    @KBD
    D=D-A
    @return_from_make_screen_white
    D;JEQ

(make_screen_white_loop)
    @SCREEN
    D=A
    @current_screen_offset
    A=D+M
    M=0
    @current_screen_offset
    M=M+1
    @make_screen_white_test
    0;JMP
