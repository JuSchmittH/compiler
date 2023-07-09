%{
    //Trabalho de Compiladores 2023/1 - Grupo G - Luma e Juliana
    
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

%union
{
    VL *valor_lexico;
    AST *tree;
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
%token<valor_lexico> TK_IDENTIFICADOR
%token<valor_lexico> TK_LIT_INT
%token<valor_lexico> TK_LIT_FLOAT
%token<valor_lexico> TK_LIT_FALSE
%token<valor_lexico> TK_LIT_TRUE
%token TK_ERRO

%type<tree> programa
%type<tree> lista
%type<tree> elemento
%type<tree> decl_var_global
%type<tree> lista_var_global
%type<tree> funcao
%type<tree> cabecalho
%type<tree> parametros
%type<tree> lista_param
%type<tree> param
%type<tree> corpo
%type<tree> bloco_cmd
%type<tree> lista_cmd_simples
%type<tree> cmd
%type<tree> decl_var_local
%type<tree> lista_var_local
%type<tree> var_local
%type<tree> atribuicao
%type<tree> chamada_funcao
%type<tree> argumentos
%type<tree> op_retorno
%type<tree> fluxo_ctrl
%type<tree> condicional
%type<tree> interativa
%type<tree> expressao
%type<tree> operandos
%type<tree> operadores
%type<tree> op_or
%type<tree> op_and
%type<tree> ops_equal
%type<tree> ops_comp
%type<tree> ops_add_sub
%type<tree> ops_mult_div
%type<tree> ops_unario
%type<tree> op_pre_1
%type<tree> op_pre_2
%type<tree> op_pre_3
%type<tree> op_pre_4
%type<tree> op_pre_5
%type<tree> op_pre_6
%type<tree> op_pre_7
%type<tree> literal
%type<tree> tipo

%%

programa: lista                                             { $$ = arvore; }
    | ;

lista: lista elemento                                       { ast_add_child($$, $1); }
    | elemento                                              { ast_add_child($$, $1); }

elemento: funcao                                            { ast_add_child($$, $1); }
    | decl_var_global                                       { ast_add_child($$, $1); }

decl_var_global: tipo lista_var_global ';'                  { ast_add_child($$, $1); ast_add_child($$, $2); }//TODO: arvore precisa de vars globais ?

lista_var_global: lista_var_global ',' TK_IDENTIFICADOR     { ast_add_child($$, $1); $$ = ast_new($3); }//TODO: revisar
    | TK_IDENTIFICADOR                                      { $$ = ast_new($1); }//TODO: revisar

funcao: cabecalho corpo                                     { ast_add_child($$, $1); ast_add_child($$, $2); }//TODO: revisar

cabecalho: TK_IDENTIFICADOR parametros TK_OC_MAP tipo       { $$ = ast_new($1); $$ = ast_new($3); ast_add_child($$, $2); ast_add_child($$, $2); }//TODO: revisar

parametros: '(' lista_param ')'                             { $$ = $2; }
    | '(' ')';

lista_param: lista_param ',' param                          { ast_add_child($$, $1); ast_add_child($$, $3;) }//TODO: revisar
    | param                                                 { ast_add_child($$, $1); }//TODO: revisar

param: tipo TK_IDENTIFICADOR                                { $$ = ast_new($2); ast_add_child($$, $1); }

corpo: bloco_cmd                                            { $$ = $1; }

bloco_cmd: '{' lista_cmd_simples '}'                        { $$ = $1; }
    | '{' '}'

lista_cmd_simples: lista_cmd_simples cmd ';'                { ast_add_child($$, $1); ast_add_child($$, $2); }//TODO: revisar
    | cmd ';'                                               { $$ = $1; }

cmd: bloco_cmd                                              { $$ = $1; }
    | decl_var_local                                        { $$ = $1; }
    | atribuicao                                            { $$ = $1; }
    | fluxo_ctrl                                            { $$ = $1; }
    | op_retorno                                            { $$ = $1; }
    | chamada_funcao                                        { $$ = $1; }

decl_var_local: tipo lista_var_local                        { ast_add_child($$, $1); ast_add_child($$, $2);}//TODO: revisar

lista_var_local: lista_var_local ',' var_local              { ast_add_child($$, $1); ast_add_child($$, $3);}//TODO: REVISAR
    | var_local                                             { ast_add_child($$, $1); }//TODO: REVISAR

var_local: TK_IDENTIFICADOR                                 { $$ = ast_new($1); }
    | TK_IDENTIFICADOR TK_OC_LE literal                     { $$ = ast_new($1); $$ = ast_new($2); ast_add_child($$, $3);}

atribuicao: TK_IDENTIFICADOR '=' expressao                  { $$ = ast_new($1); ast_add_child($$, $2); }

chamada_funcao: TK_IDENTIFICADOR '(' argumentos ')'         { $$ = ast_new($1); ast_add_child($$, $3); }
    | TK_IDENTIFICADOR '(' ')'                              { $$ = ast_new($1); }

argumentos: argumentos ',' expressao                        { $$ = ast_new($1); ast_add_child($$, $1); ast_add_child($$, $3); }//TODO: não sei como fazer 
    | expressao                                             { $$ = $1; }

op_retorno: TK_PR_RETURN expressao                          { $$ = ast_new($1); ast_add_child($$, $2); }

fluxo_ctrl: condicional                                     { $$ = $1; }
    | interativa                                            { $$ = $1; }

condicional: TK_PR_IF '(' expressao ')' bloco_cmd TK_PR_ELSE bloco_cmd      { $$ = ast_new($1); ast_add_child($$, $3); ast_add_child($$, $5); $$ = ast_new($6); ast_add_child($$, $7); }
    | TK_PR_IF '(' expressao ')' bloco_cmd                                  { $$ = ast_new($1); ast_add_child($$, $3); ast_add_child($$, $5); }

interativa: TK_PR_WHILE '(' expressao ')' bloco_cmd         { $$ = ast_new($1); ast_add_child($$, $3); ast_add_child($$, $5); }//TODO: bloco não deve ser incluido?

expressao: operadores                                       { $$ = $1; }

operandos: TK_IDENTIFICADOR                                 { $$ = ast_new($1); }
    | literal                                               { $$ = $1; }
    | chamada_funcao                                        { $$ = $1; }

operadores: op_or                                           { $$ = $1; } //TODO: ver se é isso memo

op_or: op_and                                               { $$ = $1; } //TODO: ver se é isso memo
    |  op_or op_pre_7 op_and                                { $$ = ast_new($2); ast_add_child($$, $1); ast_add_child($$, $3); } // TODO nao entendi isso 

op_and: ops_equal                                           { $$ = $1; } //TODO: ver se é isso memo
    | op_and op_pre_6 ops_equal                             { $$ = ast_new($2); ast_add_child($$, $1); ast_add_child($$, $3); }// TODO nao entendi isso 

ops_equal: ops_comp                                         { $$ = $1; } //TODO: ver se é isso memo
    | ops_equal op_pre_5 ops_comp                           { $$ = ast_new($2); ast_add_child($$, $1); ast_add_child($$, $3); }// TODO nao entendi isso 

ops_comp: ops_add_sub                                       { $$ = $1; } //TODO: ver se é isso memo
    | ops_comp op_pre_4 ops_add_sub                         { $$ = ast_new($2); ast_add_child($$, $1); ast_add_child($$, $3); }// TODO nao entendi isso 

ops_add_sub: ops_mult_div                                   { $$ = $1; } //TODO: ver se é isso memo
    | ops_add_sub op_pre_3 ops_mult_div                     { $$ = ast_new($2); ast_add_child($$, $1); ast_add_child($$, $3); }// TODO nao entendi isso 

ops_mult_div: ops_unario                                    { $$ = $1; } //TODO: ver se é isso memo
    | ops_mult_div op_pre_2 ops_unario                      { $$ = ast_new($2); ast_add_child($$, $1); ast_add_child($$, $3); }// TODO nao entendi isso 

ops_unario: operandos                                       { $$ = ast_new($1); } //TODO: ver se é para criar um node mesmo
    | op_pre_1 ops_unario                                   { $$ = ast_new($1); ast_add_child($$, $2); } // TODO nao entendi isso 
    |  '(' op_or ')'                                        { $$ = ast_new($1); ast_add_child($$, $2); }// TODO nao entendi isso 

op_pre_1: '-'                                               { $$ = $1; }
    | '!'                                                   { $$ = $1; }

op_pre_2: '*'                                               { $$ = $1; }
    | '/'                                                   { $$ = $1; }
    | '%'                                                   { $$ = $1; }

op_pre_3: '+'                                               { $$ = $1; }
    | '-'                                                   { $$ = $1; }

op_pre_4: '<'                                               { $$ = $1; }
    | '>'                                                   { $$ = $1; }
    | TK_OC_LE                                              { $$ = $1; }
    | TK_OC_GE                                              { $$ = $1; }

op_pre_5: TK_OC_EQ                                          { $$ = $1; }
    | TK_OC_NE                                              { $$ = $1; }

op_pre_6: TK_OC_AND                                         { $$ = $1; }

op_pre_7: TK_OC_OR                                          { $$ = $1; }

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