#include <stdio.h>
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
  int i;
  if (arvore != NULL){
    printf("%p [ label=\"%s\" ];\n", arvore, arvore->label);
    for (i = 0; i < arvore->number_of_children; i++){
      fprintf("%p, %p;\n", arvore, arvore->children[i]);
      exporta(arvore->children[i]);
    }
  }else{
    printf("Erro: %s recebeu parâmetro arvore = %p.\n", __FUNCTION__, arvore);
  }
}