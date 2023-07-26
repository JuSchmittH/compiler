#ifndef SEMANTIC_HEADER
#define SEMANTIC_HEADER

#include <stdio.h>
#include <stdlib.h>
#include "stack.h"
#include "table.h"

#define ERR_UNDECLARED  10 //2.2
#define ERR_DECLARED    11 //2.2
#define ERR_VARIABLE    20 //2.3
#define ERR_FUNCTION    21 //2.3

STACK *global_scope_new();

void validate_declared_vars(TABLE* table, VL* item, int type);

void validate_undeclared_vars(STACK* stack, CONTENT* content);

#endif