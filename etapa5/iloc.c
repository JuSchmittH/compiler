#include "iloc.h"

int labelCount = 0;
int tempoCount = 0;

ILOC_OP *iloc_op_new(char* operation, char* register1, char* register2, char* register3, enum op_type type)
{
    char *ILOC;
	ILOC = strdup(operation);

    // if(type == left) {
	// 	strcat(ILOC, " ");
	// 	strcat(ILOC, register1);
	// 	strcat(ILOC, ", ");
	// 	strcat(ILOC, register2);
	// 	strcat(ILOC, " => ");
	// 	strcat(ILOC, register3);
	// }

	//else if(type == right) {
	if(type == right) {
		strcat(ILOC, " ");
		strcat(ILOC, register1);
		strcat(ILOC, "  => ");
		strcat(ILOC, register2);
		if(register3 != NULL) {
			strcat(ILOC, ", ");
			strcat(ILOC, register3);
		}
	}

	// else if(type == control) {
	// 	strcat(ILOC, " ");
	// 	if(register1 != NULL) {
	// 		strcat(ILOC, register1);
	// 		strcat(ILOC, ", ");
	// 	}
	// 	if(register2 != NULL) {
	// 		strcat(ILOC, register2);
	// 	}
	// 	strcat(ILOC, "  -> ");
	// 	strcat(ILOC, " ");
	// 	strcat(ILOC, register3);
	// }

	// else if(type == cmp) {
	// 	strcat(ILOC, " ");
	// 	strcat(ILOC, register1);
	// 	strcat(ILOC, "  -> ");
	// 	strcat(ILOC, register2);
	// 	strcat(ILOC, ", ");
	// 	strcat(ILOC, register3);
	// }

	// else if(type == jump) {
	// 	strcat(ILOC, " -> ");
	// 	strcat(ILOC, register1);
	//}

	ILOC_OP* cmd = (ILOC_OP*)malloc(sizeof(ILOC_OP));
	cmd->operation = strdup(ILOC);

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
