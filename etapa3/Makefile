#Trabalho de Compiladores 2023/1 - Grupo G - Luma e Juliana

etapa3: parser.tab.o main.o ast.o lex.yy.o 
	gcc -o etapa3 main.o ast.o lex.yy.o parser.tab.o

main.o: main.c
	gcc -c main.c

ast.o: ast.c
	gcc -c ast.c

lex.yy.o: lex.yy.c
	gcc -c lex.yy.c

parser.tab.o: parser.tab.c
	gcc -c parser.tab.c

lex.yy.c: scanner.l
	flex --yylineno --nomain scanner.l

parser.tab.c: parser.y
	bison -d parser.y

clean:
	rm lex.yy.c parser.tab.c *.o etapa3
