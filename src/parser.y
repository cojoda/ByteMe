%{
#include <stdio.h>
#include <FlexLexer.h>
#include "token.h"
#include "operation.h"
#include "keyword.h"
#include "punctuation.h"

using std::endl;
using std::cerr;
using std::cout;


int yyerror(char *s);
int nodenum = 1;

extern yyFlexLexer *scanner;

#define yylex() scanner->yylex()

%}

%union {
    char varname[40]; //length of 40 characters for var names
    int ival;
    double dval;
    //todo string value, maybe import the C++ string class?
}

%token K_INTEGER K_DOUBLE K_STRING
%token K_READ_INTEGER K_READ_DOUBLE K_READ_STRING
%token K_PRINT_INTEGER K_PRINT_DOUBLE K_PRINT_STRING
%token K_PROCEDURE K_PROGRAM K_FUNCTION
%token K_DO K_WHILE K_UNTIL K_THEN
%token K_RETURN K_EXIT
%token K_IF K_ELSE

%left PLUS MINUS MULTIPLY DIVIDE MOD

%token INCREMENT DECREMENT
%token DOR DAND NOT DEQ GEQ GT LEQ LT NE

%token ASSIGN_PLUS ASSIGN_MINUS ASSIGN_MULTIPLY ASSIGN_DIVIDE ASSIGN_MOD

%token PERIOD SEMI LBRACKET RBRACKET LCURLY RCURLY LPAREN RPAREN COMMA

%token ICONSTANT DCONSTANT
%token <varname> SCONSTANT
%token <varname> IDENTIFIER
%token <varname> DCONSTANT
%token <varname> ICONSTANT

%start program

%%
    //program contains a name and at least one function, first node
program
    : K_PROGRAM IDENTIFIER LCURLY function RCURLY
    {
        cout << "Program start.\n";
        $$ = $1;
    } 
    |
    {
        cout << "Parsing error.\n";
    }
;
    //input functions
builtin_func_input
    : K_READ_INTEGER LPAREN IDENTIFIER RPAREN SEMI
    {

    }
    | K_READ_DOUBLE LPAREN IDENTIFIER RPAREN SEMI
    {

    }
    | K_READ_STRING LPAREN IDENTIFIER RPAREN SEMI
    {

    }
;
    //output functions
builtin_func_output
    : K_PRINT_INTEGER LPAREN IDENTIFIER RPAREN SEMI
    {

    }
    | K_PRINT_DOUBLE LPAREN IDENTIFIER RPAREN SEMI
    {

    }
    | K_PRINT_STRING LPAREN IDENTIFIER RPAREN SEMI
    {

    }

;
    //variable declaration
vardec
    : K_INTEGER IDENTIFIER SEMI
    {
        cout << "Declared integer.\n";
        $$ = $1;
    }
    | K_DOUBLE IDENTIFIER SEMI
    {
        cout << "Declared double.\n";
        $$ = $1;
    }
    | K_STRING IDENTIFIER SEMI
    {
        cout << "Declared string.\n";
        $$ = $1;
    }
;
    //function contains expressions
function
    : K_FUNCTION K_INTEGER IDENTIFIER LPAREN RPAREN LCURLY expressions RCURLY
    {
        //$$ = $1;
        cout << "Integer function declared.\n";
    }
    | K_FUNCTION K_DOUBLE IDENTIFIER LPAREN RPAREN LCURLY expressions RCURLY
    {
        //$$ = $1;
        cout << "Double function declared.\n";
    }
    | K_FUNCTION K_STRING IDENTIFIER LPAREN RPAREN LCURLY expressions RCURLY
    {
        //$$ = $1;
        cout << "String function declared.\n";
    }
;
    //one or more expressions, we do NOT need to have any code here
expressions
    :
    | expression SEMI expressions

;

expression
    : vardec
    {
        cout << "Variable declaration.\n";
        $$ = $1;
    }
    | builtin_func_input
    {

    }
    | builtin_func_output
    {

    }
    | exp_assign
    {

    }

;
exp_assign: //type checking will need to happen here!


;



%%
