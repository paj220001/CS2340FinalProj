.data 
    display:         .space 4096                    # Allocate space for a 32x32 pixel display (32*32*4 bytes)
    newline:         .asciiz "\n"
    question_pixels:
        .word 10
        .word 10
        .word 11
        .word 10
        .word 12
        .word 10
        .word 13
        .word 14
        .word 10
        .word 14
        .word 11
        .word 14
        .word 12
        .word 13
        .word 13
        .word 12
        .word 14
        .word 11
        .word 15
        .word 10
        .word 16
        .word 10
        .word 17
        .word 10
        .word 18
        .word 10
        .word 19
        .word 10
        .word 20
        .word 11
        .word 20
        .word 12
        .word 20
        .word 13
        .word 20
        .word 14
        .word 20
        .word -1
        .word -1            # Sentinel to mark end of list

    # Optional: If you have other data, define them here
    space_str:       .asciiz " "
    hidden_char:     .asciiz "?"
    revealed_char:   .asciiz "*"

.text
    .globl main

main:
    # Initialize Registers
    la      $t0, display       # Load base address of display into $t0
    li      $t1, 0             # Offset counter (in bytes)
    li      $t2, 0xFFFFFF      # White color (background)

    # Step 1: Initialize the entire display to white
initialize_background:
    bge     $t1, 4096, draw_question    # If offset >= display size, proceed
    sw      $t2, 0($t0)                  # Set current pixel to white
    addi    $t0, $t0, 4                  # Move to next pixel
    addi    $t1, $t1, 4
    j       initialize_background

draw_question:
    # Reset Registers for drawing
    la      $t0, display       # Reset base address of display

    # Initialize pointer to question_pixels
    la      $t3, question_pixels

draw_question_loop:
    lw      $t4, 0($t3)       # Load x coordinate
    lw      $t5, 4($t3)       # Load y coordinate
    beq     $t4, -1, exit_program   # If x == -1, end of list
    beq     $t5, -1, exit_program   # If y == -1, end of list

    # Calculate pixel index: y * width + x
    li      $t6, 32           # Width of the display
    mul     $t7, $t5, $t6     # y * width
    add     $t7, $t7, $t4     # y * width + x
    sll     $t7, $t7, 2       # Multiply by 4 to get byte offset

    # Set pixel to black
    la      $t8, display
    add     $t9, $t8, $t7     # Address of the target pixel
    li      $t5, 0x000000     # Black color (reuse $t5)
    sw      $t5, 0($t9)        # Set pixel to black

    # Move to next pair of coordinates
    addi    $t3, $t3, 8        # Move to next (x, y) pair (2 words = 8 bytes)
    j       draw_question_loop

exit_program:
    # Optionally, you can print a newline or exit
    la      $a0, newline        # Use 'newline' defined in .data
    li      $v0, 4              # Syscall for print string
    syscall

    li      $v0, 10             # Syscall for exit
    syscall
