.data
.globl	_ZNK6MatrixplERKS_
.type	_ZNK6MatrixplERKS_, @function
.text
_ZNK6MatrixplERKS_: # name mangling for operator+ (pl for +)
pushl %ebp          # Sauvegarde l'ancien base pointer
movl  %esp, %ebp    # Établit le nouveau base pointer
pushl %ebx          # Sauvegarde le registre ebx qui sera utilisé dans la fonction

movl 12(%ebp), %eax # this Charge l'adresse de l'objet courant (this) dans eax
movl 16(%ebp), %ebx # other Charge l'adresse de l'objet `other` dans ebx

movl 4(%eax), %ecx  # Charge le nombre de lignes de `this` dans ecx
movl 4(%ebx), %edx  # Charge le nombre de lignes de `other` dans edx
cmpl %ecx, %edx      # Compare les nombres de lignes
jne not_additive     # Saute si les matrices n'ont pas le même nombre de lignes

movl 8(%eax), %ecx   # Charge le nombre de colonnes de `this` dans ecx
movl 8(%ebx), %edx   # Charge le nombre de colonnes de `other` dans edx
cmpl %ecx, %edx      # Compare les nombres de colonnes
jne not_additive     # Saute si les matrices n'ont pas le même nombre de colonnes

# Creation of the new object Matrix:
pushl 8(%eax)        # this->col Pousse le nombre de colonnes de `this` sur la pile
pushl 4(%eax)        # this->lines Pousse le nombre de lignes de `this` sur la pile
pushl 8(%ebp)        # x86-32 convention as passing the argument of newMatrix as first parameter
call _ZN6MatrixC2Eii # constructor
addl $12, %esp       # Ajuste la pile

# Filling of the new object Matrix:
movl 8(%ebp), %ebx   # ebx is now the ptr of this new matrix
movl 12(%ebx), %edx  # newMatrix->_elements
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
        pushl %ecx           # j   Sauvegarde le compteur de colonnes (j) sur la pile
        pushl %ebx           # i   Sauvegarde le compteur de lignes (i) sur la pile
        pushl 12(%eax)       # this->_elements
        call findAddrElem    #Appelle findAddrElem pour trouver l'adresse de l'élément [i][j] de `this`
        addl $12, %esp       #Nettoie la pile des arguments de findAddrElem
        pushl %eax           #Sauvegarde l'adresse de l'élément de `this` trouvée
        
        movl 16(%ebp), %eax  # other Charge l'adresse de l'objet `other` dans eax
        pushl %ecx           # j
        pushl %ebx           # i
        pushl 12(%eax)       # other->_elements
        call findAddrElem    # Trouve l'adresse de l'élément [i][j] de `other`
        addl $12, %esp       # Nettoie la pile
        popl %ebx
        
        flds (%eax) # *(i + other->_elements) + j  # Charge l'élément de `other` sur le sommet de la pile flottante
        flds (%ebx) # *(i + this->_elements) + j    # Charge l'élément de `this` sur le sommet de la pile flottante
        faddp # st[0] = this->_elements[i][j] + other._elements[i][j] # Additionne les deux valeurs au sommet de la pile flottante et stocke le résultat
        
        movl (%esp), %ebx # i Restaure le compteur de lignes dans ebx pour le prochain usage
        pushl %ecx # j
        pushl %ebx # i
        pushl %edx # newMatrix->_elements
        call findAddrElem
        addl $12, %esp

        fstps (%eax) # newMatrix->_elements[i][j] = st[0] Stocke le résultat de l'addition dans l'élément [i][j] du nouveau Matrix

    cmpl $0, %ecx  # Compare le compteur de colonnes à 0
    jg loop_j      # Continue la boucle interne si le compteur de colonnes est > 0

popl %ecx          # Restaure le compteur de lignes (pour la boucle externe)
subl $1, %ecx      # Décrémente le compteur de lignes
pushl %ecx         # Remet le compteur de lignes sur la pile pour la prochaine itération
cmpl $0, %ecx      # Vérifie si toutes les lignes ont été traitées
jge loop_i         # Si non, continue la boucle externe

addl $8, %esp       # Ajuste la pile après les boucles
movl 8(%ebp), %eax
jmp end

not_additive:       # Appelle une fonction pour gérer l'erreur de dimension
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
#message.txt
#5 KB