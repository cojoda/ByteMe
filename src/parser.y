%{
#include <FlexLexer.h>
#include <iostream>
#include <string>

extern yyFlexLexer* flexlexer;      // Declare the flexlexer instance
#define yylex() flexlexer->yylex()  // Define yylex() as a call to the flexlexer->yylex method

void yyerror(const char *s);



// int nodenum = 1;

%}



/* %define api.parser.class  {ByteParser}
%define api.namespace {yy} */

%debug

%union
{
    int          i_val;
    double       d_val;
    std::string* s_val;
    char         id_val[33];
}

    // type keywords
%token K_INTEGER K_DOUBLE K_STRING

    // function keywords
%token K_PROCEDURE K_PROGRAM K_FUNCTION
%token K_READ_INTEGER K_READ_DOUBLE K_READ_STRING
%token K_PRINT_INTEGER K_PRINT_DOUBLE K_PRINT_STRING

    // statement keywords
%token K_DO K_WHILE K_UNTIL
%token K_IF K_THEN K_ELSE
%token K_RETURN K_EXIT

    // arithmetic operators
%left  PLUS MINUS MULTIPLY DIVIDE MOD POW
%token INCREMENT DECREMENT

    // boolean operators
%token DOR DAND NOT DEQ GEQ GT LEQ LT NE

    // assignment statements
%token ASSIGN_PLUS ASSIGN_MINUS ASSIGN_MULTIPLY ASSIGN_DIVIDE ASSIGN_MOD ASSIGN

    // punctuation
%token PERIOD SEMI LBRACKET RBRACKET LCURLY RCURLY LPAREN RPAREN COMMA

    // terms
%token <i_val> ICONSTANT
%token <d_val> DCONSTANT
%token <s_val> SCONSTANT
%token <id_val> IDENTIFIER


%token UNKNOWN

    // start variable
%start declarations




%%

start
    : program {}
;

program
    : K_PROGRAM IDENTIFIER LCURLY routines RCURLY {}
    | %empty {}
;

routines
    : routines routine
    | %empty {}
;

routine
    : K_FUNCTION type IDENTIFIER LPAREN parameters RPAREN block {}
    | K_PROCEDURE IDENTIFIER LPAREN parameters RPAREN block {}
;

parameters
    : declarations {}
    | %empty {}
;

arguments
    : argument {}
    | %empty {}
;

argument
    : argument COMMA argument {}
    | expression {}
;

block
    : LCURLY statements RCURLY {}
;

statements
    : statements statement {}
    | %empty {}
;

statement
    : block {}
    | if {}
    | do {}
    | expression SEMI {}
    | declarations SEMI {}
    | assignment SEMI {}
    | routine {}
    | K_RETURN SEMI {}
    | K_RETURN expression SEMI {}
    | K_RETURN assignment SEMI {}
    | SEMI {}
;

if
    : K_IF LPAREN expression RPAREN then {}
    | K_IF LPAREN expression RPAREN then else {}
;

then
    : K_THEN statement {}
;

else
    : K_ELSE statement {}
    | K_ELSE if then {}
;

do
    : for
    | K_DO K_WHILE LPAREN expression RPAREN statement {}
    | K_DO K_UNTIL LPAREN expression RPAREN statement {}


for
    : K_DO LPAREN assignment SEMI boolean SEMI expression RPAREN statement {}
;


variables
    : variables COMMA variable {}
    | variable {}
;

variable
    : IDENTIFIER {}
    | array {}
;

declarations
    : declarations COMMA declaration {}
    | declaration {}
;

declaration
    : type variables {}
;

assignment
    : lvalue ASSIGN expression {}
    | lvalue ASSIGN_PLUS expression {}
    | lvalue ASSIGN_MINUS expression {}
    | lvalue ASSIGN_MULTIPLY expression {}
    | lvalue ASSIGN_DIVIDE expression {}
    | lvalue ASSIGN_MOD expression {}
;

lvalue
    : variable {}
    | declaration {}
;

array
    : IDENTIFIER LBRACKET expression RBRACKET {}
    | IDENTIFIER LBRACKET RBRACKET {}
;

type
    : K_INTEGER {}
    | K_DOUBLE {}
    | K_STRING {}
;



expression
    : LPAREN expression RPAREN {}
    | IDENTIFIER LBRACKET expression RBRACKET {}
    | IDENTIFIER LPAREN arguments RPAREN {}
    | arithmetic {}
    | boolean {}
    | constant {}
;

constant
    : ICONSTANT {}
    | DCONSTANT {}
    | SCONSTANT {}
    | IDENTIFIER {}
;

arithmetic
    : expression PLUS expression {}
    | expression MINUS expression {}
    | expression MULTIPLY expression {}
    | expression DIVIDE expression {}
    | expression MOD expression {}
    | expression POW expression {}
    | expression INCREMENT {}
    | expression DECREMENT {}
    | MINUS expression {}
;

boolean
    : expression GT expression {}
    | expression GEQ expression {}
    | expression LT expression {}
    | expression LEQ expression {}
    | expression DEQ expression {}
    | expression NE expression {}
    | expression DAND expression {}
    | expression DOR expression {}
    | NOT expression {}
%%



void yyerror(const char* s)
{
    std::cerr << "Error: " << s << std::endl;
}