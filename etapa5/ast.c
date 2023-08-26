//Trabalho de Compiladores 2023/1 - Grupo G - Luma e Juliana

#include "ast.h"
#define ARQUIVO_SAIDA "saida.dot"

int labelCount = 0;
int tempCount = 0;

AST *ast_new(enum type type, VL *item)
{
  AST *ret = NULL;
  ret = calloc(1, sizeof(AST));
  ILOC_OP* cmd = (ILOC_OP*)malloc(sizeof(ILOC_OP));
  strcpy(cmd->operation, "nop");

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

void print_iloc(AST *node)
{
  if (node->code) {
    printf("%s\n", node->code->operation);
  }
}

char* get_label(){
  char label[10];

	labelCount++;
	snprintf(label, 10, "%s%d", "L", labelCount);
	
	return label;
}

void set_code(AST* node, ILOC_OP* originalNode)
{
  if( node->code && originalNode ) {
    //node->code->operation = (char*)realloc(node->code->operation, sizeof(char) * strlen(originalNode));
    strcpy(node->code->operation, originalNode->operation);
  }
}

void get_temp(AST* ast){
	tempCount++;
	char temp[10];

	snprintf(temp, 10, "%s%d", "r", tempCount);
	ast->temp = strdup(temp);
}