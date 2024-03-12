.data
.globl	findAddrElem
.type	findAddrElem, @function
.text
findAddrElem:
pushl %ebp
movl  %esp, %ebp
pushl %ebx

movl 8(%ebp), %eax # _elements
movl 12(%ebp), %ebx # i
imull $4, %ebx # i addr
addl %eax, %ebx # i + _elements
movl (%ebx), %ebx # *(i + _elements)
movl  16(%ebp), %eax # j
imull $4, %eax # j addr
addl %ebx, %eax # *(i + _elements ) + j

popl %ebx
leave
ret