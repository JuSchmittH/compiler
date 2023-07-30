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
    //TODO REMOVE printf("escopo novo\n\n");
    push(stack,table_add(peek(*stack)));
}

void scope_close(STACK **stack)
{
    //TODO REMOVE printf("fecha escopo\n\n");
    pop(stack);
}

void validate_declaration(STACK *stack, VL* item, enum type type, enum nature nature)
{
    TABLE* table;

    if(nature == funcao) {
        table = peek_first(stack);
        //TODO REMOVE printf("funcao\n\n");
    }
    else {
        table = peek(stack);
    }

    int index = table_hash(table->count);

    CONTENT* newContent = content_new(item, nature, index, type);
    //TODO REMOVE printf("chegou aqui %s on line %d \n\n", item->token_value, item->line_number);
    if (table_find(table, newContent) == 1) {
        printf("ERR_DECLARED: %s on line %d already declared.\n", item->token_value, item->line_number);
        exit(ERR_DECLARED);
    }

    table_insert(table, newContent, index);    
}

enum type validate_undeclared(STACK *stack, VL* item, enum nature nature)
{
    TABLE *table = peek(stack);
    int index = table_hash(table->count);

    CONTENT* content = content_new(item, nature, index, unknown);

    while (stack) {
        switch(table_find_without_type(table, content)) {
            case 0: return notdefined;
                    break;
            case 1: return inteiro;
                    break;
            case 2: return pontoflutuante;
                    break;
            case 3: return booleano;
                    break;
            case 6: printf("ERR_VARIABLE: %s on line %d already declared but only as a variable.\n", content->value->token_value, content->value->line_number);
                    exit(ERR_VARIABLE);
                    break;
            case 7: printf("ERR_FUNCTION: %s on line %d already declared but only as a function.\n", content->value->token_value, content->value->line_number);
                    exit(ERR_FUNCTION);
                    break;
            default: if (stack-> next != NULL) {
                        stack = stack->next;
                        table = peek(stack);
                    } else {
                        stack = NULL;
                    }
                    break;
        }
    }

    printf("ERR_UNDECLARED: %s on line %d undeclared.\n", content->value->token_value, content->value->line_number);
    exit(ERR_UNDECLARED);
    return unknown;
}
