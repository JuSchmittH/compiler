%{
    //Trabalho de Compilados 2023/1 - Grupo G - Luma e Juliana
    #include <stdio.h>
    int yylex(void);
    extern int yylineno;
    void yyerror (const char *s);
%}

%define parse.error verbose

%token TK_PR_INT
%token TK_PR_FLOAT
%token TK_PR_BOOL
%token TK_PR_IF
%token TK_PR_ELSE
%token TK_PR_WHILE
%token TK_PR_RETURN
%token TK_OC_LE
%token TK_OC_GE
%token TK_OC_EQ
%token TK_OC_NE
%token TK_OC_AND
%token TK_OC_OR
%token TK_OC_MAP
%token TK_IDENTIFICADOR
%token TK_LIT_INT
%token TK_LIT_FLOAT
%token TK_LIT_FALSE
%token TK_LIT_TRUE
%token TK_ERRO

%%

programa: lista | ;

lista: lista elemento | elemento;

elemento: funcao | decl_var_global;

decl_var_global: tipo lista_var_global ';';

lista_var_global: lista_var_global ',' TK_IDENTIFICADOR | TK_IDENTIFICADOR;

funcao: cabecalho corpo;

cabecalho: TK_IDENTIFICADOR parametros TK_OC_MAP tipo;

parametros: '(' lista_param ')' | '(' ')';

lista_param: lista_param ',' param | param;

param: tipo TK_IDENTIFICADOR;

corpo: bloco_cmd;

bloco_cmd: '{' lista_cmd_simples '}' | '{' '}';

lista_cmd_simples: lista_cmd_simples cmd ';' | cmd ';';

cmd: bloco_cmd | decl_var_local | atribuicao | fluxo_ctrl | op_retorno | chamada_funcao;

decl_var_local: tipo lista_var_local;

lista_var_local: lista_var_local ',' var_local | var_local;

var_local: TK_IDENTIFICADOR | TK_IDENTIFICADOR TK_OC_LE literal;

atribuicao: TK_IDENTIFICADOR '=' expressao;

chamada_funcao: TK_IDENTIFICADOR '(' argumentos ')' | TK_IDENTIFICADOR '(' ')';

argumentos: argumentos ',' expressao | expressao;

op_retorno: TK_PR_RETURN expressao;

fluxo_ctrl: condicional | interativa ;

condicional: TK_PR_IF '(' expressao ')' bloco_cmd TK_PR_ELSE bloco_cmd | TK_PR_IF '(' expressao ')' bloco_cmd

interativa: TK_PR_WHILE '(' expressao ')' bloco_cmd

expressao: operadores;

operandos: TK_IDENTIFICADOR | literal | chamada_funcao;

operadores: op_or;

op_or: op_and
    |  op_or op_pre_7 op_and;

op_and: ops_equal
    | op_and op_pre_6 ops_equal;

ops_equal: ops_comp
    | ops_equal op_pre_5 ops_comp;

ops_comp: ops_add_sub
    | ops_comp op_pre_4 ops_add_sub;

ops_add_sub: ops_mult_div
    | ops_add_sub op_pre_3 ops_mult_div;

ops_mult_div: ops_unario
    | ops_mult_div op_pre_2 ops_unario;

ops_unario: operandos
    | op_pre_1 ops_unario
    |  '(' op_or ')';

op_pre_1: '-'
    | '!';

op_pre_2: '*'
    | '/'
    | '%';

op_pre_3: '+'
    | '-';

op_pre_4: '<'
    | '>'
    | TK_OC_LE
    | TK_OC_GE;

op_pre_5: TK_OC_EQ
    | TK_OC_NE;

op_pre_6: TK_OC_AND;

op_pre_7: TK_OC_OR;

literal: TK_LIT_INT | TK_LIT_FLOAT | TK_LIT_FALSE | TK_LIT_TRUE;

tipo: TK_PR_INT | TK_PR_FLOAT | TK_PR_BOOL;

%%
void yyerror (const char *s){
    fprintf(stderr, "Error on line %d: %s\n", yylineno, s);
}