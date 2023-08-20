#include "iloc.h"

ILOC_OP *iloc_op_new(char* operation, char* register1, char* register2, char* register3, enum op_type type)
{
    char *ILOC;
	strcpy(ILOC, operation);

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
	strcpy(cmd->operation, ILOC);

	return cmd;
}
