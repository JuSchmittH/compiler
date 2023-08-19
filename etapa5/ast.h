//Trabalho de Compiladores 2023/1 - Grupo G - Luma e Juliana
#ifndef AST_HEADER
#define AST_HEADER

#include<stdio.h>
#include "vl.h"
#include "iloc.h"

enum type {
  notdefined, 
  inteiro, 
  pontoflutuante, 
  booleano
};

typedef struct ast_node {
  VL *item;
  ILOC_Op code;
  char *temp;
  enum type node_type;
  int number_of_children;
  struct ast_node **children;
} AST;

AST *ast_new(enum type type, VL *item);

void ast_add_child(AST *tree, AST *child);

enum type getType(AST *node);

void print_ast_node(AST *node);

#endif //AST_HEADER