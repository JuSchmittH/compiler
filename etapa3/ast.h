//Trabalho de Compiladores 2023/1 - Grupo G - Luma e Juliana
#ifndef AST_HEADER
#define AST_HEADER

typedef struct ast_node {
  char *label;
  int number_of_children;
  struct ast_node **children;
} AST;

//TODO: check if we have all this implemented com funções habituais tais como  remoção e impressão re- cursiva da árvore através de um percurso em profun- didade.

/*
 * Função ast_new, cria um nó sem filhos com o label informado. -> criação de nó
 */
AST *ast_new(const char *label);

/*
 * Função ast_node, libera recursivamente o nó e seus filhos.
 */
//void ast_free(AST *tree);

/*
 * Função ast_add_child, adiciona child como filho de tree. -> alteração 
 */
void ast_add_child(AST *tree, AST *child);

/*
 * Função ast_print, imprime recursivamente a árvore.
 */
//void ast_print(AST *tree);

/*
 * Função ast_print_graphviz, idem, em formato DOT
 */
//void ast_print_graphviz (AST *tree);
#endif //AST_HEADER
