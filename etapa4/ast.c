//Trabalho de Compiladores 2023/1 - Grupo G - Luma e Juliana
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "ast.h"
#include "vl.h"
#define ARQUIVO_SAIDA "saida.dot"

AST *ast_new(VL *label)
{
  AST *ret = NULL;
  ret = calloc(1, sizeof(AST));
  if (ret != NULL){
    ret->label = label;
    ret->number_of_children = 0;
    ret->children = NULL;
  }
  return ret;
}

void ast_add_child(AST *tree, AST *child)
{
  if (tree != NULL && child != NULL){
    tree->number_of_children++;
    tree->children = realloc(tree->children, tree->number_of_children * sizeof(AST*));
    tree->children[tree->number_of_children-1] = child;
  }else{
    printf("Erro: %s recebeu parâmetro tree = %p / %p.\n", __FUNCTION__, tree, child);
  }
}
