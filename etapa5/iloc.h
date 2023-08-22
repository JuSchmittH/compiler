//Implementar duas estruturas de dados: uma para representar uma operação ILOC e os argumentos necessários para ela;
//outra para manter uma lista de operações ILOC.
#ifndef ILOC_Op_HEADER
#define ILOC_Op_HEADER

#include <stdio.h>
#include "vl.h"

enum op_type {
    left,
    right,
    control,
    cbr,
    jump,
    label
};

typedef struct ILOC_operation
{
    char *operation;
} ILOC_OP;

ILOC_OP *iloc_op_new(char* operation, char* register1, char* register2, char* register3, enum op_type type);

char* get_label();

char* get_temp();

char* concatCode();

#endif //ILOC_Op_HEADER