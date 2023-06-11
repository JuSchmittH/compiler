%{
    #include <stdio.h>
int yylex(void);
void yyerror (char const *s);
%}

//TODO arrumar isso aqui 
//%define parser.error detailed

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

argumentos: argumentos expressao | expressao;

op_retorno: TK_PR_RETURN expressao;

fluxo_ctrl: condicional | interativa ;

condicional: TK_PR_IF '(' expressao ')' bloco_cmd TK_PR_ELSE bloco_cmd | TK_PR_IF '(' expressao ')' bloco_cmd

interativa: TK_PR_WHILE '(' expressao ')' bloco_cmd

//TODO ver o lance da precedencia e testar tudo
expressao: operandos | operadores;

operandos: TK_IDENTIFICADOR | literal | chamada_funcao;

operadores: '-' expressao | '!' expressao | '(' expressao ')'
    | expressao '+' expressao | expressao '-' expressao | expressao '*' expressao | expressao '/' expressao | expressao '%' expressao 
    | expressao TK_OC_AND expressao | expressao TK_OC_EQ expressao | expressao TK_OC_GE expressao | expressao TK_OC_LE expressao | expressao TK_OC_NE expressao | expressao TK_OC_OR expressao;

literal: TK_LIT_INT | TK_LIT_FLOAT | TK_LIT_FALSE | TK_LIT_TRUE;

tipo: TK_PR_INT | TK_PR_FLOAT | TK_PR_BOOL;

%%
void yyerror (char const *s){
    //TODO: adicionar nro da linha
    fprintf(stderr, "Error: %s\n", s);
}