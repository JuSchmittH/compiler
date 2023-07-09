%{
    //Trabalho de Compiladores 2023/1 - Grupo G - Luma e Juliana
    
    #include <stdio.h>
    #include "vl.h"
    #include "ast.h"

    int yylex(void);
    extern int yylineno;
    void yyerror (const char *s);

    //TODO: not sure about that:
    extern AST *arvore;
%}

%define parse.error verbose

%union
{
    VL *valor_lexico;
    AST *arvore;
}

%token<valor_lexico> TK_PR_INT
%token<valor_lexico> TK_PR_FLOAT
%token<valor_lexico> TK_PR_BOOL
%token<valor_lexico> TK_PR_IF
%token<valor_lexico> TK_PR_ELSE
%token<valor_lexico> TK_PR_WHILE
%token<valor_lexico> TK_PR_RETURN
%token<valor_lexico> TK_OC_LE
%token<valor_lexico> TK_OC_GE
%token<valor_lexico> TK_OC_EQ
%token<valor_lexico> TK_OC_NE
%token<valor_lexico> TK_OC_AND
%token<valor_lexico> TK_OC_OR
%token<valor_lexico> TK_OC_MAP //TODO remove this and set directly on the node
%token<valor_lexico> TK_IDENTIFICADOR
%token<valor_lexico> TK_LIT_INT
%token<valor_lexico> TK_LIT_FLOAT
%token<valor_lexico> TK_LIT_FALSE
%token<valor_lexico> TK_LIT_TRUE
%token TK_ERRO

%type<arvore> programa
%type<arvore> lista
%type<arvore> elemento
%type<arvore> decl_var_global
%type<arvore> lista_var_global
%type<arvore> funcao
%type<arvore> cabecalho
%type<arvore> parametros
%type<arvore> lista_param
%type<arvore> param
%type<arvore> corpo
%type<arvore> bloco_cmd
%type<arvore> lista_cmd_simples
%type<arvore> cmd
%type<arvore> decl_var_local
%type<arvore> lista_var_local
%type<arvore> var_local
%type<arvore> atribuicao
%type<arvore> chamada_funcao
%type<arvore> argumentos
%type<arvore> op_retorno
%type<arvore> fluxo_ctrl
%type<arvore> condicional
%type<arvore> interativa
%type<arvore> expressao
%type<arvore> operandos
%type<arvore> operadores
%type<arvore> op_or
%type<arvore> op_and
%type<arvore> ops_equal
%type<arvore> ops_comp
%type<arvore> ops_add_sub
%type<arvore> ops_mult_div
%type<arvore> ops_unario
%type<arvore> op_pre_1
%type<arvore> op_pre_2
%type<arvore> op_pre_3
%type<arvore> op_pre_4
%type<arvore> op_pre_5
%type<arvore> op_pre_6
%type<arvore> op_pre_7
%type<arvore> literal
%type<arvore> tipo

%%

programa: lista                                             { $$ = arvore; }
    | ;

lista: lista elemento                                       { ast_add_child($$, $1); }
    | elemento                                              { ast_add_child($$, $1); }

elemento: funcao                                            { ast_add_child($$, $1); }
    | decl_var_global                                       { ast_add_child($$, $1); }

decl_var_global: tipo lista_var_global ';'                  { ast_add_child($$, $1); ast_add_child($$, $2); }//TODO: arvore precisa de vars globais ?

lista_var_global: lista_var_global ',' TK_IDENTIFICADOR     { ast_add_child($$, $1); $$ = ast_new($3->token_value); }//TODO: revisar
    | TK_IDENTIFICADOR                                      { $$ = ast_new($1); }//TODO: revisar

funcao: cabecalho corpo                                     { ast_add_child($$, $1); ast_add_child($$, $2); }//TODO: revisar

cabecalho: TK_IDENTIFICADOR parametros TK_OC_MAP tipo       { $$ = ast_new($1); $$ = ast_new($3); ast_add_child($$, $2); ast_add_child($$, $2); }//TODO: revisar

parametros: '(' lista_param ')'                             { $$ = $2; }
    | '(' ')';

lista_param: lista_param ',' param                          { ast_add_child($$, $1); ast_add_child($$, $3;) }//TODO: revisar
    | param                                                 { ast_add_child($$, $1); }//TODO: revisar

param: tipo TK_IDENTIFICADOR                                { $$ = ast_new($2); ast_add_child($$, $1); }

corpo: bloco_cmd                                            { $$ = $1; }

bloco_cmd: '{' lista_cmd_simples '}'                        { $$ = $2; }
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

atribuicao: TK_IDENTIFICADOR '=' expressao                  { $$ = ast_new($1); ast_add_child($$, $3); }

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
    |  '(' op_or ')'                                        { $$ = $2;}

op_pre_1: '-'                                               { $$ = ast_new("-"); }  
    | '!'                                                   { $$ = ast_new("!"); } 

op_pre_2: '*'                                               { $$ = ast_new("*"); }   
    | '/'                                                   { $$ = ast_new("/"); }   
    | '%'                                                   { $$ = ast_new("%"); }   

op_pre_3: '+'                                               { $$ = ast_new("+"); } 
    | '-'                                                   { $$ = ast_new("-"); } 

op_pre_4: '<'                                               { $$ = ast_new("<"); } 
    | '>'                                                   { $$ = ast_new(">"); }   
    | TK_OC_LE                                              { $$ = ast_new($1); } //TODO remove type from token and 
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