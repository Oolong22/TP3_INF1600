.data
linesM1: .int 0
columnsM1: .int 0
elementsM1: .int 0

linesM2: .int 0
columnsM2: .int 0
elementsM2: .int 0

elementsM3: .int 0

lineCounterM1: .int 0
columnCounterM1: .int 0

lineCounterM2: .int 0
columnCounterM2: .int 0

valueM1: .float 0.0
valueM2: .float 0.0

result: .float 0.0

.globl	_ZNK6MatrixmlERKS_
.type	_ZNK6MatrixmlERKS_, @function
.text
_ZNK6MatrixmlERKS_:
pushl %ebp
movl  %esp, %ebp
pushl %ebx

# Placement des pointeurs vers M1 et M2 dans %eax et %ebx
movl 12(%ebp), %eax
movl 16(%ebp), %ebx

# Récupération des dimensions de M1: lignes, colonnes et éléments
movl 4(%eax), %edx
movl %edx, linesM1

movl 8(%eax), %edx
movl %edx, columnsM1

movl 12(%eax), %edx
movl %edx, elementsM1

# Récupération des dimensions de M2: lignes, colonnes et éléments
movl 4(%ebx), %edx
movl %edx, linesM2

movl 8(%ebx), %edx
movl %edx, columnsM2

movl 12(%ebx), %edx
movl %edx, elementsM2

# Vérification de la compatibilité des dimensions pour la multiplication: M1.columns == M2.lines
movl columnsM1, %ecx
movl linesM2, %edx
cmp %ecx, %edx
jne non_multiplicative

# Création de la matrice résultante
pushl columnsM2
pushl linesM1
pushl 8(%ebp)
call _ZN6MatrixC2Eii
addl $12, %esp

# Placement du pointeur vers la matrice résultante dans elementsM3
movl 8(%ebp), %ecx
movl 12(%ecx), %edx
movl %edx, elementsM3

movl linesM1, %ecx
movl %ecx, lineCounterM1

# Boucle sur les lignes de M1
loopM1:
movl columnsM2, %ecx
movl %ecx, columnCounterM2

subl $1, lineCounterM1
jb end

    # Boucle sur les colonnes de M2
    loopM2:
    subl $1, columnCounterM2
    jb loopM1

    movl $0, result

    movl linesM2, %ecx
    movl %ecx, lineCounterM2

        computeResultMul:
        subl $1, lineCounterM2
        jb loopM2

        # Trouver l'adresse de l'élément de M1
        pushl lineCounterM2
        pushl lineCounterM1
        pushl elementsM1
        call findAddrElem
        addl $12, %esp
        movl (%eax), %ecx
        movl %ecx, valueM1

        # Trouver l'adresse de l'élément de M2
        pushl columnCounterM2
        pushl lineCounterM2
        pushl elementsM2
        call findAddrElem
        addl $12, %esp
        movl (%eax), %ecx
        movl %ecx, valueM2

        # Calcul du résultat
        flds valueM1
        fmuls valueM2
        fadds result
        fstps result

        # Trouver l'adresse de l'élément de la matrice résultante
        pushl columnCounterM2
        pushl lineCounterM1
        pushl elementsM3
        call findAddrElem
        add $12, %esp

        # Stocker le résultat dans la matrice résultante
        movl result, %ecx
        movl %ecx, (%eax)

        jmp computeResultMul

non_multiplicative:
pushl linesM2
pushl 8(%ebp)
call _ZNK6Matrix23notMultiplicatableErrorEi

end:
popl %ebx
leave
ret