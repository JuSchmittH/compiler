#include "table.h"

TABLE *table_new()
{
    TABLE* table = (TABLE*) malloc(sizeof(TABLE));
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

void table_insert(TABLE* table, CONTENT* content, int index)
{
    CONTENT* newContent = table->rows[index];

    if (newContent == NULL)
    {
        table->rows[index] = content;
        table->count++;
    }
}

int table_hash(int key)
{
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

int table_find_without_type(TABLE* table, CONTENT* content)
{ 
    int response = -1;
    if (table->count > 0) {
        for (int i = 0; i < table->count; i++) {
            CONTENT* tableContent = table->rows[i];
            if (strcmp(tableContent->value->token_value, content->value->token_value) == 0)
            {
                if (tableContent->nature == content->nature)
                {
                    response = tableContent->type;
                } else {
                    response = tableContent->nature;
                }
            }
        }
    }
    return response;
}
