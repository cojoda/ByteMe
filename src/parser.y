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
    int intval;


}

%token K_INTEGER K_DOUBLE K_STRING
%token K_READ_INTEGER K_READ_DOUBLE K_READ_STRING
%token K_PRINT_INTEGER K_PRINT_DOUBLE K_PRINT_STRING
%token K_PROCEDURE K_PROGRAM K_FUNCTION
%token K_DO K_WHILE K_UNTIL K_THEN
%token K_RETURN K_EXIT
%token K_IF K_ELSE

%token PLUS INCREMENT MINUS DECREMENT MULTIPLY DIVIDE MOD
%token DOR DAND NOT DEQ GEQ GT LEQ LT NE

%token ASSIGN_PLUS ASSIGN_MINUS ASSIGN_MULTIPLY ASSIGN_DIVIDE ASSIGN_MOD

%token PERIOD SEMI LBRACKET RBRACKET LCURLY RCURLY LPAREN RPAREN COMMA

%token ICONSTANT DCONSTANT
%token <varname> SCONSTANT
%token <varname> IDENTIFIER



%%
program: //program contains a name and at least one function, first node
    K_PROGRAM IDENTIFIER LCURLY function RCURLY
    {

    } |
    {
        //todo, this would be an error
    }
;
builtin_func_input: //input functions
    K_READ_INTEGER LPAREN IDENTIFIER RPAREN SEMI {

    } |
    K_READ_DOUBLE LPAREN IDENTIFIER RPAREN SEMI {

    } |
    K_READ_STRING LPAREN IDENTIFIER RPAREN SEMI {

    }
;
builtin_func_output: //output functions
    K_PRINT_INTEGER LPAREN IDENTIFIER RPAREN SEMI {

    } |
    K_PRINT_DOUBLE LPAREN IDENTIFIER RPAREN SEMI {

    } |
    K_PRINT_STRING LPAREN IDENTIFIER RPAREN SEMI {

    }

;
vardec: //variable declaration
    K_INTEGER IDENTIFIER SEMI {

    } |
    K_DOUBLE IDENTIFIER SEMI {

    } |
    K_STRING IDENTIFIER SEMI {

    }
;
function: //function contains expressions
    K_FUNCTION K_INTEGER IDENTIFIER LPAREN RPAREN LCURLY expressions RCURLY {

    }
;
expressions: //one or more expressions
    | expression SEMI expressions

;

expression:
    vardec {

    } |
    builtin_func_input {

    } |
    builtin_func_output {

    } |
    exp_assign {

    }

;
exp_assign: //type checking will need to happen here!


;



%%
