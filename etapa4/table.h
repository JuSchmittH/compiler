#ifndef TABLE_HEADER
#define TABLE_HEADER

typedef struct table_content
{
    int nature;    
    int type;
    int value;
} CONTENT;

typedef struct table_node
{
    int key;
    CONTENT content;
    struct table_node *next;
} TABLE;

hashInsert();

#endif