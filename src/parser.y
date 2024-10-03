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

%token ICONSTANT DCONSTANT SCONSTANT


%%



%%
