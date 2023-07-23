#include "stack.h"
#include "table.h"

STACK *stack_new(TABLE table) //TODO check where do I store this stack
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
