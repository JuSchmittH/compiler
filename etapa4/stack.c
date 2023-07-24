#include "stack.h"
#include "table.h"

//TODO: maybe move this to another file
#define ERR_UNDECLARED  10 //2.2
#define ERR_DECLARED    11 //2.2
#define ERR_VARIABLE    20 //2.3
#define ERR_FUNCTION    21 //2.3

STACK *stack_new(TABLE table)
{
    STACK* newStack = calloc(1, sizeof(STACK));;
    newStack->table = table;
    newStack->next = NULL;
    return newStack;
}

void push(STACK** stack, TABLE table)
{
    STACK* newStack = stack_new(table);
    newStack->next = *stack;
    *stack = newStack;
}
  
void pop(STACK** stack) //Did not put the free because I remember something about we needing thar data on the next steps
{
    if (isEmpty(*stack))
        return INT_MIN;
    *stack = (*stack)->next; 
}
  
TABLE peek(STACK* stack)
{
    //TODO add validation for whe stack is empty
    return stack->table;
}

//TODO: maybe move this to another file
int validate_undeclared_vars(TABLE* table, CONTENT* content){
    if (table_find(table, newItem)) {
        //TODO: add exit
        printf("ERR_UNDECLARED: %s already declarred.\n", item->token_value);
    }
}