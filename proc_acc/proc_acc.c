#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include "proc_acc.h"

int main(int argc, char* argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
        return 1;
    }

    printf("Le nom du fichier passé en paramètre est: %s\n", argv[1]);

    const char* filename = argv[1];
    int numLines;
    char** lines = readCodeFromFile(filename, &numLines);
    __uint16_t* instructionsEncoded = encodeInstructions(lines, numLines);
    
    printf("Nombre de lignes dans le fichier : %d\n", numLines);
    printf("Contenu de la mémoire avant execution :\n");
    for (int i = 0; i < numLines; i++) {
        printf("0x%04X\n", instructionsEncoded[i]);
    }
    
    printf("Contenu de la mémoire après execution :\n");
    execute_acc(instructionsEncoded, numLines);
    for (int i = 0; i < numLines; i++) {
        printf("0x%04X\n", instructionsEncoded[i]);
    }
    
    freeAllocatedLines(lines, numLines);

    return 0;
}

enum OPCODE getOpcodeFromString(const char* str) {
    if (strcmp(str, "add") == 0) {
        return ADD;
    } else if (strcmp(str, "sub") == 0) {
        return SUB;
    } else if (strcmp(str, "mul") == 0) {
        return MUL;
    } else if (strcmp(str, "st") == 0) {
        return ST;
    } else if (strcmp(str, "ld") == 0) {
        return LD;
    } else if (strcmp(str, "stop") == 0) {
        return STOP;
    } else if (strcmp(str, "br") == 0) {
        return BR;
    } else if (strcmp(str, "brz") == 0) {
        return BRZ;
    } else if (strcmp(str, "brnz") == 0) {
        return BRNZ;
    } else {
        return UNKNOWN;
    }
}

char** readCodeFromFile(const char* filename, int* numLines) {
    FILE* file = fopen(filename, "r");
    if (file == NULL) {
        fprintf(stderr, "Erreur lors de l'ouverture du fichier %s\n", filename);
        exit(EXIT_FAILURE);
    }

    int count = 0;
    char buffer[MAX_LINE_LENGTH];
    while (fgets(buffer, MAX_LINE_LENGTH, file) != NULL) {
        count++;
    }

    fseek(file, 0, SEEK_SET);

    char** lines = (char**)malloc(count * sizeof(char*));
    if (lines == NULL) {
        fprintf(stderr, "Erreur d'allocation de mémoire\n");
        free(lines);
        exit(EXIT_FAILURE);
    }

    int i = 0;
    while (fgets(buffer, MAX_LINE_LENGTH, file) != NULL) {
        buffer[strcspn(buffer, "\r")] = '\0';

        lines[i] = (char*)malloc((strlen(buffer) + 1) * sizeof(char));
        if (lines[i] == NULL) {
            fprintf(stderr, "Erreur d'allocation de mémoire\n");
            freeAllocatedLines(lines, i);
            exit(EXIT_FAILURE);
        }

        strcpy(lines[i++], buffer);
    }

    fclose(file);

    *numLines = count;

    return lines;
}

__uint16_t* encodeInstructions(char** lines, int numLines) {
    char* opcodeChar;
    char* operande;
    char copyLine[MAX_LINE_LENGTH];
    __uint16_t* encodedInstructions = malloc(sizeof(__uint16_t) * numLines);
    __uint16_t instruction;
    int addr;
    int i;
    
    for (i = 0; i < numLines; i++) {
        strcpy(copyLine, lines[i]);
        if (strchr(copyLine,  ' ')) opcodeChar = strtok(copyLine, " ");
        else opcodeChar = copyLine;
        if (!strcmp(opcodeChar, TEXT_START)) {
            encodedInstructions[i] = NOP << (NB_BITS_INSTR - NB_BITS_OPCODE);
            continue;
        } else if (!strcmp(opcodeChar, DATA_START)) {
            encodedInstructions[i] = NOP << (NB_BITS_INSTR - NB_BITS_OPCODE);
            break;
        }

        instruction = getOpcodeFromString(opcodeChar);
        switch (instruction) {
            case UNKNOWN:
                if (isLabel(opcodeChar)) {
                    encodedInstructions[i] = NOP << (NB_BITS_INSTR - NB_BITS_OPCODE);
                    continue;
                } else {
                    fprintf(stderr, "\nErreur lors de la lecture du fichier:\nmauvaise syntaxe:ligne:%d:%s\n", i, opcodeChar);
                }
                break;
            case ADD:
            case SUB:
            case MUL:
            case ST:
            case LD:
            case BR:
            case BRZ:
            case BRNZ:
                operande = strtok(NULL, "");

                addr = findAdressOfLabel(lines, numLines, operande);
                if (addr == -1) {
                    fprintf(stderr, "Erreur lors de la lecture du fichier:\nEtiquette non trouvé:ligne:%d:%s\n", i, operande);
                } else {
                    instruction <<= (NB_BITS_INSTR - NB_BITS_OPCODE);
                    instruction |= addr;
                    encodedInstructions[i] = instruction;
                }
                break;
            case STOP:
                instruction <<= (NB_BITS_INSTR - NB_BITS_OPCODE);
                encodedInstructions[i] = instruction;
                break;
            default:
                break;
        }

    }

    for (i += 1; i < numLines; i++) {
        strcpy(copyLine, lines[i]);
        strtok(copyLine, ":");
        operande = strtok(NULL, "\0");
        encodedInstructions[i] = atoi(operande);
    }

    return encodedInstructions;
}

void freeAllocatedLines(char** lines, int numLines) {
    for (int i = 0; i < numLines; i++) {
        free(lines[i]);
    }
    free(lines);
}

bool isLabel(const char *mot) {
    int i = 0;
    if (mot[0] == '\0')
        return false;
    if (!strcmp(mot, TEXT_START) || !strcmp(mot, DATA_START))
        return true;

    while (mot[i] != '\0') {
        if (mot[i] == ':') {
            for (int j = 0; j < i; j++) {
                if (!isalnum(mot[j]))
                    return false;
            }
            return true;
        }
        i++;
    }

    return false;
}

int findAdressOfLabel(char** lines, int numLines, char* labelToFind) {
    char* label;
    char* ptrTwoPts;
    for (int i = 0; i < numLines; i++) {
        if (isLabel(lines[i])) {
            ptrTwoPts = strchr(lines[i], ':');
            if (ptrTwoPts != NULL) {
                if (!strncmp(labelToFind, lines[i], (int) ptrTwoPts - (int) lines[i] - 1)) {
                    return i;
                }
            }
        }
    }
    return -1;
}