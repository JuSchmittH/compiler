#Trabalho de Compilados 2023/1 - Grupo G - Luma e Juliana
#TODO slide 7/13 da aula do lab

etapa2: y.tab.c main.o lex.yy.o
	gcc -o etapa2 main.o lex.yy.o

main.o: main.c
	gcc -c main.c

lex.yy.o: lex.yy.c
	gcc -c lex.yy.c

lex.yy.c: scanner.l
	flex --yylineno --nomain scanner.l

y.tab.c: parser.y
	yacc -d parser.y

clean:
	rm lex.yy.c y.tab.c *.o etapa2
