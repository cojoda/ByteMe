%{
    #include <iostream>
    #include <string>

    #include "src/ast/ast.hpp"

    int  yparse();
    int  yylex(void);
    void yyerror(const char *s);
%}

%union
{
    int           i_val;
    double        d_val;
    std::string*  s_val;
    Node*                          node_ast;
    Program*                       program_ast;
    Routine*                       routine_ast;
    Block<Routine*,    Node>*      routine_block;
    Block<Expression*, Node>*      expression_block_ast;
    Block<UniDec*,     Statement>* unidec_block_ast;
    Block<Declaration*,Statement>* polytypedec_ast;
    Block<Statement*,  Statement>* state_block;
    Expression*                    expression_ast;
    Reference*                     reference_ast;
    UniDec*                        unidec_ast;
    Statement*                     state_ast;
}
    // type keywords
%token    K_INTEGER K_DOUBLE K_STRING

    // function keywords
%token    K_PROCEDURE      K_PROGRAM       K_FUNCTION
%token    K_READ_INTEGER   K_READ_DOUBLE   K_READ_STRING
%token    K_PRINT_INTEGER  K_PRINT_DOUBLE  K_PRINT_STRING

    // statement keywords
%token    K_DO K_WHILE K_UNTIL

%token    K_IF K_THEN
%nonassoc LOWER_THAN_ELSE
%nonassoc K_ELSE

%token K_RETURN K_EXIT

%token COMMA ","
%token ASSIGN ":=" ASSIGN_PLUS "+=" ASSIGN_MINUS "-=" ASSIGN_MULTIPLY "*=" ASSIGN_DIVIDE "/=" ASSIGN_MOD "%="
%token DOR "||" DAND "&&" DEQ "==" NE "!=" NOT "!"
%token LT "<" LEQ "<=" GT ">" GEQ ">="
%token PLUS "+" MINUS "-" MULTIPLY "*" DIVIDE "/" MOD "%" POW "^" INCREMENT "++" DECREMENT "--"
%token PERIOD "." LBRACKET "[" RBRACKET "]" LPAREN "(" RPAREN ")"

    // operators (using C precedence & associavity)
%left  ","
%left  ":=" "+=" "-=" "*=" "/=" "%="
%left  "||"
%left  "&&"
%left  "==" "!="
%left  "<" "<=" ">" ">="
%left  "+" "-"
%left  "*" "/" "%"
%right "^"
%right "!"
%left  "."
%left  "[" "]"
%left  "(" ")"
%left  "++" "--"

    // punctuation
%token SEMI ";"
%token LCURLY "{" RCURLY "}"

    // terms
%token <i_val> ICONSTANT
%token <d_val> DCONSTANT
%token <s_val> SCONSTANT IDENTIFIER
%type  <s_val> start
%type  <s_val> type builtin

%type <polytypedec_ast> polytype_declaration parameter_list
%type <unidec_block_ast> uni_declaration_list
%type <unidec_ast> uni_declaration
%type <reference_ast> reference

%type <program_ast> program
%type <routine_block> routine_list
%type <routine_ast> routine

%type <state_ast> statement statement_scope control_scope if then else do do_init
%type <state_block> statement_scope_list scope

%type <expression_ast> expression arithmetic boolean routine_call assignment constant do_express
%type <expression_block_ast> expression_block

    // start variable
%start start

%%

start
    : program                                                           { std::cerr << *$1 << std::endl;}
    ;


program
    : K_PROGRAM IDENTIFIER "{" routine_list "}"                         { $$ = new Program($2, $4); }
    ;


    /* Routines */

routine_list
    : routine_list routine                                              { $$ = new Block<Routine*, Node>($1, $2); }
    | %empty                                                            { $$ = new Block<Routine*, Node>(); }
    ;


routine
    : K_PROCEDURE IDENTIFIER parameter_list scope                      { $$ = new Routine($2, $3, $4); }
    | K_FUNCTION type IDENTIFIER parameter_list scope                  { $$ = new Routine($3, $4, $5, $2); }
    ;


    /* Variables */

