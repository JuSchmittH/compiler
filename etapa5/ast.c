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
  if (ret != NULL){
    ret->item = item;
    ret->node_type = type;
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

const char* types[] = {"notdefined", "inteiro", "pontoflutuante", "booleano", "unknown"};

enum type getType(AST *node) {
  print_ast_node(node);
  return node->node_type;
}

void print_ast_node(AST *node) {
  printf("++++++++++++++++++++++++++\n");
  printf("Print node: \n");
  printVL(node->item);
  printf("Type: %s\n", types[node->node_type]);
  printf("Children: %d\n", node->number_of_children);
  printf("++++++++++++++++++++++++++\n");
}