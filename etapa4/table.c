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
    return table;
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
        //TODO here we would check the limit of the table but since we wantnot to have a limit see how to implement this
        table->rows[index] = content;
        table->count++;
        //TODO REMOVE printf("chegou aqui - insert\n\n");
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
        //TODO REMOVE printf("chegou aqui - find\n\n");
        for (int i = 0; i < table->count; i++) {
            CONTENT* tableContent = table->rows[i];
            //TODO REMOVE rintf("count%d - %s\n\n", i, tableContent->value->token_value);
            //TODO: if we add a hash we can compare by key
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
        //TODO REMOVE printf("chegou aqui - find\n\n");
        for (int i = 0; i < table->count; i++) {
            CONTENT* tableContent = table->rows[i];
            //TODO REMOVE rintf("count%d - %s\n\n", i, tableContent->value->token_value);
            //TODO: if we add a hash we can compare by key
            if (strcmp(tableContent->value->token_value, content->value->token_value) == 0)
            {
                //TODO REMOVE printf("table value: %s\n", tableContent->value->token_value);
                //TODO REMOVE printf("content value: %s\n", content->value->token_value);
                //TODO REMOVE printf("table nature: %d\n", tableContent->nature);
                //TODO REMOVE printf("content nature: %d\n\n", content->nature);
                if (tableContent->nature == content->nature)
                {
                    response = tableContent->type;
                    //TODO REMOVE printf("entrou no nature: %d\n", response);
                } else {
                    response = tableContent->nature;
                }
            }
            //TODO REMOVE printf("for: %d\n", response);
        }
    }
    //TODO REMOVE printf("finde: %d\n", response);
    return response;
}