parameter_list
    : "(" polytype_declaration ")"                                      { $$ = $2; }
    | "(" ")"                                                           { $$ = new Block<Declaration*, Statement>(); }
    ;

polytype_declaration
    : type uni_declaration_list "," polytype_declaration                { $$ = new Block<Declaration*,Statement>( $4, new Declaration($1, $2) ); }
    | type uni_declaration_list                                         { $$ = new Block<Declaration*,Statement>( new Declaration($1, $2) ); }
    ;

uni_declaration_list
    : uni_declaration_list "," uni_declaration                          { $$ = new Block<UniDec*,Statement>($1, $3); }
    | uni_declaration                                                   { $$ = new Block<UniDec*,Statement>($1); }
    ;

uni_declaration
    : reference                                                         { $$ = new UniDec($1); }
    | reference ":=" expression                                         { $$ = new UniDec($1, $3); }
    ;

reference
    : IDENTIFIER                                                        { $$ = new Reference($1); }
    | IDENTIFIER "[" "]"                                                { $$ = new Reference($1); }
    | IDENTIFIER "[" expression "]"                                     { $$ = new Reference($1, $3); }
    ;

constant
    : ICONSTANT                                                         { $$ = new Constant(new std::string("ICONST")); }
    | DCONSTANT                                                         { $$ = new Constant(new std::string("DCONST")); }
    | SCONSTANT                                                         { $$ = new Constant(new std::string("SCONST")); }
    ;

type
    : K_INTEGER                                                         { $$ = new std::string("integer"); }
    | K_DOUBLE                                                          { $$ = new std::string("double"); }
    | K_STRING                                                          { $$ = new std::string("string"); }
    ;


    /* Scope */

scope
    : "{" statement_scope_list "}"                                      { $$ = $2; }
    ;

statement_scope_list
    : statement_scope_list statement_scope                              { $$ = new Block<Statement*,Statement>($1, $2); }
    | %empty                                                            { $$ = new Block<Statement*,Statement>(); }
    ;


    // statement wrapper
statement_scope
    : statement ";"                                                     { $$ = $1; }
    | if                                                                { $$ = $1; }
    | do                                                                { $$ = $1; }
    | scope                                                             { $$ = $1; }
    | routine                                                           { $$ = $1; }
    ;


statement
    : polytype_declaration                                              { $$ = $1; }
    | expression                                                        { $$ = $1; }
    | K_RETURN                                                          { $$ = new Return(); }
    | K_RETURN expression                                               { $$ = new Return($2); }
    | %empty                                                            { $$ = nullptr; }
    ;


    /* Control */

control_scope
    : statement ";"                                                     { $$ = $1; }
    | statement if                                                      { $$ = $1; }
    | scope                                                             { $$ = $1; }
    ;

if
    : K_IF "(" expression ")" then %prec LOWER_THAN_ELSE                { $$ = new IfStatement($3, $5); }
    | K_IF "(" expression ")" then else                                 { $$ = new IfStatement($3, $5, $6); }
    ;

then
    : K_THEN control_scope                                              { $$ = $2; }
    ;

else
    : K_ELSE control_scope                                              { $$ = $2; }
    ;

do
    : K_DO "(" do_init ";" do_express ";" do_express ")" control_scope  { $$ = new DoStatement($3, $5, $7, $9); }
    | K_DO K_WHILE "(" expression ")" control_scope                     { $$ = new WhileStatement($4, $6); }
    | K_DO K_UNTIL "(" expression ")" control_scope                     { $$ = new WhileStatement($4, $6);}
    ;

do_init
    : polytype_declaration                                              { $$ = $1; }
    | uni_declaration_list                                              { $$ = $1; }
    | %empty                                                            { $$ = nullptr; }
    ;

do_express
    : expression                                                        { $$ = $1; }
    | %empty                                                            { $$ = nullptr; }
    ;


    /* Expressions */

