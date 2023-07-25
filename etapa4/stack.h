#ifndef STACK_HEADER
#define STACK_HEADER
#include "table.h"

typedef struct stack_node {
    TABLE *table;
    struct stack_node* next;
}STACK;

STACK *stack_new(TABLE *table);

int isEmpty(STACK* root);

void push(STACK** stack, TABLE *table);
  
void pop(STACK** stack);
  
TABLE *peek(STACK* stack);

#endif