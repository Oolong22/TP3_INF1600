.data
.globl	_ZNK12SquareMatrix11determinantEv
.type	_ZNK12SquareMatrix11determinantEv, @function
.text
Hello:
_ZNK12SquareMatrix11determinantEv:
pushl %ebp
movl  %esp, %ebp
pushl %ebx

movl 8(%ebp), %esi      # %esi = this (l'adresse de l'objet SquareMatrix)

# Compare to know if it is the correct matrix size
movl 4(%esi), %ecx      #lignes
cmpl $2, %ecx
jne not_correct_size_matrix
movl 8(%esi), %ecx     #colonnes
cmpl $2, %ecx
jne not_correct_size_matrix

# Compute the resultant determinant

# a = _elements[0][0]
pushl $0                # j = 0
pushl $0                # i = 0
pushl 12(%esi)          # _elements
call findAddrElem
addl $12, %esp          # Nettoyer la pile apres l'appel
flds (%eax)             # Charger la valeur de 'a' dans le sommet de la pile FPU

# d = _elements[1][1]
pushl $1                # j = 1
pushl $1                # i = 1
pushl 12(%esi)          # _elements
call findAddrElem
addl $12, %esp          # Nettoyer la pile apres l'appel
flds (%eax)             # Charger 'd' au sommet de la pile (st(0)), 'a' devient st(1)

fmulp                   # Multiplier st(1) par st(0), stocker le resultat dans st(1), et pop st(0)
                        # Maintenant, st(0) contient ad

# b = _elements[0][1]
pushl $1                # j = 1
pushl $0                # i = 0
pushl 12(%esi)          # _elements
call findAddrElem
addl $12, %esp          # Nettoyer la pile apres l'appel
flds (%eax)             # Charger 'b' dans st(0) et ad devient st(1)

# c = _elements[1][0]
pushl $0                # j = 0
pushl $1                # i = 1
pushl 12(%esi)          # _elements
call findAddrElem
addl $12, %esp          # Nettoyer la pile après l'appel
flds (%eax)             # Charger 'c' dans st(0), b devient st(1) et ad devient st(2)

fmulp                   # Multiplier st(1) par st(0) pour obtenir bc dans st(0) et st(1) est libéré donc ad vient dans st(1)

# Soustraire bc de ad
fsubrp    # Soustraire st(0) de st(1), stocker le résultat dans st(0), et st(1) est libéré

jmp end

not_correct_size_matrix:
# call correct error function

call _ZNK12SquareMatrix25notCorrectSizeMatrixErrorEv

end:
popl %ebx
leave
ret