#Trabalho de Compiladores 2023/1 - Grupo G - Luma e Juliana

etapa5: parser.tab.o main.o iloc.o table.o stack.o semantic.o ast.o vl.o lex.yy.o 
	gcc -o etapa5 main.o iloc.o table.o stack.o semantic.o ast.o vl.o lex.yy.o parser.tab.o

main.o: main.c
	gcc -c -g main.c

iloc.o: iloc.c
	gcc -c -g iloc.c

semantic.o: semantic.c
	gcc -c -g semantic.c

stack.o: stack.c
	gcc -c -g stack.c

table.o: table.c
	gcc -c -g table.c

ast.o: ast.c
	gcc -c -g ast.c

vl.o: vl.c
	gcc -c -g vl.c

lex.yy.o: lex.yy.c
	gcc -c -g lex.yy.c

parser.tab.o: parser.tab.c
	gcc -c -g parser.tab.c

lex.yy.c: scanner.l
	flex --yylineno --nomain scanner.l

parser.tab.c: parser.y
	bison -d parser.y

clean:
	rm lex.yy.c parser.tab.c *.o etapa5
