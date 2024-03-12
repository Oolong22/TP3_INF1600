.data
PC:
.word 0
IR:
.word 0
ACC:
.word 5
OPERANDE:
.byte 0

.equ BIT_OPERAND, 12
.equ ADD, 0
.equ SUB, 1
.equ MUL, 2
.equ ST, 3
.equ LD, 4
.equ BR, 5
.equ BRZ, 6
.equ BRNZ, 7
.equ STOP, 8
.equ NOP, 15
.global execute_acc_asm
.text

execute_acc_asm:
pushl %ebp
movl  %esp, %ebp
pushl %ebx

movl 8(%ebp), %edi
movl 12(%ebp), %ecx

start_exec:
    movl 8(%ebp), %edi
    xor %ebx, %ebx
    movw (PC), %bx
    movw (%edi, %ebx, 2), %ax

    # TODO: put in IR and OPERANDE correct values
    # TODO: put in %ax the opcode

    cmpw $ADD, %ax
    je add_case
    # TODO: rest of cases
    cmpw $NOP, %ax
    je end_switch

    add_case:
        xor %eax, %eax
        movb (OPERANDE), %al
        movw (%edi, %eax, 2), %ax
        addb %al, (ACC)
        jmp end_switch

    sub_case:
        # TODO: Update ACC
        jmp end_switch

    mul_case:
        # TODO: Update ACC
        jmp end_switch

    st_case:
        # TODO
        jmp end_switch

    ld_case:
        xor %eax, %eax
        movb (OPERANDE), %al
        movw (%edi, %eax, 2), %ax
        movw %ax, (ACC)
        jmp end_switch

    br_case:
        movw (%edi, %ebx, 2), %ax
        movb %al, (PC)
        jmp end_switch

    brz_case:
        # TODO
        jmp end_switch


    brnz_case:
        # TODO
        jmp end_switch

    stop_case:
        jmp end

    end_switch:
    incw (PC)
    jmp start_exec


end:

popl %ebx
popl %ebp
ret
