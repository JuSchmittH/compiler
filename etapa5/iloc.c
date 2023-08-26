#include "iloc.h"
#include "ast.h"
#define _OPEN_SYS_ITOA_EXT
#include <stdio.h>
#include <stdlib.h>

int labelCount = 0;
int tempCount = 0;

ILOC_OP *iloc_op_new(char* operation, char* register1, char* register2, char* register3, enum op_type type)
{
    char *iloc;
	iloc = strdup(operation);

	switch(type) {
		case left: 
			strcat(iloc, " ");
			strcat(iloc, register1);
			strcat(iloc, ", ");
			strcat(iloc, register2);
			strcat(iloc, " => ");
			strcat(iloc, register3);
			break;
		case right: 
			strcat(iloc, " ");
			strcat(iloc, register1);
			strcat(iloc, "  => ");
			strcat(iloc, register2);
			if(register3 != NULL) {
				strcat(iloc, ", ");
				strcat(iloc, register3);
			};
			break;
		case cmp:
			strcat(iloc, " ");
			if(register1 != NULL) {
				strcat(iloc, register1);
				strcat(iloc, ", ");
			}
			if(register2 != NULL) {
				strcat(iloc, register2);
			}
			strcat(iloc, "  -> ");
			strcat(iloc, " ");
			strcat(iloc, register3);
			break;
		case cbr: 
			strcat(iloc, " ");
			strcat(iloc, register1);
			strcat(iloc, "  -> ");
			strcat(iloc, register2);
			strcat(iloc, ", ");
			strcat(iloc, register3);
			break;
		case jump:
			strcat(iloc, " -> ");
			strcat(iloc, register1);
			break;
	}

	ILOC_OP* cmd = (ILOC_OP*)malloc(sizeof(ILOC_OP));
	strcpy(cmd->operation, iloc);
	return cmd;
}

char* get_label(){
  char label[10];

	labelCount++;
	snprintf(label, 10, "%s%d", "L", labelCount);
	
	return label;
}

void get_temp(AST* ast){
	tempCount++;
	char temp[10];

	snprintf(temp, 10, "%s%d", "r", tempCount);
	ast->temp = strdup(temp);
}

void concatCode(ILOC_OP* code1, ILOC_OP* code2) {
	strcat(code1->operation, "\n");
	strcat(code1->operation, code2->operation);
}

void concatString(ILOC_OP* code1, char* code2) {
	strcat(code1->operation, code2);
}

void concatILOC(ILOC_OP* code1, ILOC_OP*  code2) {
	strcat(code1->operation, code2->operation);
}