expression
    : arithmetic                                                        { $$ = $1; }
    | boolean                                                           { $$ = $1; }        
    | routine_call                                                      { $$ = $1; }
    | reference                                                         { $$ = $1; }
    | constant                                                          { $$ = $1; }
    | "(" expression ")"                                                { $$ = $2; }
    | assignment                                                        { $$ = $1; }
    ;


assignment
    : reference ":=" expression                                         { $$ = new Assignment($1, new std::string(":="), $3); }
    | reference "+=" expression                                         { $$ = new Assignment($1, new std::string("+="), $3); }
    | reference "-=" expression                                         { $$ = new Assignment($1, new std::string("-="), $3); }
    | reference "*=" expression                                         { $$ = new Assignment($1, new std::string("*="), $3); }
    | reference "/=" expression                                         { $$ = new Assignment($1, new std::string("/="), $3); }
    | reference "%=" expression                                         { $$ = new Assignment($1, new std::string("%="), $3); }
    ; 

arithmetic
    : expression "+" expression                                         { $$ = new BinaryOp($1, new std::string("+"), $3); }
    | expression "-" expression                                         { $$ = new BinaryOp($1, new std::string("-"), $3); }
    | expression "*" expression                                         { $$ = new BinaryOp($1, new std::string("*"), $3); }
    | expression "/" expression                                         { $$ = new BinaryOp($1, new std::string("/"), $3); }
    | expression "%" expression                                         { $$ = new BinaryOp($1, new std::string("%"), $3); }
    | expression "^" expression                                         { $$ = new BinaryOp($1, new std::string("^"), $3); }
    | expression "++"                                                   { $$ = new UnaryOp(new std::string("++"), $1); }
    | expression "--"                                                   { $$ = new UnaryOp(new std::string("--"), $1); }
    | "-" expression                                                    { $$ = new UnaryOp(new std::string("-"), $2); }
    ;

boolean
    : expression ">" expression                                         { $$ = new BinaryOp($1, new std::string(">"), $3); }
    | expression ">=" expression                                        { $$ = new BinaryOp($1, new std::string(">="), $3); }
    | expression "<" expression                                         { $$ = new BinaryOp($1, new std::string("<"), $3); }
    | expression "<=" expression                                        { $$ = new BinaryOp($1, new std::string("<="), $3); }
    | expression "==" expression                                        { $$ = new BinaryOp($1, new std::string("=="), $3); }
    | expression "!=" expression                                        { $$ = new BinaryOp($1, new std::string("!="), $3); }
    | expression "&&" expression                                        { $$ = new BinaryOp($1, new std::string("&&"), $3); }
    | expression "||" expression                                        { $$ = new BinaryOp($1, new std::string("||"), $3); }
    | "!" expression                                                    { $$ = new UnaryOp(new std::string("!"), $2); }
    ;

routine_call
    : IDENTIFIER "(" expression_block ")"                               { $$ = new RoutineCall($1, $3); }
    | builtin "(" expression_block ")"                                  { $$ = new RoutineCall($1, $3); }
    ;

expression_block
    : expression_block "," expression                                   { $$ = new Block<Expression*,Node>($1, $3); }
    | expression                                                        { $$ = new Block<Expression*,Node>($1); }
    ;

builtin
    : K_PRINT_INTEGER                                                   { $$ = new std::string("print_integer"); }
    | K_PRINT_DOUBLE                                                    { $$ = new std::string("print_double"); }
    | K_PRINT_STRING                                                    { $$ = new std::string("print_string"); }
    | K_READ_INTEGER                                                    { $$ = new std::string("read_integer"); }
    | K_READ_DOUBLE                                                     { $$ = new std::string("read_double"); }
    | K_READ_STRING                                                     { $$ = new std::string("read_string"); }
    ;

%%

void yyerror(const char* s)
{
    std::cerr << "Error: " << s << std::endl;
}
