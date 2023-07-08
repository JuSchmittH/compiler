%{
    //Trabalho de Compilados 2023/1 - Grupo G - Luma e Juliana
    
    #include <stdio.h>
    #include "vl.h"
    #include "ast.h"

    int yylex(void);
    extern int yylineno;
    void yyerror (const char *s);
    
    //TODO: not sure about that
    extern void *arvore;
%}

%define parse.error verbose
%define api.value.type { AST* }

%union
{
    VL *valor_lexico;
}

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

programa: lista                                             { $$ = arvore; }
    | ;

lista: lista elemento                                       { ast_add_child($$, $1); }
    | elemento                                              { ast_add_child($$, $1); }

elemento: funcao                                            { ast_add_child($$, $1); }
    | decl_var_global                                       { ast_add_child($$, $1); }

decl_var_global: tipo lista_var_global ';'                  { ast_add_child($$, $1); ast_add_child($$, $2); }

lista_var_global: lista_var_global ',' TK_IDENTIFICADOR     { ast_add_child($$, $1); ast_add_child($$, $3); }
    | TK_IDENTIFICADOR                                      { $$ = ast_new($1); }

funcao: cabecalho corpo                                     { ast_add_child($$, $1); ast_add_child($$, $2); }

cabecalho: TK_IDENTIFICADOR parametros TK_OC_MAP tipo       { $$ = ast_new($1); $$ = ast_new($3); ast_add_child($$, $2); ast_add_child($$, $2); }

parametros: '(' lista_param ')'                             { ast_add_child($$, $2); }
    | '(' ')';

lista_param: lista_param ',' param                          { ast_add_child($$, $1); ast_add_child($$, $3;) }
    | param                                                 { ast_add_child($$, $1); }

param: tipo TK_IDENTIFICADOR                                { $$ = ast_new($2); ast_add_child($$, $1); }

corpo: bloco_cmd                                            { ast_add_child($$, $1); }

bloco_cmd: '{' lista_cmd_simples '}'                        { ast_add_child($$, $2); }
    | '{' '}'

lista_cmd_simples: lista_cmd_simples cmd ';'                { ast_add_child($$, $1); ast_add_child($$, $2); }
    | cmd ';'                                               { ast_add_child($$, $1); }

cmd: bloco_cmd                                              { ast_add_child($$, $1); }
    | decl_var_local                                        { ast_add_child($$, $1); }
    | atribuicao                                            { ast_add_child($$, $1); }
    | fluxo_ctrl                                            { ast_add_child($$, $1); }
    | op_retorno                                            { ast_add_child($$, $1); }
    | chamada_funcao                                        { ast_add_child($$, $1); }

decl_var_local: tipo lista_var_local                        { ast_add_child($$, $1); ast_add_child($$, $2);}

lista_var_local: lista_var_local ',' var_local              { ast_add_child($$, $1); ast_add_child($$, $3);}
    | var_local                                             { ast_add_child($$, $1); }

var_local: TK_IDENTIFICADOR                                 { $$ = ast_new($1); }
    | TK_IDENTIFICADOR TK_OC_LE literal                     { $$ = ast_new($1); $$ = ast_new($2); ast_add_child($$, $3);}

atribuicao: TK_IDENTIFICADOR '=' expressao                  { $$ = ast_new($1); ast_add_child($$, $2); }

chamada_funcao: TK_IDENTIFICADOR '(' argumentos ')'         { $$ = ast_new($1); ast_add_child($$, $3); }
    | TK_IDENTIFICADOR '(' ')'                              { $$ = ast_new($1); }

argumentos: argumentos ',' expressao                        { ast_add_child($$, $1); ast_add_child($$, $3); }
    | expressao                                             { ast_add_child($$, $1); }

op_retorno: TK_PR_RETURN expressao                          { $$ = ast_new($1); ast_add_child($$, $2); }

fluxo_ctrl: condicional                                     { ast_add_child($$, $1); }
    | interativa                                            { ast_add_child($$, $1); }

