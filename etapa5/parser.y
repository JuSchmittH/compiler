%{
    //Trabalho de Compiladores 2023/1 - Grupo G - Luma e Juliana
    //Estamos fazendo a tradução em uma passagem

    #include <stdio.h>
    #include <string.h>
    #include "stack.h"
    int yylex(void);
    extern int yylineno;
    void yyerror (const char *s);
    extern void *arvore;

    STACK *pilha;
%}

%code requires { 
    #include "vl.h"
    #include "ast.h"
    #include "semantic.h"
    #include "iloc.h"
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
%type<ast> lista_int_var_global
%type<ast> lista_float_var_global
%type<ast> lista_bool_var_global
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
%type<ast> lista_var_int_local
%type<ast> lista_var_float_local
%type<ast> lista_var_bool_local
%type<ast> int_var_local
%type<ast> float_var_local
%type<ast> bool_var_local
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
%type<ast> literais

%%

inicio: cria_escopo_global programa fecha_escopo_global

cria_escopo_global:                                                { pilha = global_scope_new(); }

fecha_escopo_global:                                               { global_scope_close(&pilha); }

programa: lista                                             { $$ = $1; arvore = $$; }
    |                                                       { $$ = NULL; }

lista: elemento lista                                       { if($1 != NULL ) { $$ = $1;  if($2 != NULL){ ast_add_child($$, $2); }} else if($2 != NULL) {$$ = $2;} }
    | elemento                                              { $$ = $1; }

elemento: funcao                                            { $$ = $1; }
    | decl_var_global                                       { $$ = $1; }

decl_var_global: TK_PR_INT lista_int_var_global ';'                     { $$ = NULL; }
    | TK_PR_FLOAT lista_float_var_global ';'                            { $$ = NULL; }
    | TK_PR_BOOL lista_bool_var_global ';'                              { $$ = NULL; }

lista_int_var_global: lista_int_var_global ',' TK_IDENTIFICADOR         { $$ = NULL; validate_declaration(pilha, "rbss", $3, inteiro, identificador); }
    | TK_IDENTIFICADOR                                                  { $$ = NULL; validate_declaration(pilha, $1, inteiro, identificador); }

lista_float_var_global: lista_float_var_global ',' TK_IDENTIFICADOR     { $$ = NULL; validate_declaration(pilha, "rbss", $3, pontoflutuante, identificador); }
    | TK_IDENTIFICADOR                                                  { $$ = NULL; validate_declaration(pilha, "rbss", $1, pontoflutuante, identificador); }

lista_bool_var_global: lista_bool_var_global ',' TK_IDENTIFICADOR       { $$ = NULL; validate_declaration(pilha, "rbss", $3, booleano, identificador); }
    | TK_IDENTIFICADOR                                                  { $$ = NULL; validate_declaration(pilha, "rbss", $1, booleano, identificador); }

funcao: cabecalho corpo                                         { 
                                                                    $ = $1; 
                                                                    if($2 != NULL) 
                                                                    { 
                                                                        ast_add_child($$, $2);
                                                                        strcpy($$->code->operation, $2->code->operation);
                                                                    } 
                                                                }

cabecalho: TK_IDENTIFICADOR  parametros TK_OC_MAP TK_PR_INT   { $$ = ast_new(inteiro,$1); validate_declaration(pilha, "", $1, inteiro, funcao); }
    | TK_IDENTIFICADOR parametros TK_OC_MAP TK_PR_FLOAT       { $$ = ast_new(pontoflutuante,$1); validate_declaration(pilha, "", $1, pontoflutuante, funcao); }
    | TK_IDENTIFICADOR parametros TK_OC_MAP TK_PR_BOOL        { $$ = ast_new(booleano,$1); validate_declaration(pilha, "", $1, booleano, funcao);}

parametros: cria_escopo '(' lista_param ')'                 { $$ = NULL; }
    | cria_escopo '(' ')'                                   { $$ = NULL; }
    
cria_escopo:                                                { scope_new(&pilha); }

lista_param: lista_param ',' param                          { $$ = NULL; }
    | param                                                 { $$ = NULL; }

param: TK_PR_INT TK_IDENTIFICADOR                            { $$ = NULL; validate_declaration(pilha, "rfp", $2, inteiro, identificador);}
    | TK_PR_FLOAT TK_IDENTIFICADOR                           { $$ = NULL; validate_declaration(pilha, "rfp", $2, pontoflutuante, identificador);}
    | TK_PR_BOOL TK_IDENTIFICADOR                            { $$ = NULL; validate_declaration(pilha, "rfp", $2, booleano, identificador);}

corpo: bloco_cmd fecha_escopo                               { $$ = $1; }

fecha_escopo:                                               { scope_close(&pilha); }

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

                                                                        strcpy($$->code, concat($1->code, $3->code));
                                                                    }
                                                                } 
                                                                else if($3 != NULL) {$$ = $3;}
                                                            }
    | cmd ';'                                               { $$ = $1; }

