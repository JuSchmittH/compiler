#ifndef VL_HEADER
#define VL_HEADER

//TODO: Ver onde colocar essa struct de valor lexico da parte 2.1 da definição do trabalho
typedef struct valor_lexico {
  int line_number;
  char *token_type;
  char *token_value;
} VL;

/*
 * Função vl_new, cria um valor léxico com as informações passadas.
 */
AST *vl_new(int line_number, char *token_type, char *token_value);

#endif //VL_HEADER