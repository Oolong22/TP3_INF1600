#ifndef __PROC_ACC_H__
#define __PROC_ACC_H__
#include <ctype.h>

#define MAX_LINE_LENGTH 100
#define NB_BITS_INSTR 16
#define NB_BITS_OPCODE 4

enum OPCODE {
    ADD = 0,
    SUB = 1,
    MUL = 2,
    ST = 3,
    LD = 4,
    BR = 5,
    BRZ = 6,
    BRNZ = 7,
    STOP = 8,
    UNKNOWN = 9,
    NOP = 15
};

const char* DATA_START = ".data";
const char* TEXT_START = ".text";
enum OPCODE getOpcodeFromString(const char* str);
bool isLabel(const char *mot);
char** readCodeFromFile(const char* filename, int* numLines);
__uint16_t* encodeInstructions(char** lines, int numLines);
void freeAllocatedLines(char** lines, int numLines);
int findAdressOfLabel(char** lines, int numLines, char* labelToFind);
void execute_acc(__uint16_t* encodeInstructions, __uint8_t numLine) asm ("execute_acc_asm");
 
#endif /* __PROC_ACC_H__ */