//Trabalho de Compiladores 2023/1 - Grupo G - Luma e Juliana
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "ast.h"
#include "vl.h"
#define ARQUIVO_SAIDA "saida.dot"

AST *ast_new(enum type type, VL *item)
{
  AST *ret = NULL;
  ret = calloc(1, sizeof(AST));
  ILOC_OP* cmd = (ILOC_OP*)malloc(sizeof(ILOC_OP));

  if (ret != NULL){
    ret->item = item;
    ret->node_type = type;
    ret->number_of_children = 0;
    ret->children = NULL;
    ret->code = cmd;
    ret->temp = "";
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

void set_code(AST* node, char* originalNode)
{
  if( node->code && originalNode ) {
    node->code->operation = strdup(originalNode);
  }
}

void print_iloc(AST *node)
{
  if (node->code) {
    printf("%s\n", node->code->operation);
  }
}