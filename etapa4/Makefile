#Trabalho de Compiladores 2023/1 - Grupo G - Luma e Juliana

etapa4: parser.tab.o main.o ast.o vl.o lex.yy.o 
	gcc -o etapa4 main.o ast.o vl.o lex.yy.o parser.tab.o

main.o: main.c
	gcc -c main.c

ast.o: ast.c
	gcc -c ast.c

vl.o: vl.c
	gcc -c vl.c

lex.yy.o: lex.yy.c
	gcc -c lex.yy.c

parser.tab.o: parser.tab.c
	gcc -c parser.tab.c

lex.yy.c: scanner.l
	flex --yylineno --nomain scanner.l

parser.tab.c: parser.y
	bison -d parser.y

clean:
	rm lex.yy.c parser.tab.c *.o etapa4
