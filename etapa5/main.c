#include <stdio.h>
#include "ast.h"
extern int yyparse(void);
extern int yylex_destroy(void);
void *arvore = NULL;
void exporta (void *arvore);
int main (int argc, char **argv)
{
  int ret = yyparse(); 
  exporta (arvore);
  yylex_destroy();
  return ret;
}

void exporta (void *arvore)
{
  AST *arvore_ast = (AST*) arvore;
  
  if (arvore != NULL){
    //TODO delete these prints
    //printf("%p [ label=\"%s\" ];\n", arvore_ast, arvore_ast->item->token_value);
    print_iloc(arvore);
    for (int i = 0; i < arvore_ast->number_of_children; i++){
      //printf("%p, %p;\n", arvore_ast, arvore_ast->children[i]);
      //exporta(arvore_ast->children[i]);
    }
  }else{
    printf("Erro: %s recebeu parâmetro arvore = %p.\n", __FUNCTION__, arvore_ast);
  }
}