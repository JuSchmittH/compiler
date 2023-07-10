//Trabalho de Compiladores 2023/1 - Grupo G - Luma e Juliana
#ifndef AST_HEADER
#define AST_HEADER

typedef struct ast_node {
  char *label;
  int number_of_children;
  struct ast_node **children;
} AST;

AST *ast_new(const char *label);

void ast_add_child(AST *tree, AST *child);

#endif //AST_HEADER
