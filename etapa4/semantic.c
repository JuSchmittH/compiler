#include "semantic.h"

// STACK *global_scope_new(){
//     return stack_new(table_new());
// }

void validate_declared_vars(TABLE* table, VL* item, int type){
    if (!table_find(table, newItem)) {
        table_insert(table, item, type);
    }
    else {
        exit(ERR_DECLARED);
        printf("ERR_DECLARED: %s already declarred.\n", item->token_value);
    }
}

void validate_undeclared_vars(STACK* stack, CONTENT* content){
    int variableFound = 0;
    TABLE *table = peek(stack);

    while (variableFound) {
        if (table_find(table, newItem)) {
            variableFound = 1;
            exit(ERR_UNDECLARED);
            printf("ERR_UNDECLARED: %s already declarred.\n", item->token_value);
        }
        table = peek(stack->next);
    }
}