cmd: cria_escopo bloco_cmd fecha_escopo                     { $$ = $2; }
    | decl_var_local                                        { $$ = $1; }
    | atribuicao                                            { $$ = $1; }
    | fluxo_ctrl                                            { $$ = $1; }
    | op_retorno                                            { $$ = $1; }
    | chamada_funcao                                        { $$ = $1; }

decl_var_local: TK_PR_INT lista_var_int_local               { $$ = $2; }
    |TK_PR_FLOAT lista_var_float_local                      { $$ = $2; }
    |TK_PR_BOOL lista_var_bool_local                        { $$ = $2; }

lista_var_int_local: int_var_local ',' lista_var_int_local          { if($1 != NULL ) { $$ = $1;  if($3 != NULL){ ast_add_child($$, $3); }} else if($3 != NULL){$$ = $3;} }
    | int_var_local                                                 { $$ = $1; }

lista_var_float_local: float_var_local ',' lista_var_float_local    { if($1 != NULL ) { $$ = $1;  if($3 != NULL){ ast_add_child($$, $3); }} else if($3 != NULL){$$ = $3;} }
    | float_var_local                                               { $$ = $1; }

lista_var_bool_local: bool_var_local ',' lista_var_bool_local       { if($1 != NULL ) { $$ = $1;  if($3 != NULL){ ast_add_child($$, $3); }} else if($3 != NULL){$$ = $3;} }
    | bool_var_local                                                { $$ = $1; }

int_var_local: TK_IDENTIFICADOR                             { $$ = NULL; validate_declaration(pilha, "rfp", $1, inteiro, identificador);}
    | TK_IDENTIFICADOR TK_OC_LE literais                     { $$ = ast_new(notdefined,$2); ast_add_child($$, ast_new(inteiro,$1)); ast_add_child($$, $3); validate_declaration(pilha, "rfp", $1, inteiro, identificador);}

float_var_local: TK_IDENTIFICADOR                           { $$ = NULL; validate_declaration(pilha, "rfp", $1, pontoflutuante, identificador);}
    | TK_IDENTIFICADOR TK_OC_LE literais                     { $$ = ast_new(notdefined,$2); ast_add_child($$, ast_new(pontoflutuante,$1)); ast_add_child($$, $3); validate_declaration(pilha, "rfp", $1, pontoflutuante, identificador);}

bool_var_local: TK_IDENTIFICADOR                            { $$ = NULL; validate_declaration(pilha, "rfp", $1, booleano, identificador); }
    | TK_IDENTIFICADOR TK_OC_LE literais                     { $$ = ast_new(notdefined,$2); ast_add_child($$, ast_new(booleano,$1)); ast_add_child($$, $3); validate_declaration(pilha, "rfp", $1, booleano, identificador);}

atribuicao: TK_IDENTIFICADOR '=' expressao                  { 
                                                                CONTENT* content  = validate_undeclared(pilha, $1, identificador);
                                                                $$ = ast_new(notdefined, vl_new(yylineno, 1, "="));
                                                                ast_add_child($$, ast_new(content->type, $1));
                                                                ast_add_child($$, $3);
                                                                
                                                                ILOC_OP *operation = iloc_op_new("storeAI", $3.temp, content->ref, content->displacement, right);
                                                                strcpy($$->code, concatCode($3->code, operation));
                                                            }

