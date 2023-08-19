//Implementar duas estruturas de dados: uma para representar uma operação ILOC e os argumentos necessários para ela;
//outra para manter uma lista de operações ILOC.
#ifndef ILOC_Op_HEADER
#define ILOC_Op_HEADER

#include<stdio.h>
#include "vl.h"

enum op_type {
    left,
    right,
    control,
    cmp,
    jump
};

typedef struct ILOC_operation
{
    char *operation;
} ILOC_OP;

ILOC_OP *iloc_op_new(char* operation, char* r1, char* r2, char* r3, enum op_type type);

#endif //ILOC_Op_HEADER