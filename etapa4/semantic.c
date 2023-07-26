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
        printf("inseriu\n\n");
    }
    else {
        printf("ERR_DECLARED: %s on line %d already declarred.\n", item->token_value, item->line_number);
        exit(ERR_DECLARED);
    }
        printf("chegou no final\n\n");
}

void validate_undeclared_vars(STACK* stack, CONTENT* content)
{
    int variableFound = 0;
    TABLE *table = peek(stack);

    while (variableFound) {
        if (table_find(table, content)) {
            variableFound = 1;
            printf("ERR_UNDECLARED: %s on line %d already declarred.\n", content->value->token_value, content->value->line_number);
            exit(ERR_UNDECLARED);
        }
        table = peek(stack->next);
    }
}