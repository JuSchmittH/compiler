#include "stack.h"

STACK *stack_new(TABLE *table)
{
    STACK* newStack = calloc(1, sizeof(STACK));
    newStack->table = (TABLE*) malloc(sizeof(TABLE));
    newStack->table = table;
    newStack->next = NULL;
    return newStack;
}

int isEmpty(STACK* root)
{
    return root == NULL;
}

void push(STACK** stack, TABLE *table)
{
    STACK* newStack = stack_new(table);
    newStack->next = *stack;
    *stack = newStack;
}
  
void pop(STACK** stack)
{
    if (!isEmpty(*stack))
        *stack = (*stack)->next; 
}

TABLE *peek_first(STACK *stack)
{
    STACK *temp = stack;
    TABLE *table;

    while (!isEmpty(temp)) {
        printf("while\n\n");
        table = peek(temp);
        temp = temp->next;
    }

    return table;
}
  
TABLE *peek(STACK* stack)
{
    //TODO add validation for whe stack is empty
    return stack->table;
}

void free_stack(STACK** stack)
{
    while (!isEmpty(*stack)) {
        STACK* temp = *stack;
        pop(stack);
        free(temp);
    }
}
