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

%token K_IF K_THEN
%nonassoc LOWER_THAN_ELSE
%nonassoc K_ELSE

%token K_RETURN K_EXIT


    // operators

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
    : declaration_list
;

declaration_list
    : declaration_list declaration
    | %empty
;

declaration
    : type variable_list
;

variable_list
    : variable
    | variable_list COMMA variable
;

variable
    : declaration
    | IDENTIFIER
    | IDENTIFIER ASSIGN expression
;

type
    : K_INTEGER {}
    | K_DOUBLE {}
    | K_STRING {}
;

expression
    : arithmetic {}
    | boolean {}
    | ICONSTANT {}
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
;



%%



void yyerror(const char* s)
{
    std::cerr << "Error: " << s << std::endl;
}