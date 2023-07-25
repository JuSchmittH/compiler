
#include "vl.h"

#ifndef TABLE_HEADER
#define TABLE_HEADER
#define TABLE_SIZE 100 //TODO remove this once we discover how to do it without setting size

typedef struct table_content
{
    int key;
    int nature;    
    int type;
    VL* value;
} CONTENT;

typedef struct table_node
{
    CONTENT** rows;
    int count;
} TABLE;

TABLE *table_new();

CONTENT *content_new(VL *item, int type);

void table_insert(TABLE* table, VL* item, int type);

int table_hash(int key);

int table_find(TABLE* table, CONTENT* content);

#endif