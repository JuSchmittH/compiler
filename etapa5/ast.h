//Trabalho de Compiladores 2023/1 - Grupo G - Luma e Juliana
#ifndef AST_HEADER
#define AST_HEADER

#include <string.h>
#include <stdlib.h>
#include<stdio.h>
#include "vl.h"
#include "iloc.h"

enum type {
  notdefined, 
  inteiro, 
  pontoflutuante, 
  booleano,
  unknown
};

typedef struct ast_node {
  VL *item;
  ILOC_OP *code;
  char *temp;
  enum type node_type;
  int number_of_children;
  struct ast_node **children;
} AST;

AST *ast_new(enum type type, VL *item);

void ast_add_child(AST *tree, AST *child);

void print_iloc(AST *node);

char* get_label();

void get_temp(AST* ast);

void set_code(AST* node, ILOC_OP* originalNode);

#endif //AST_HEADER