condicional: TK_PR_IF '(' expressao ')' bloco_cmd TK_PR_ELSE bloco_cmd      { $$ = ast_new($1); ast_add_child($$, $3); ast_add_child($$, $5); $$ = ast_new($6); ast_add_child($$, $7); }
    | TK_PR_IF '(' expressao ')' bloco_cmd                                  { $$ = ast_new($1); ast_add_child($$, $3); ast_add_child($$, $5); }

interativa: TK_PR_WHILE '(' expressao ')' bloco_cmd         { $$ = ast_new($1); ast_add_child($$, $3); ast_add_child($$, $5); }

expressao: operadores                                       { ast_add_child($$, $1); }

operandos: TK_IDENTIFICADOR                                 { $$ = ast_new($1); }
    | literal                                               { ast_add_child($$, $1); }
    | chamada_funcao                                        { ast_add_child($$, $1); }

operadores: op_or                                           { ast_add_child($$, $1); }

op_or: op_and                                               { ast_add_child($$, $1); }
    |  op_or op_pre_7 op_and                                { ast_add_child($$, $1); ast_add_child($$, $2); ast_add_child($$, $3); }

op_and: ops_equal                                           { ast_add_child($$, $1); }
    | op_and op_pre_6 ops_equal                             { ast_add_child($$, $1); ast_add_child($$, $2); ast_add_child($$, $3); }

ops_equal: ops_comp                                         { ast_add_child($$, $1); }
    | ops_equal op_pre_5 ops_comp                           { ast_add_child($$, $1); ast_add_child($$, $2); ast_add_child($$, $3); }

ops_comp: ops_add_sub                                       { ast_add_child($$, $1); }
    | ops_comp op_pre_4 ops_add_sub                         { ast_add_child($$, $1); ast_add_child($$, $2); ast_add_child($$, $3); }

ops_add_sub: ops_mult_div                                   { ast_add_child($$, $1); }
    | ops_add_sub op_pre_3 ops_mult_div                     { ast_add_child($$, $1); ast_add_child($$, $2); ast_add_child($$, $3); }

ops_mult_div: ops_unario                                    { ast_add_child($$, $1); }
    | ops_mult_div op_pre_2 ops_unario                      { ast_add_child($$, $1); ast_add_child($$, $2); ast_add_child($$, $3); }

ops_unario: operandos                                       { ast_add_child($$, $1); }
    | op_pre_1 ops_unario                                   { ast_add_child($$, $1); ast_add_child($$, $2); }
    |  '(' op_or ')'                                        { ast_add_child($$, $2); }

op_pre_1: '-'                                               { $$ = ast_new($1); }
    | '!'                                                   { $$ = ast_new($1); }

op_pre_2: '*'                                               { $$ = ast_new($1); }
    | '/'                                                   { $$ = ast_new($1); }
    | '%'                                                   { $$ = ast_new($1); }

op_pre_3: '+'                                               { $$ = ast_new($1); }
    | '-'                                                   { $$ = ast_new($1); }

op_pre_4: '<'                                               { $$ = ast_new($1); }
    | '>'                                                   { $$ = ast_new($1); }
    | TK_OC_LE                                              { $$ = ast_new($1); }
    | TK_OC_GE                                              { $$ = ast_new($1); }

op_pre_5: TK_OC_EQ                                          { $$ = ast_new($1); }
    | TK_OC_NE                                              { $$ = ast_new($1); }

op_pre_6: TK_OC_AND                                         { $$ = ast_new($1); }

op_pre_7: TK_OC_OR                                          { $$ = ast_new($1); }

literal: TK_LIT_INT                                         { $$ = ast_new($1); }
    | TK_LIT_FLOAT                                          { $$ = ast_new($1); }
    | TK_LIT_FALSE                                          { $$ = ast_new($1); }
    | TK_LIT_TRUE                                           { $$ = ast_new($1); }

tipo: TK_PR_INT                                             { $$ = ast_new($1); }
    | TK_PR_FLOAT                                           { $$ = ast_new($1); }
    | TK_PR_BOOL                                            { $$ = ast_new($1); }

%%
void yyerror (const char *s){
    fprintf(stderr, "Error on line %d: %s\n", yylineno, s);
}