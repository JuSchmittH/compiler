#include "semantic.h"

STACK *global_scope_new()
{
    return stack_new(table_new());
}

void global_scope_close(STACK **stack)
{
    free_stack(stack);
}

void scope_new(STACK **stack)
{
    push(stack,table_new());
}

void scope_close(STACK **stack)
{
    pop(stack);
}

void validate_declaration(STACK *stack, VL* item, enum type type, enum nature nature)
{
    TABLE* table = peek(stack);

    int index = table_hash(table->count);

    CONTENT* newContent = content_new(item, nature, index, type);
    printf("chegou no if\n\n");
    if (table_find(table, newContent) == 1) {
        printf("ERR_DECLARED: %s on line %d already declarred.\n", item->token_value, item->line_number);
        exit(ERR_DECLARED);
    }

    table_insert(table, newContent, index);    
}

void validate_undeclared(STACK *stack, VL* item, enum type type, enum nature nature)
{
    TABLE *table = peek(stack);
    int key = table->count + 1;
    int index = table_hash(key);

    CONTENT* content = content_new(item, nature, index, type);

    while (!isEmpty(stack)) {
        switch(table_find(table, content)) {
            case 0: printf("ERR_UNDECLARED: %s on line %d undeclared.\n", content->value->token_value, content->value->line_number);
                    exit(ERR_UNDECLARED);
                    break;
            case 3: printf("ERR_VARIABLE: %s on line %d already declarred but only as a variable.\n", content->value->token_value, content->value->line_number);
                    exit(ERR_VARIABLE);
                    break;
            case 4: printf("ERR_FUNCTION: %s on line %d already declarred but only as a function.\n", content->value->token_value, content->value->line_number);
                    exit(ERR_FUNCTION);
                    break;
            default: table = peek(stack->next);
                     break;
        }
    }
}
