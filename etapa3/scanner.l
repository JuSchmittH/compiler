%{
    //Trabalho de Compilados 2023/1 - Grupo G - Luma e Juliana
    #define SPECIAL_CHAR        1
    #define RESERVED_WORD       2
    #define COMPOSED_OPERATOR   3
    #define IDENTIFIER          4
    #define LITERAL             5

    #include "parser.tab.h"
%}

%x ML_COMMENT
%option yylineno
%option noyywrap

%%

"int"					{ return TK_PR_INT; }
"float"					{ return TK_PR_FLOAT; }
"bool"					{ return TK_PR_BOOL; }
"if"					{ return TK_PR_IF; }
"else"					{ return TK_PR_ELSE; }
"while"					{ return TK_PR_WHILE; }
"return"				{ return TK_PR_RETURN; }

[-!*/%+<>\{\}\(\)=,;]   { return yytext[0]; }

"<="            		{ return TK_OC_LE; }
">="            		{ return TK_OC_GE; }
"=="            		{ return TK_OC_EQ; }
"!="            		{ return TK_OC_NE; }
"&"						{ return TK_OC_AND; }
"|"						{ return TK_OC_OR; }
"->"					{ return TK_OC_MAP; }

"//".*                  { }

[0-9]+                  { yylval.valor_lexico = vl_new(yylineno, LITERAL, yytext); return TK_LIT_INT; }
[0-9]*\.[0-9]+          { yylval.valor_lexico = vl_new(yylineno, LITERAL, yytext); return TK_LIT_FLOAT; }
"false"                 { yylval.valor_lexico = vl_new(yylineno, LITERAL, yytext); return TK_LIT_FALSE; }
"true"                  { yylval.valor_lexico = vl_new(yylineno, LITERAL, yytext); return TK_LIT_TRUE; }

[a-z_]+					{ yylval.valor_lexico = add_node(yytext); return TK_IDENTIFICADOR; }

" "                     { }
\t                      { }

.						{ return TK_ERRO; }

"/*"			        { BEGIN(ML_COMMENT); }
<ML_COMMENT>"*/"		{ BEGIN(INITIAL); }
<ML_COMMENT>.	        { }
<ML_COMMENT>\n	        { }

\n                      { }                     
%%

int get_line_number(void){
	return yylineno;
}

