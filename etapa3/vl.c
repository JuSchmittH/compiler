#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include vl.h

VL *vl_new(int line_number, char *token_type, char *token_value){
  VL *valor_lexico = NULL;
  valor_lexico = calloc(1, sizeof(VL));
  if (valor_lexico != NULL){
    valor_lexico->line_number = ;
    valor_lexico->token_type = token_type;
    valor_lexico->token_value = strdup(label);
  }
  return valor_lexico;
}
