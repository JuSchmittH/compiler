etapa1: main.o lex.yy.o
	gcc -o etapa1 main.o lex.yy.o

main.o: main.c
	gcc -c main.c

lex.yy.o: lex.yy.c
	gcc -c lex.yy.c

lex.yy.c: scanner.l
	flex --yylineno --nomain scanner.l

clean:
	rm lex.yy.c *.o etapa1
