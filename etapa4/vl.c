//Trabalho de Compiladores 2023/1 - Grupo G - Luma e Juliana
#include "vl.h"

VL *vl_new(int line_number, int token_type, char *token_value){
  VL *valor_lexico = NULL;
  valor_lexico = calloc(1, sizeof(VL));
  if (valor_lexico != NULL){
    valor_lexico->line_number = line_number;
    valor_lexico->token_type = token_type;
    valor_lexico->token_value = strdup(token_value);
  }
  return valor_lexico;
}
