//Trabalho de Compiladores 2023/1 - Grupo G - Luma e Juliana
#ifndef VL_HEADER
#define VL_HEADER

typedef struct valor_lexico {
  int line_number;
  int token_type;
  char *token_value;
} VL;

VL *vl_new(int line_number, int token_type, char *token_value);

#endif //VL_HEADER