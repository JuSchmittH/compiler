#ifndef TABLE_HEADER
#define TABLE_HEADER
#define TABLE_SIZE 100 //TODO remove this once we discover how to do it without setting size

typedef struct table_content
{
    int key;
    int nature;    
    int type;
    int value;
} CONTENT;

typedef struct table_node
{
    CONTENT** rows;
} TABLE;

TABLE *table_new();

void table_insert(TABLE* table);

int table_find(CONTENT* content);

#endif