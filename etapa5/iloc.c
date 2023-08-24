#include "iloc.h"

int labelCount = 0;
int tempoCount = 0;

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
	cmd->operation = strdup(iloc);

	return cmd;
}

char* get_label(){
  char* label;

	labelCount++;
	snprintf(label, 10, "%s%d", "L", labelCount);
	
	return label;
}

char* get_temp(){
  char* temp;

	labelCount++;
	snprintf(temp, 10, "%s%d", "r", labelCount);

	return temp;
}

char* concatCode(char* code1, char* code2) {
	char* code_result;
	code_result = strdup(code1);
	strcat(code_result, "\n");
	strcat(code_result, code2);
	return code_result;
}
