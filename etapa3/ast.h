#ifndef _ARVORE_H_
#define _ARVORE_H_

typedef struct asd_node {
  char *label;
  int number_of_children;
  struct asd_tree **children;
} asd_node_t;

/*
 * Função asd_new, cria um nó sem filhos com o label informado.
 */
asd_node_t *asd_new(const char *label);

/*
 * Função asd_tree, libera recursivamente o nó e seus filhos.
 */
void asd_free(asd_node_t *tree);

/*
 * Função asd_add_child, adiciona child como filho de tree.
 */
void asd_add_child(asd_node_t *tree, asd_node_t *child);

/*
 * Função asd_print, imprime recursivamente a árvore.
 */
void asd_print(asd_node_t *tree);

/*
 * Função asd_print_graphviz, idem, em formato DOT
 */
void asd_print_graphviz (asd_node_t *tree);
#endif //_ARVORE_H_