chamada_funcao: TK_IDENTIFICADOR '(' argumentos ')'         {
                                                                CONTENT* content  = validate_undeclared(pilha, $1, funcao);
                                                                char call[] = "call ";
                                                                $$ = ast_new(content->type,vl_new($1->line_number, $1->token_type, strcat(call,$1->token_value)));
                                                                ast_add_child($$, $3);
                                                            }
    | TK_IDENTIFICADOR '(' ')'                              {   
                                                                CONTENT* content  = validate_undeclared(pilha, $1, funcao); 
                                                                $$ = ast_new(content->type,$1); 
                                                            }

argumentos: expressao ',' argumentos                        { $$ = $1; if($3 != NULL) { ast_add_child($$, $3); } }
    | expressao                                             { $$ = $1; }

op_retorno: TK_PR_RETURN expressao                          { $$ = ast_new(notdefined, $1); ast_add_child($$, $2); }

fluxo_ctrl: condicional                                     { $$ = $1; }
    | interativa                                            { $$ = $1; }

condicional: TK_PR_IF '(' expressao ')' cria_escopo bloco_cmd fecha_escopo TK_PR_ELSE cria_escopo bloco_cmd fecha_escopo      { $$ = ast_new(notdefined,$1); ast_add_child($$, $3); if($6 != NULL){ ast_add_child($$, $6); } if($10 != NULL){ ast_add_child($$, $10); } }
    | TK_PR_IF '(' expressao ')' cria_escopo bloco_cmd fecha_escopo                                  { $$ = ast_new(notdefined,$1); ast_add_child($$, $3); if($6 != NULL){ ast_add_child($$, $6); } }

interativa: TK_PR_WHILE '(' expressao ')' cria_escopo bloco_cmd fecha_escopo         { 
                                                                                        $$ = ast_new(notdefined,$1); ast_add_child($$, $3); ast_add_child($$, $6); 
                                                                                    }

expressao: operadores                                       { $$ = $1; }

operandos: TK_IDENTIFICADOR                                 { CONTENT* content  = validate_undeclared(pilha, $1, identificador); $$ = ast_new(content->type,$1); }
    | literais                                               { $$ = $1; }
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

op_pre_1: '-'                                               { $$ = ast_new(notdefined,vl_new(yylineno, 3, "-")); }  
    | '!'                                                   { $$ = ast_new(notdefined,vl_new(yylineno, 3, "!")); } 

op_pre_2: '*'                                               { $$ = ast_new(notdefined,vl_new(yylineno, 3, "*")); }   
    | '/'                                                   { $$ = ast_new(notdefined,vl_new(yylineno, 3, "/")); }   
    | '%'                                                   { $$ = ast_new(notdefined,vl_new(yylineno, 3, "%")); }   

op_pre_3: '+'                                               { $$ = ast_new(notdefined,vl_new(yylineno, 3, "+")); } 
    | '-'                                                   { $$ = ast_new(notdefined,vl_new(yylineno, 3, "-")); } 

op_pre_4: '<'                                               { $$ = ast_new(notdefined,vl_new(yylineno, 3, "<")); } 
    | '>'                                                   { $$ = ast_new(notdefined,vl_new(yylineno, 3, ">")); }   
    | TK_OC_LE                                              { $$ = ast_new(notdefined,$1); }
    | TK_OC_GE                                              { $$ = ast_new(notdefined,$1); }   

op_pre_5: TK_OC_EQ                                          { $$ = ast_new(notdefined,$1); }
    | TK_OC_NE                                              { $$ = ast_new(notdefined,$1); } 

op_pre_6: TK_OC_AND                                         { $$ = ast_new(notdefined,$1); }  

op_pre_7: TK_OC_OR                                          { $$ = ast_new(notdefined,$1); } 

literais: TK_LIT_INT                                         { $$ = ast_new(inteiro,$1); literal_declaration(pilha, $1, inteiro, literal); }
    | TK_LIT_FLOAT                                          { $$ = ast_new(pontoflutuante,$1); literal_declaration(pilha, $1, pontoflutuante, literal); }
    | TK_LIT_FALSE                                          { $$ = ast_new(booleano,$1); literal_declaration(pilha, $1, booleano, literal);}
    | TK_LIT_TRUE                                           { $$ = ast_new(booleano,$1); literal_declaration(pilha, $1, booleano, literal);}                                  

%%
void yyerror (const char *s){
    fprintf(stderr, "Error on line %d: %s\n", yylineno, s);
}