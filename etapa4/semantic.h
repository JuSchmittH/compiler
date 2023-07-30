#ifndef SEMANTIC_HEADER
#define SEMANTIC_HEADER

#include <stdio.h>
#include <stdlib.h>
#include "stack.h"
#include "table.h"
#include "ast.h"

#define ERR_UNDECLARED  10 //2.2
#define ERR_DECLARED    11 //2.2
#define ERR_VARIABLE    20 //2.3
#define ERR_FUNCTION    21 //2.3

STACK *global_scope_new();

void global_scope_close(STACK **stack);

void scope_new(STACK **stack);

void scope_close(STACK **stack);

void validate_declaration(STACK *stack, VL* item, enum type type, enum nature nature);

int validate_undeclared(STACK *stack, VL* item, enum nature nature);

#endif