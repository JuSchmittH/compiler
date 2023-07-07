//Trabalho de Compilados 2023/1 - Grupo G - Luma e Juliana
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "ast.h"
#define ARQUIVO_SAIDA "saida.dot"

AST *ast_new(const char *label)
{
  AST *ret = NULL;
  ret = calloc(1, sizeof(AST));
  if (ret != NULL){
    ret->label = strdup(label);
    ret->number_of_children = 0;
    ret->children = NULL;
  }
  return ret;
}

void ast_free(AST *tree)
{
  if (tree != NULL){
    int i;
    for (i = 0; i < tree->number_of_children; i++){
      ast_free(tree->children[i]);
    }
    free(tree->children);
    free(tree->label);
    free(tree);
  }else{
    printf("Erro: %s recebeu parâmetro tree = %p.\n", __FUNCTION__, tree);
  }
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

static void _ast_print (FILE *foutput, AST *tree, int profundidade)
{
  int i;
  if (tree != NULL){
    fprintf(foutput, "%d%*s: Nó '%s' tem %d filhos:\n", profundidade, profundidade*2, "", tree->label, tree->number_of_children);
    for (i = 0; i < tree->number_of_children; i++){
      _ast_print(foutput, tree->children[i], profundidade+1);
    }
  }else{
    printf("Erro: %s recebeu parâmetro tree = %p.\n", __FUNCTION__, tree);
  }
}

void ast_print(AST *tree)
{
  FILE *foutput = stderr;
  if (tree != NULL){
    _ast_print(foutput, tree, 0);
  }else{
    printf("Erro: %s recebeu parâmetro tree = %p.\n", __FUNCTION__, tree);
  }
}

static void _ast_print_graphviz (FILE *foutput, AST *tree)
{
  int i;
  if (tree != NULL){
    fprintf(foutput, "  %ld [ label=\"%s\" ];\n", (long)tree, tree->label);
    for (i = 0; i < tree->number_of_children; i++){
      fprintf(foutput, "  %ld -> %ld;\n", (long)tree, (long)tree->children[i]);
      _ast_print_graphviz(foutput, tree->children[i]);
    }
  }else{
    printf("Erro: %s recebeu parâmetro tree = %p.\n", __FUNCTION__, tree);
  }
}

void ast_print_graphviz(AST *tree)
{
  FILE *foutput = fopen(ARQUIVO_SAIDA, "w+");
  if(foutput == NULL){
    printf("Erro: %s não pude abrir o arquivo [%s] para escrita.\n", __FUNCTION__, ARQUIVO_SAIDA);
  }
  if (tree != NULL){
    fprintf(foutput, "digraph grafo {\n");
    _ast_print_graphviz(foutput, tree);
    fprintf(foutput, "}\n");
    fclose(foutput);
  }else{
    printf("Erro: %s recebeu parâmetro tree = %p.\n", __FUNCTION__, tree);
  }
}
