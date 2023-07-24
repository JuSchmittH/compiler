#include "table.h"
#include "vl.h"

TABLE *table_new()
{
    TABLE* table = (TABLE*) malloc(sizeof(TABLE));
    //TODO remove TABLE_SIZE once we discover how to do it without setting size
    table->items = (CONTENT**) calloc(TABLE_SIZE, sizeof(CONTENT*));
    table->count = 0;

    for (int i = 0; i < TABLE_SIZE; i++)
        table->rows[i] = NULL;

    return table;
}

//TODO check if VL has everything we need maybe use AST
CONTENT *content_new(VL *item, int key, int type){
    CONTENT *ret = NULL;
    ret = calloc(1, sizeof(CONTENT));
    if (ret != NULL){
        ret->key = key;
        ret->nature = item->token_value; 
        ret->type = type;
        ret->value = strdup(item->token_value);;
    }
    return ret;
}

//TODO check if VL has everything we need maybe use AST
void table_insert(TABLE* table, VL* item, int type)
{
    int key = table->count + 1;

    CONTENT* newItem = content_new(item, key, type);

    if (!table_find(table, newItem)) {
        CONTENT* current_item = table->content[key];

        if (current_item == NULL)
        {
            //TODO here we would check the limit of the table but since we wantnot to have a limit see how to implement this

            table->items[key] = newItem;
            table->count++;
        }
    }
    else {
        //TODO: check if this is how it suppose to throw the error
        printf("ERR_DECLARED: %s already declarred.\n", item->token_value);
    }
}

int table_find(TABLE* table, CONTENT* content)
{
    //TODO finish implemtation here
    return 0;
}