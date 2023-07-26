#include "semantic.h"

STACK *global_scope_new()
{
    return stack_new(table_new());
}

void validate_declaration(STACK *stack, VL* item, enum type type, enum nature nature)
{

    TABLE* table = peek(stack);

    int key = table->count + 1;
    int index = table_hash(key);

    CONTENT* newContent = content_new(item, nature, index, type);

    if (!table_find(table, newContent)) {
        table_insert(table, newContent, index);
    }
    else {
        exit(ERR_DECLARED);
        printf("ERR_DECLARED: %s already declarred.\n", item->token_value);
    }
}

void validate_undeclared_vars(STACK* stack, CONTENT* content)
{
    int variableFound = 0;
    TABLE *table = peek(stack);

    while (variableFound) {
        if (table_find(table, content)) {
            variableFound = 1;
            exit(ERR_UNDECLARED);
            printf("ERR_UNDECLARED: %s already declarred.\n", content->value->token_value);
        }
        table = peek(stack->next);
    }
}