%{



#include <FlexLexer.h>
#include <iostream>
#include <string>

extern yyFlexLexer* flexlexer;
#define yylex() flexlexer->yylex()

void yyerror(const char *s);



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

%token K_IF K_THEN
%nonassoc LOWER_THAN_ELSE
%nonassoc K_ELSE

%token K_RETURN K_EXIT


    // operators (using C precedence & associavity)
%left  COMMA
%right ASSIGN ASSIGN_PLUS ASSIGN_MINUS ASSIGN_MULTIPLY ASSIGN_DIVIDE ASSIGN_MOD
%left  DOR
%left  DAND
%left  DEQ NE
%left  LT LEQ GT GEQ
%left  PLUS MINUS
%left  MULTIPLY DIVIDE MOD
%right POW
%right NOT
%left  PERIOD
%left  LBRACKET RBRACKET
%left  LPAREN RPAREN
%left  INCREMENT DECREMENT


    // punctuation
%token SEMI LCURLY RCURLY


    // terms
%token <i_val> ICONSTANT
%token <d_val> DCONSTANT
%token <s_val> SCONSTANT
%token <id_val> IDENTIFIER


%token UNKNOWN



    // start variable
%start start



%%



start
    : program {}
    ;

program
    : K_PROGRAM IDENTIFIER LCURLY routines RCURLY {}
    | %empty {}
    ;


    // functions

routines
    : routines routine {}
    | %empty {}
    ;

routine
    : K_FUNCTION type IDENTIFIER LPAREN parameters RPAREN block {}
    | K_PROCEDURE IDENTIFIER LPAREN parameters RPAREN block {}
    ;

parameters
    : declaration {}
    | %empty {}
    ;

arguments
    : expression_list
    | %empty
    ;


    // statements

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
    | expression SEMI
    | declaration SEMI
    | assignment SEMI
    | routine
    | K_RETURN SEMI {}
    | K_RETURN expression SEMI {}
    | K_RETURN assignment SEMI {}
    | SEMI
    ;


    // control statements
if
    : K_IF LPAREN expression RPAREN then %prec LOWER_THAN_ELSE
    | K_IF LPAREN expression RPAREN then else
    ;

then
    : K_THEN statement
    ;

else
    : K_ELSE statement
    ;

do
    : for {}
    | K_DO K_WHILE LPAREN expression RPAREN statement {}
    | K_DO K_UNTIL LPAREN expression RPAREN statement {}
    ;

for
    : K_DO LPAREN variable SEMI expression SEMI expression RPAREN statement {}
    ;


    // variables

declaration
    : type variable_list
    ;

variable_list
    : variable
    | variable_list COMMA variable
    ;

variable
    : IDENTIFIER LBRACKET RBRACKET
    | IDENTIFIER LBRACKET expression RBRACKET
    | declaration
    | assignment
    | IDENTIFIER
    ;

assignment
    : lvalue ASSIGN rvalue
    | lvalue ASSIGN_PLUS rvalue
    | lvalue ASSIGN_MINUS rvalue
    | lvalue ASSIGN_MULTIPLY rvalue
    | lvalue ASSIGN_DIVIDE rvalue
    | lvalue ASSIGN_MOD rvalue
    ;

lvalue
    : IDENTIFIER
    | IDENTIFIER LBRACKET expression RBRACKET
    | IDENTIFIER LBRACKET RBRACKET
    ;

rvalue
    : expression
    | assignment
    ;

type
    : K_INTEGER {}
    | K_DOUBLE {}
    | K_STRING {}
    ;


    // expressions

expression
    : arithmetic {}
    | boolean {}
    | builtin LPAREN arguments RPAREN {}
    | LPAREN expression RPAREN {}
    | IDENTIFIER LPAREN arguments RPAREN {}
    | IDENTIFIER LBRACKET expression RBRACKET
    | ICONSTANT {}
    | DCONSTANT {}
    | SCONSTANT {}
    | IDENTIFIER {}
    ;

expression_list
    : expression
    | expression_list COMMA expression
    ;

builtin
    : K_PRINT_INTEGER
    | K_PRINT_DOUBLE
    | K_PRINT_STRING
    | K_READ_INTEGER
    | K_READ_DOUBLE
    | K_READ_STRING
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
    ;



%%



void yyerror(const char* s)
{
    std::cerr << "Error: " << s << std::endl;
}
