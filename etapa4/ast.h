//Trabalho de Compiladores 2023/1 - Grupo G - Luma e Juliana
#include "vl.h"
#ifndef AST_HEADER
#define AST_HEADER

//TODO: define types for ast nodes, check how to initiate this
enum type{notdefined, inteiro, pontoflutuante, booleano};

typedef struct ast_node {
  VL *label;
  //enum type node_type;
  int number_of_children;
  struct ast_node **children;
} AST;

AST *ast_new(VL *label);

void ast_add_child(AST *tree, AST *child);

#endif //AST_HEADER
