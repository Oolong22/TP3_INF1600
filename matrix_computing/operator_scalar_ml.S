.data
scalaire: .float 0.0
addressSource: .int 0
addressDest: .int 0
columnCounter: .int 0
lineCounter: .int 0
position: .int 0
result: .float 0.0

.globl	_ZNK6MatrixmlEf
.type	_ZNK6MatrixmlEf, @function
.text
_ZNK6MatrixmlEf:
# Sauvegarde les registres
pushl %ebp
movl  %esp, %ebp
pushl %ebx

pushl %ecx
pushl %edx
xor %ecx, %ecx
xor %edx, %edx

# Place le scalaire dans la mémoire
movl 16(%ebp), %eax
movl %eax, scalaire

# Place l'adresse de la matrice source dans la mémoire
movl 12(%ebp), %ecx
movl %ecx, addressSource

# Place l'adresse de la matrice destination dans la mémoire
movl 8(%ebp), %edx
movl %edx, addressDest

# Place le nombre de lignes dans la mémoire
movl 4(%ecx), %eax
movl %eax, lineCounter

# Place le nombre de colonnes dans la mémoire
movl 8(%ecx), %eax
movl %eax, columnCounter

# push car le constructeur modifie %ecx
pushl %ecx

pushl columnCounter
pushl lineCounter
pushl addressDest
call _ZN6MatrixC2Eii
add $12, %esp
movl addressDest, %edx

# pop pour reprendre %ecx
popl %ecx

# Debut de la loop pour les lignes
loopLine:
subl $1, lineCounter
jb end

# Reinitalise columnCounter car il va etre a 0 apres un boucle complete de loopColumn
movl 8(%ecx), %eax
movl %eax, columnCounter

    # Debut de la loop pour les colonnes
    loopColumn:
    subl $1, columnCounter
    jb loopLine

    # Trouver l'adresse de l'élément de la matrice source
    pushl columnCounter
    pushl lineCounter
    pushl 12(%ecx)
    call findAddrElem
    addl $12, %esp
    movl (%eax), %ebx
    movl %ebx, position

    # Trouver l'adresse de l'élément de la matrice destination
    pushl columnCounter
    pushl lineCounter
    pushl 12(%edx)
    call findAddrElem
    addl $12, %esp

    # Multiplier l'élément de la matrice source par le scalaire et le place dans result
    flds scalaire
    fmuls position
    fstps result

    # Place le résultat dans la matrice destination
    movl result, %ebx
    movl %ebx, (%eax)

    jmp loopColumn

end:
movl %ebx, %eax
popl %edx
popl %ecx
popl %ebx
popl %ebp
#leave
ret