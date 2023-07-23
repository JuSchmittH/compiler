#include "table.h"

//TODO finish implemtation here

TABLE *table_new()
{
    TABLE* table = (TABLE*) malloc(sizeof(TABLE));
    //TODO remove TABLE_SIZE once we discover how to do it without setting size
    table->items = (CONTENT**) calloc(TABLE_SIZE, sizeof(CONTENT*));

    for (int i = 0; i < TABLE_SIZE; i++)
        table->rows[i] = NULL;

    return table;
}

void table_insert(TABLE* table)
{

}

int table_find(CONTENT* content)
{
    return 0;
}