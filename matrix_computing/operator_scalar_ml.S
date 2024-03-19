.data
.globl	_ZNK6MatrixmlEf
.type	_ZNK6MatrixmlEf, @function
.text
_ZNK6MatrixmlEf:
pushl %ebp
movl  %esp, %ebp
pushl %ebx

# 4(%eax) Lignes
# 8(%eax) Colonnes
# 12(%eax) Elements

movl 12(%ebp), %eax # this Charge l'adresse de l'objet courant (this) dans eaxx

#Creation de matrice
pushl 8(%eax)        # this->col Pousse le nombre de colonnes de `this` sur la pile
pushl 4(%eax)        # this->lines Pousse le nombre de lignes de `this` sur la pile
pushl 8(%ebp)        # x86-32 convention as passing the argument of newMatrix as first parameter
call _ZN6MatrixC2Eii # constructor
addl $12, %esp       # Ajuste la pile

movl 8(%ebp), %ebx   # ebx is now the ptr of this new matrix
movl 12(%ebx), %edi  # newMatrix->_elements. Elements de la nouvelle matrice
movl %ebx, %edi      # newMatrix->_elements. Elements de la nouvelle matrice
pushl 8(%ebx)        # newMatrix->_colums
movl $-1, %eax       # Initialise eax à -1
addl 4(%ebx), %eax   # Ajoute le nombre de lignes à eax
pushl %eax           # newMatrix->_lines - 1

loop_i:
    movl 4(%esp), %ecx # Charge le compteur de lignes dans ecx
    loop_j:
        movl (%esp), %ebx    # i Charge le compteur de colonnes dans ebx
        subl $1, %ecx        # Décrémente le compteur de lignes
        movl 12(%ebp), %eax  # this
        pushl %ecx           # j   Sauvegarde le compteur de lignes (i) sur la pile
        pushl %ebx           # i   Sauvegarde le compteur de colonnes (j) sur la pile
        pushl 12(%eax)       # this->_elements
        call findAddrElem    # Appelle findAddrElem pour trouver l'adresse de l'élément [i][j] de `this`
        addl $12, %esp       # Nettoie la pile des arguments de findAddrElem

        flds (%eax)          # Load element of `this` into st[0]
        flds 16(%ebp)        # Load scalar into st[0]
        fmulp                # Multiply st[0] by st[1]

        pushl %ebx           # j   Sauvegarde le compteur de colonnes (j) sur la pile
        pushl %ecx           # i   Sauvegarde le compteur de lignes (i) sur la pile
        pushl 12(%edi)
        call findAddrElem    # Appelle findAddrElem pour trouver l'adresse de l'élément [i][j] de `this`
        addl $12, %esp       # Nettoie la pile des arguments de findAddrElem

        fstps (%eax)        # Store result in newMatrix->_elements[i][j]

    cmpl $0, %ecx
    jg loop_j

popl %ecx          # Restaure le compteur de lignes (pour la boucle externe)
subl $1, %ecx      # Décrémente le compteur de lignes
pushl %ecx         # Remet le compteur de lignes sur la pile pour la prochaine itération
cmpl $0, %ecx      # Vérifie si toutes les lignes ont été traitées
jge loop_i         # Si non, continue la boucle externe

addl $8, %esp       # Ajuste la pile après les boucles
movl 8(%ebp), %eax
jmp end

end:
popl %ebx
leave
ret