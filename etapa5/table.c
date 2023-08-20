#include "table.h"

TABLE *table_new()
{
    TABLE* table = (TABLE*) malloc(sizeof(TABLE));
    //TODO remove TABLE_SIZE once we discover how to do it without setting size
    table->rows = (CONTENT**) calloc(TABLE_SIZE, sizeof(CONTENT*));
    table->count = 0;

    for (int i = 0; i < TABLE_SIZE; i++)
        table->rows[i] = NULL;

    table->next = NULL;

    return table;
}

TABLE *table_add(TABLE *table)
{
    TABLE* newTable = table_new();
    newTable->next = table;
    return newTable;
}

CONTENT *content_new(VL *item, char* ref, enum nature nature, int key, int type){
    CONTENT *ret = NULL;
    ret = calloc(1, sizeof(CONTENT));
    if (ret != NULL){
        ret->key = key;
        ret->nature = nature;
        ret->type = type;
        ret->value = item;
        ret->displacement = "0";
        ret->ref = ref;
    }
    return ret;
}

void table_insert(TABLE* table, CONTENT* content, int index)
{
    CONTENT* newContent = table->rows[index];
    //TODO aqui adicionar o displace

    if (newContent == NULL)
    {
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
    int response = 0;
    if (table->count > 0) {
        for (int i = 0; i < table->count; i++) {
            CONTENT* tableContent = table->rows[i];
            if (strcmp(tableContent->value->token_value, content->value->token_value) == 0 && 
                tableContent->type == content->type)
            {
                if (tableContent->nature == content->nature)
                {
                    return 1;
                }

                response = tableContent->nature;
            }
        }
    }

    return response;
}

CONTENT* table_find_without_type(TABLE* table, CONTENT* content)
{ 
    int response = -1;
    if (table->count > 0) {
        for (int i = 0; i < table->count; i++) {
            CONTENT* tableContent = table->rows[i];
            if (strcmp(tableContent->value->token_value, content->value->token_value) == 0)
            {
                return tableContent;
            }
        }
    }
    return NULL;
}
