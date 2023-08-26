
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "vl.h"

#ifndef TABLE_HEADER
#define TABLE_HEADER
#define TABLE_SIZE    100 //TODO remove this once we discover how to do it without setting size
#define INT_TAM       4

enum nature {
  literal = 5, 
  identificador = 6,
  funcao = 7
};

typedef struct table_content
{
    int key;
    int location;
    enum nature nature;    
    int type;
    char* displacement;
    char* ref;
    VL* value;
} CONTENT;

typedef struct table_node
{
    CONTENT** rows;
    int count;
    struct table_node* next; //Link between tables can be helpfull to the futures steps acordding to the professor
} TABLE;

TABLE *table_new();

TABLE *table_add(TABLE *table);

CONTENT *content_new(VL *item, char* ref, enum nature nature, int key, int type);

void table_insert(TABLE* table, CONTENT* content, int index);

int table_hash(int key);

int table_find(TABLE* table, CONTENT* content);

CONTENT* table_find_without_type(TABLE* table, CONTENT* content);

#endif