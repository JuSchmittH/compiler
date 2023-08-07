//Trabalho de Compiladores 2023/1 - Grupo G - Luma e Juliana
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#ifndef VL_HEADER
#define VL_HEADER

typedef struct valor_lexico {
  int line_number;
  int token_type;
  char *token_value;
} VL;

VL *vl_new(int line_number, int token_type, char *token_value);

void printVL(VL *vl);

#endif //VL_HEADER