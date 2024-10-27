%{
    #include <iostream>
    #include <string>

    #include "src/parser/ast.hpp"

    int  yparse();
    int  yylex(void);
    void yyerror(const char *s);
%}

%union
{
    int          i_val;
    double       d_val;
    std::string* s_val;
    AST*         ast;
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
%left ":=" "+=" "-=" "*=" "/=" "%="
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
%type <s_val> start program
%type <s_val> routine_block routine parameter_block
%type <s_val> scope statement_block statement
%type <s_val> if then else do assignment
%type <s_val> declaration_block single_declaration multi_declaration
%type <s_val> expression_block expression arithmetic boolean function_call builtin
%type <s_val> reference constant type  

    // start variable
%start start

%%

start
    : program                                                               { }
    ;


program
    : K_PROGRAM IDENTIFIER "{" routine_block "}"                            { }
    ;

routine_block
    : routine_block routine                                                 { }
    | %empty                                                                { }
    ;

routine
    : K_PROCEDURE IDENTIFIER parameter_block scope                          { /* std::cerr << "<procedure:" << *$2 << "(){}>"; */ }
    | K_FUNCTION type IDENTIFIER parameter_block scope                      { /* std::cerr << "<function:" << *$2 << ":" << *$3 << "(){}>";   */}
    ;

parameter_block
    : "(" declaration_block ")"                                     { }
    | "(" ")"                                                       {}
    ;

scope
    : "{" scope_state "}"                                       { }
    ;

scope_state
    : scope_state statement_block {}
    | %empty
    ;

statement_block
    : statement ";"                                                 { }
    | ";"                                                           { }
    | if                                                            { }
    | do                                                            { }
    | scope                                                         { }
    | routine                                                       { }
    ;


statement
    : declaration_block                                              { }
    | expression                                                    { }
    | K_RETURN                                                      { }
    | K_RETURN expression                                            { }
    | %empty                                                        { }
    ;


    // control statements

control_scope
    : statement ";" {}
    | statement if {}
    | scope {}
    

if
    : K_IF "(" expression ")" then %prec LOWER_THAN_ELSE            { }
    | K_IF "(" expression ")" then else                             { }
    ;

then
    : K_THEN control_scope                                              { }
    ;

else
    : K_ELSE control_scope                                              { }
    ;

do
    : K_DO "(" do_init ";" do_express ";" do_express ")" control_scope    { }
    | K_DO K_WHILE "(" expression ")" control_scope                                 { }
    | K_DO K_UNTIL "(" expression ")" control_scope                                 { }
    ;

do_init
    : declaration_block
    | multi_declaration
    | %empty
    ;
do_express
    : expression
    | %empty
    ;


declaration_block
    : type multi_declaration  "," declaration_block               { /* std::cerr << "<" << *$1 << ":" << *$2 << ">";  */}
    | type multi_declaration                                      { /* std::cerr << "<" << *$1 << ":" << *$2 << ">"; */ }
    ;


multi_declaration
    : multi_declaration "," single_declaration                  { }
    | single_declaration                                        { }
    ;

single_declaration
    : reference                                                 { }
    | reference ":=" expression {}
    ;



reference
    : IDENTIFIER                                                { }
    | IDENTIFIER "[" "]"                                        { }
    | IDENTIFIER "[" expression "]"                             { }
    ;


constant
    : ICONSTANT                                                 { }
    | DCONSTANT                                                 { }
    | SCONSTANT                                                 { }
    ;

type
    : K_INTEGER                                                 { }
    | K_DOUBLE                                                  { }
    | K_STRING                                                  { }
    ;



expression
    : arithmetic                                                { }
    | boolean                                               { }
    | function_call                                             { }
    | reference                                                 { }
    | constant                                                  { }
    | "(" expression ")"                                        { }
    | assignment {}
    ;


assignment
    : reference ":=" expression                                 { /* std::cerr << "<" << *$1 << "+=" << *$3 << ">" ; */ }
    | reference "+=" expression                                         {  }
    | reference "-=" expression                                         {  }
    | reference "*=" expression                                         {  }
    | reference "/=" expression                                         {  }
    | reference "%=" expression                                         {  }
    ; 

arithmetic
    : expression "+" expression                                 { /*std::cerr << "<" + *$1 + "+" + *$3 + ">";  */ }
    | expression "-" expression                                     { }
    | expression "*" expression                                     { }
    | expression "/" expression                                     { }
    | expression "%" expression                                     { }
    | expression "^" expression                                     { }
    | expression "++"                                               { }
    | expression "--"                                               { }
    | MINUS expression                                              { }
    ;


boolean
    : expression ">" expression                                     { }
    | expression ">=" expression                                    { }
    | expression "<" expression                                     { }
    | expression "<=" expression                                    { }
    | expression "==" expression                                    { }
    | expression "!=" expression                                    { }
    | expression "&&" expression                                    { }
    | expression "||" expression                                    { }
    | "!" expression                                                { }
    ;


function_call
    : IDENTIFIER "(" expression_block ")"                       { }
    | builtin "(" expression_block ")"                          { }
    ;

expression_block
    : expression_block "," expression                           { }
    | expression                                                { }
    ;


builtin
    : K_PRINT_INTEGER                                               { }
    | K_PRINT_DOUBLE                                                { /* $$ = new std::string("(procedure:print_double"); */ }
    | K_PRINT_STRING                                                { /* $$ = new std::string("(procedure:print_string"); */ }
    | K_READ_INTEGER                                                { /* $$ = new std::string("(procedure:read_integer"); */ }
    | K_READ_DOUBLE                                                 { /* $$ = new std::string("(procedure:read_double"); */ }
    | K_READ_STRING                                                 { /* $$ = new std::string("(procedure:read_string"); */ }
    ;
    ;


%%

void yyerror(const char* s)
{
    std::cerr << "Error: " << s << std::endl;
}