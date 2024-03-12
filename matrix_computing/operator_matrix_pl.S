.data
.globl	_ZNK6MatrixplERKS_
.type	_ZNK6MatrixplERKS_, @function
.text
_ZNK6MatrixplERKS_: # name mangling for operator+ (pl for +)
pushl %ebp
movl  %esp, %ebp
pushl %ebx

movl 12(%ebp), %eax # this
movl 16(%ebp), %ebx # other

movl 4(%eax), %ecx
movl 4(%ebx), %edx

cmpl %ecx, %edx
jne not_additive
movl 8(%eax), %ecx
movl 8(%ebx), %edx
cmpl %ecx, %edx
jne not_additive

# Creation of the new object Matrix:
pushl 8(%eax) # this->col
pushl 4(%eax) # this->lines
pushl 8(%ebp) # x86-32 convention as passing the argument of newMatrix as first parameter
call _ZN6MatrixC2Eii # constructor
addl $12, %esp

# Filling of the new object Matrix:
movl 8(%ebp), %ebx # ebx is now the ptr of this new matrix
movl 12(%ebx), %edx # newMatrix->_elements
pushl 8(%ebx) # newMatrix->_colums
movl $-1, %eax
addl 4(%ebx), %eax
pushl %eax # newMatrix->_lines - 1

loop_i:
    movl 4(%esp), %ecx
    loop_j:
        movl (%esp), %ebx # i
        subl $1, %ecx
        movl 12(%ebp), %eax # this
        pushl %ecx # j
        pushl %ebx # i
        pushl 12(%eax) # this->_elements
        call findAddrElem
        addl $12, %esp
        pushl %eax
        
        movl 16(%ebp), %eax # other 
        pushl %ecx # j
        pushl %ebx # i
        pushl 12(%eax) # other->_elements
        call findAddrElem
        addl $12, %esp
        popl %ebx
        
        flds (%eax) # *(i + other->_elements) + j
        flds (%ebx) # *(i + this->_elements) + j
        faddp # st[0] = this->_elements[i][j] + other._elements[i][j]
        
        movl (%esp), %ebx # i
        pushl %ecx # j
        pushl %ebx # i
        pushl %edx # newMatrix->_elements
        call findAddrElem
        addl $12, %esp

        fstps (%eax) # newMatrix->_elements[i][j] = st[0]

    cmpl $0, %ecx
    jg loop_j

popl %ecx
subl $1, %ecx
pushl %ecx
cmpl $0, %ecx
jge loop_i

addl $8, %esp
movl 8(%ebp), %eax
jmp end

not_additive:
movl 16(%ebp), %ebx
pushl 8(%ebx)
pushl 4(%ebx)
pushl 12(%ebp)
call _ZNK6Matrix16notAdditiveErrorEii
addl $8, %esp

end:
popl %ebx
leave
ret