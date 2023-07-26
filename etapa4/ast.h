//Trabalho de Compiladores 2023/1 - Grupo G - Luma e Juliana
#ifndef AST_HEADER
#define AST_HEADER

#include<stdio.h>
#include "vl.h"

//TODO: define types for ast nodes, check how to initiate this
enum type {
  notdefined, 
  inteiro, 
  pontoflutuante, 
  booleano,
  unknown //TODO added this in the places where I dont know what o put it
};

typedef struct ast_node {
  VL *item;
  enum type node_type;
  int number_of_children;
  struct ast_node **children;
} AST;

AST *ast_new(enum type type, VL *item);

void ast_add_child(AST *tree, AST *child);

#endif //AST_HEADER
