#include "semantic.h"

//TODO: move the ERR_DECLARED to here

void validate_undeclared_vars(STACK* stack, CONTENT* content){
    int variableFound = 0;
    TABLE *table = peek(stack);

    while (variableFound) {
        if (table_find(table, newItem)) {
            variableFound = 1;
            //TODO: add exit
            printf("ERR_UNDECLARED: %s already declarred.\n", item->token_value);
        }
        table = peek(stack->next);
    }
}