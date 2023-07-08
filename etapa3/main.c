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
  if(arvore == 0)
    return;

  if(arvore){
    int i = 0;

    for (i; i<number_of_children; i++)
    {
      //TODO: check if we print arvore or arvore->label
      //Check if we should do it like this or %p,$p
      printf("%p [ label=\"%s\"]/n", arvore, arvore->label);
      exporta(arvore->children[i]);
    }
  }

  return;
}