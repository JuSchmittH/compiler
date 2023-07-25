%{
    //Trabalho de Compiladores 2023/1 - Grupo G - Luma e Juliana
    #include <stdio.h>
    #include <string.h>
    int yylex(void);
    extern int yylineno;
    void yyerror (const char *s);
    extern void *arvore;

    STACK *pilha;
%}

%code requires { 
    #include "vl.h"
    #include "ast.h"
    #include "stack.h"
    #include "semantic.h"
 }

%define parse.error verbose

%union
{
    VL *valor_lexico;
    AST *ast;
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
%token<valor_lexico> TK_OC_MAP
%token<valor_lexico> TK_IDENTIFICADOR
%token<valor_lexico> TK_LIT_INT
%token<valor_lexico> TK_LIT_FLOAT
%token<valor_lexico> TK_LIT_FALSE
%token<valor_lexico> TK_LIT_TRUE
%token TK_ERRO

%type<ast> programa
%type<ast> lista
%type<ast> elemento
%type<ast> decl_var_global
%type<ast> lista_var_global
%type<ast> funcao
%type<ast> cabecalho
%type<ast> parametros
%type<ast> lista_param
%type<ast> param
%type<ast> corpo
%type<ast> bloco_cmd
%type<ast> lista_cmd_simples
%type<ast> cmd
%type<ast> decl_var_local
%type<ast> lista_var_local
%type<ast> var_local
%type<ast> atribuicao
%type<ast> chamada_funcao
%type<ast> argumentos
%type<ast> op_retorno
%type<ast> fluxo_ctrl
%type<ast> condicional
%type<ast> interativa
%type<ast> expressao
%type<ast> operandos
%type<ast> operadores
%type<ast> op_or
%type<ast> op_and
%type<ast> ops_equal
%type<ast> ops_comp
%type<ast> ops_add_sub
%type<ast> ops_mult_div
%type<ast> ops_unario
%type<ast> op_pre_1
%type<ast> op_pre_2
%type<ast> op_pre_3
%type<ast> op_pre_4
%type<ast> op_pre_5
%type<ast> op_pre_6
%type<ast> op_pre_7
%type<ast> literal
%type<ast> tipo

%%

inicio: cria_escopo programa

cria_escopo:                                                {pilha = global_scope_new()}

programa: lista                                             { $$ = $1; arvore = $$; }
    |                                                       { $$ = NULL; }

lista: elemento lista                                       { if($1 != NULL ) { $$ = $1;  if($2 != NULL){ ast_add_child($$, $2); }} else if($2 != NULL) {$$ = $2;} }
    | elemento                                              { $$ = $1; }

elemento: funcao                                            { $$ = $1; }
    | decl_var_global                                       { $$ = $1; }

decl_var_global: tipo lista_var_global ';'                  { $$ = NULL; }

lista_var_global: lista_var_global ',' TK_IDENTIFICADOR     { $$ = NULL; }
    | TK_IDENTIFICADOR                                      { $$ = NULL; }

funcao: cabecalho corpo                                     { $$ = $1; if($2 != NULL) { ast_add_child($$, $2); } }

cabecalho: TK_IDENTIFICADOR parametros TK_OC_MAP tipo       { $$ = ast_new($1); }

parametros: '(' lista_param ')'                             { $$ = NULL; }
    | '(' ')'                                               { $$ = NULL; }

lista_param: lista_param ',' param                          { $$ = NULL; }
    | param                                                 { $$ = NULL; }

param: tipo TK_IDENTIFICADOR                                { $$ = NULL; }

corpo: bloco_cmd                                            { $$ = $1; }

bloco_cmd: '{' lista_cmd_simples '}'                        { $$ = $2; }
    | '{' '}'                                               { $$ = NULL; }

lista_cmd_simples: cmd ';' lista_cmd_simples                { 
                                                                if($1 != NULL) 
                                                                { $$ = $1;
                                                                    if($3 != NULL)
                                                                    {
                                                                        if (!strcmp($1->item->token_value, "if")){
                                                                            ast_add_child($1, $3);
                                                                        }
                                                                        else {
                                                                            AST *last_node = $1;
                                                                            while(last_node->number_of_children == 3) {
                                                                                last_node = last_node->children[2];
                                                                            }
                                                                            ast_add_child(last_node, $3);
                                                                        }
                                                                    }
                                                                } 
                                                                else if($3 != NULL) {$$ = $3;}
                                                            }
    | cmd ';'                                               { $$ = $1; }

cmd: bloco_cmd                                              { $$ = $1; }
    | decl_var_local                                        { $$ = $1; }
    | atribuicao                                            { $$ = $1; }
    | fluxo_ctrl                                            { $$ = $1; }
    | op_retorno                                            { $$ = $1; }
    | chamada_funcao                                        { $$ = $1; }

decl_var_local: tipo lista_var_local                        { $$ = $2; }

lista_var_local: var_local ',' lista_var_local              { if($1 != NULL ) { $$ = $1;  if($3 != NULL){ ast_add_child($$, $3); }} else if($3 != NULL){$$ = $3;} }
    | var_local                                             { $$ = $1; }

var_local: TK_IDENTIFICADOR                                 { $$ = NULL; }
    | TK_IDENTIFICADOR TK_OC_LE literal                     { $$ = ast_new($2); ast_add_child($$, ast_new($1)); ast_add_child($$, $3); }

atribuicao: TK_IDENTIFICADOR '=' expressao                  { $$ = ast_new(vl_new(yylineno, 1, "=")); ast_add_child($$, ast_new($1)); ast_add_child($$, $3); }

chamada_funcao: TK_IDENTIFICADOR '(' argumentos ')'         {
                                                                char call[] = "call ";
                                                                $$ = ast_new(vl_new($1->line_number, $1->token_type, strcat(call,$1->token_value)));
                                                                ast_add_child($$, $3);
                                                            }
    | TK_IDENTIFICADOR '(' ')'                              { $$ = ast_new($1); }

argumentos: expressao ',' argumentos                        { $$ = $1; if($3 != NULL) { ast_add_child($$, $3); } }
    | expressao                                             { $$ = $1; }

op_retorno: TK_PR_RETURN expressao                          { $$ = ast_new($1); ast_add_child($$, $2); }

fluxo_ctrl: condicional                                     { $$ = $1; }
    | interativa                                            { $$ = $1; }

condicional: TK_PR_IF '(' expressao ')' bloco_cmd TK_PR_ELSE bloco_cmd      { $$ = ast_new($1); ast_add_child($$, $3); if($5 != NULL){ ast_add_child($$, $5); } if($7 != NULL){ ast_add_child($$, $7); } }
    | TK_PR_IF '(' expressao ')' bloco_cmd                                  { $$ = ast_new($1); ast_add_child($$, $3); if($5 != NULL){ ast_add_child($$, $5); } }

interativa: TK_PR_WHILE '(' expressao ')' bloco_cmd         { $$ = ast_new($1); ast_add_child($$, $3); ast_add_child($$, $5); }

expressao: operadores                                       { $$ = $1; }

operandos: TK_IDENTIFICADOR                                 { $$ = ast_new($1); }
    | literal                                               { $$ = $1; }
    | chamada_funcao                                        { $$ = $1; }

operadores: op_or                                           { $$ = $1; } 

op_or: op_and                                               { $$ = $1; } 
    |  op_or op_pre_7 op_and                                { $$ = $2; ast_add_child($$, $1); ast_add_child($$, $3); }

op_and: ops_equal                                           { $$ = $1; }
    | op_and op_pre_6 ops_equal                             { $$ = $2; ast_add_child($$, $1); ast_add_child($$, $3); }

ops_equal: ops_comp                                         { $$ = $1; } 
    | ops_equal op_pre_5 ops_comp                           { $$ = $2; ast_add_child($$, $1); ast_add_child($$, $3); }

ops_comp: ops_add_sub                                       { $$ = $1; } 
    | ops_comp op_pre_4 ops_add_sub                         { $$ = $2; ast_add_child($$, $1); ast_add_child($$, $3); }

ops_add_sub: ops_mult_div                                   { $$ = $1; } 
    | ops_add_sub op_pre_3 ops_mult_div                     { $$ = $2; ast_add_child($$, $1); ast_add_child($$, $3); }

ops_mult_div: ops_unario                                    { $$ = $1; }
    | ops_mult_div op_pre_2 ops_unario                      { $$ = $2; ast_add_child($$, $1); ast_add_child($$, $3); }

ops_unario: operandos                                       { $$ = $1; }
    | op_pre_1 ops_unario                                   { $$ = $1; ast_add_child($$, $2); }
    |  '(' op_or ')'                                        { $$ = $2;}

op_pre_1: '-'                                               { $$ = ast_new(vl_new(yylineno, 3, "-")); }  
    | '!'                                                   { $$ = ast_new(vl_new(yylineno, 3, "!")); } 

op_pre_2: '*'                                               { $$ = ast_new(vl_new(yylineno, 3, "*")); }   
    | '/'                                                   { $$ = ast_new(vl_new(yylineno, 3, "/")); }   
    | '%'                                                   { $$ = ast_new(vl_new(yylineno, 3, "%")); }   

op_pre_3: '+'                                               { $$ = ast_new(vl_new(yylineno, 3, "+")); } 
    | '-'                                                   { $$ = ast_new(vl_new(yylineno, 3, "-")); } 

op_pre_4: '<'                                               { $$ = ast_new(vl_new(yylineno, 3, "<")); } 
    | '>'                                                   { $$ = ast_new(vl_new(yylineno, 3, ">")); }   
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

tipo: TK_PR_INT                                             { $$ = NULL; }                                           
    | TK_PR_FLOAT                                           { $$ = NULL; }                                       
    | TK_PR_BOOL                                            { $$ = NULL; }                                          

%%
void yyerror (const char *s){
    fprintf(stderr, "Error on line %d: %s\n", yylineno, s);
}