.data
.globl	_ZNK6MatrixmlERKS_
.type	_ZNK6MatrixmlERKS_, @function
.text
_ZNK6MatrixmlERKS_:
pushl %ebp
movl  %esp, %ebp
pushl %ebx

# TODO: a comparaison to detect if the matrix is multiplicatable or not
jne not_multiplicatable

# TODO: creates the new object

not_multiplicatable:
# TODO: call correct error function with correct parameters

end:
popl %ebx
leave
ret