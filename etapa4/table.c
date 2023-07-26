#include "table.h"

TABLE *table_new()
{
    TABLE* table = (TABLE*) malloc(sizeof(TABLE));
    //TODO remove TABLE_SIZE once we discover how to do it without setting size
    table->rows = (CONTENT**) calloc(TABLE_SIZE, sizeof(CONTENT*));
    table->count = 0;

    for (int i = 0; i < TABLE_SIZE; i++)
        table->rows[i] = NULL;

    return table;
}

//TODO check if VL has everything we need maybe use AST
CONTENT *content_new(VL *item, enum nature nature, int key, int type){
    CONTENT *ret = NULL;
    ret = calloc(1, sizeof(CONTENT));
    if (ret != NULL){
        ret->key = key;
        ret->nature = nature;
        ret->type = type;
        ret->value = item;
    }
    return ret;
}

//TODO check if VL has everything we need maybe use AST
void table_insert(TABLE* table, CONTENT* content, int index)
{
    CONTENT* newContent = table->rows[index];

        if (newContent == NULL)
        {
            //TODO here we would check the limit of the table but since we wantnot to have a limit see how to implement this

            table->rows[index] = content;
            table->count++;
        }
}

int table_hash(int key)
{
    //TODO finish implemtation here
    return key;
}

int table_find(TABLE* table, CONTENT* content)
{
    for (int i = 0; i <= table->count; i++) {
        CONTENT* tableContent = table->rows[i];
        //TODO: if we add a hash we can compare by key
        if (strcmp(tableContent->value->token_value, content->value->token_value) == 0 && 
            tableContent->type == content->type && tableContent->nature == content->nature)
        {
            return 0;
        }
    }
    return 1;
}
