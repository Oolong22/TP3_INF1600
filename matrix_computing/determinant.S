.data
.globl	_ZNK12SquareMatrix11determinantEv
.type	_ZNK12SquareMatrix11determinantEv, @function
.text
_ZNK12SquareMatrix11determinantEv:
pushl %ebp
movl  %esp, %ebp
pushl %ebx

# TODO: Compare to know if it is the correct matrix size
jne not_correct_size_matrix

# TODO: Compute the resultant determinant

jmp end

not_correct_size_matrix:
# TODO: call correct error function


end:
popl %ebx
leave
ret