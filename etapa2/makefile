#Trabalho de Compilados 2023/1 - Grupo G - Luma e Juliana
#TODO slide 7/13 da aula do lab

etapa2: parser.tab.o main.o lex.yy.o
	gcc -o etapa2 main.o lex.yy.o parser.tab.o

main.o: main.c
	gcc -c main.c

lex.yy.o: lex.yy.c
	gcc -c lex.yy.c

parser.tab.o: parser.tab.c
	gcc -c parser.tab.c

lex.yy.c: scanner.l
	flex --yylineno --nomain scanner.l

parser.tab.c: parser.y
	bison -d parser.y

clean:
	rm lex.yy.c parser.tab.c *.o etapa2
