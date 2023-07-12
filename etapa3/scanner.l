%{
    //Trabalho de Compiladores 2023/1 - Grupo G - Luma e Juliana
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

"int"					{ yylval.valor_lexico = vl_new(yylineno, RESERVED_WORD, "int"); return TK_PR_INT; }
"float"					{ yylval.valor_lexico = vl_new(yylineno, RESERVED_WORD, "float"); return TK_PR_FLOAT; }
"bool"					{ yylval.valor_lexico = vl_new(yylineno, RESERVED_WORD, "bool"); return TK_PR_BOOL; }
"if"					{ yylval.valor_lexico = vl_new(yylineno, RESERVED_WORD, "if"); return TK_PR_IF; }
"else"					{ yylval.valor_lexico = vl_new(yylineno, RESERVED_WORD, "else"); return TK_PR_ELSE; }
"while"					{ yylval.valor_lexico = vl_new(yylineno, RESERVED_WORD, "while"); return TK_PR_WHILE; }
"return"				{ yylval.valor_lexico = vl_new(yylineno, RESERVED_WORD, "return"); return TK_PR_RETURN; }

[-!*/%+<>\{\}\(\)=,;]   { yylval.valor_lexico = vl_new(yylineno, SPECIAL_CHAR, strdup(yytext)); return yytext[0]; }

"<="            		{ yylval.valor_lexico = vl_new(yylineno, COMPOSED_OPERATOR, "<="); return TK_OC_LE; }
">="            		{ yylval.valor_lexico = vl_new(yylineno, COMPOSED_OPERATOR, ">="); return TK_OC_GE; }
"=="            		{ yylval.valor_lexico = vl_new(yylineno, COMPOSED_OPERATOR, "=="); return TK_OC_EQ; }
"!="            		{ yylval.valor_lexico = vl_new(yylineno, COMPOSED_OPERATOR, "!="); return TK_OC_NE; }
"&"						{ yylval.valor_lexico = vl_new(yylineno, COMPOSED_OPERATOR, "&"); return TK_OC_AND; }
"|"						{ yylval.valor_lexico = vl_new(yylineno, COMPOSED_OPERATOR, "|"); return TK_OC_OR; }
"->"					{ yylval.valor_lexico = vl_new(yylineno, COMPOSED_OPERATOR, "->"); return TK_OC_MAP; }

"//".*                  { }

[0-9]+                  { yylval.valor_lexico = vl_new(yylineno, LITERAL, strdup(yytext)); return TK_LIT_INT; }
[0-9]*\.[0-9]+          { yylval.valor_lexico = vl_new(yylineno, LITERAL, strdup(yytext)); return TK_LIT_FLOAT; }
"false"                 { yylval.valor_lexico = vl_new(yylineno, LITERAL, strdup(yytext)); return TK_LIT_FALSE; }
"true"                  { yylval.valor_lexico = vl_new(yylineno, LITERAL, strdup(yytext)); return TK_LIT_TRUE; }

[a-z_]+					{ yylval.valor_lexico = vl_new(yylineno, IDENTIFIER, strdup(yytext)); return TK_IDENTIFICADOR; }

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

