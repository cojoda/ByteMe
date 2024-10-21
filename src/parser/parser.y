%{
    #include <iostream>
    #include <string>
    class AST;  // Forward declaration of AST
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
    Program*     program_node;
    /* Routines*    routines_node;
    Routine*     routine_node; */
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
%token <s_val> IDENTIFIER
%type <ast> start
%type <s_val> program
%type <s_val> routines
%type <s_val> routine
%type <s_val> parameters
%type <s_val> declaration
%type <s_val> variable_list
%type <s_val> variable
%type <s_val> type
%type <s_val> block
%type <s_val> statements
%type <s_val> statement
%type <s_val> if
%type <s_val> then
%type <s_val> else
%type <s_val> do
%type <s_val> for
%type <s_val> assignment
%type <s_val> lvalue
%type <s_val> rvalue
%type <s_val> arguments
%type <s_val> expression
%type <s_val> expression_list
%type <s_val> builtin
%type <s_val> arithmetic
%type <s_val> boolean

%token UNKNOWN

    // start variable
%start start

%%

start
    : program                                                   { std::cout << *$1; }
    ;

program
    : K_PROGRAM IDENTIFIER LCURLY routines RCURLY               { $$ = new std::string("(program:" + *$2 + "\n->" + *$4 + "\n)"); }
    ;


    // functions

routines
    : routines routine                                          { $$ = new std::string(*$1 + "\n->" + *$2); }
    | %empty                                                    { $$ = new std::string("empty"); }
    ;

routine
    : K_FUNCTION type IDENTIFIER LPAREN parameters RPAREN block { $$ = new std::string("(function:" + *$3 + "," + *$5 + ")\n" + "\t->" + *$7); }
    | K_PROCEDURE IDENTIFIER LPAREN parameters RPAREN block     { $$ = new std::string("(procedure:" + *$2 + "," + *$4 + ")\n" + "\t->" + *$6); }
    ;

parameters
    : declaration                                               { $$ = new std::string(*$1); }
    | %empty                                                    { $$ = new std::string("empty"); }
    ;

arguments
    : expression_list                                           { $$ = new std::string(*$1); }
    | %empty                                                    { $$ = new std::string("empty"); }
    ;


    // statements

block
    : LCURLY statements RCURLY                                  { $$ = new std::string("{" + *$2 + "}"); }
    ;

statements
    : statements statement                                      { $$ = new std::string( *$1 + "\n\t\t->" + *$2); }
    | %empty                                                    { $$ = new std::string("empty"); }
    ;

statement
    : block                                                     { $$ = new std::string( *$1 ); }
    | if                                                        { $$ = new std::string(*$1); }
    | do                                                        { $$ = new std::string(*$1); }
    | expression SEMI                                           { $$ = new std::string(*$1 + ";"); }
    | declaration SEMI                                          { $$ = new std::string(*$1); }
    | assignment SEMI                                           { $$ = new std::string("\t\t" + *$1); }
    | routine                                                   { $$ = new std::string(*$1); }
    | K_RETURN SEMI                                             { $$ = new std::string("return;"); }
    | K_RETURN expression SEMI                                  { $$ = new std::string("return (" + *$2 + ");"); }
    | K_RETURN assignment SEMI                                  { $$ = new std::string("return "+ *$2 +";"); }
    | SEMI                                                      { $$ = new std::string(";"); }
    ;


    // control statements

if
    : K_IF LPAREN expression RPAREN then %prec LOWER_THAN_ELSE  { $$ = new std::string("if (" + *$3 + ")" + *$5); }
    | K_IF LPAREN expression RPAREN then else                   { $$ = new std::string("if (" + *$3 + ")" + *$5 + *$6); }
    ;

then
    : K_THEN statement                                          { $$ = new std::string("\n\t\t\tthen:" + *$2); }
    ;

else
    : K_ELSE statement                                          { $$ = new std::string("\n\t\telse:" + *$2); }
    ;

do
    : for { $$ = $1; }
    | K_DO K_WHILE LPAREN expression RPAREN statement           { $$ = new std::string("do while (" + *$4 + ")" + *$6); }
    | K_DO K_UNTIL LPAREN expression RPAREN statement           { $$ = new std::string("do until (" + *$4 + ")" + *$6); }
    ;

for
    : K_DO LPAREN variable SEMI expression SEMI expression RPAREN statement
                                                                { $$ = new std::string("do (" + *$3 + "; " + *$5 + "; " + *$7 + ")" + *$9); }
    ;


    // variables

declaration
    : type variable_list                                        { $$ = new std::string("|" + *$1 + ":" + *$2); }
    ;

variable_list
    : variable                                                  { $$ = new std::string(*$1); }
    | variable_list COMMA variable                              { $$ = new std::string(*$1 + "," + *$3); }
    ;

variable
    : IDENTIFIER LBRACKET RBRACKET                              { $$ = new std::string(*$1 + "[]"); }
    | IDENTIFIER LBRACKET expression RBRACKET                   { $$ = new std::string(*$1 + "[" + *$3 + "]"); }
    | declaration                                               {$$ = new std::string(*$1);}
    | assignment                                                { $$ = new std::string(*$1); }
    | IDENTIFIER                                                { $$ = new std::string(*$1); }
    ;

assignment
    : lvalue ASSIGN rvalue                                      { $$ = new std::string("("+ *$1 + "=" + *$3 + ")"); }
    | lvalue ASSIGN_PLUS rvalue                                 { $$ = new std::string("("+ *$1 + "+=" + *$3 + ")"); }
    | lvalue ASSIGN_MINUS rvalue                                { $$ = new std::string("("+ *$1 + "-=" + *$3 + ")"); }
    | lvalue ASSIGN_MULTIPLY rvalue                             { $$ = new std::string("("+ *$1 + "*=" + *$3 + ")"); }
    | lvalue ASSIGN_DIVIDE rvalue                               { $$ = new std::string("("+ *$1 + "/=" + *$3 + ")"); }
    | lvalue ASSIGN_MOD rvalue                                  { $$ = new std::string("("+ *$1 + "%=" + *$3 + ")"); }
    ;

lvalue
    : IDENTIFIER                                                { $$ = new std::string(*$1); }
    | IDENTIFIER LBRACKET expression RBRACKET                   { $$ = new std::string(*$1 + "[" + *$3 + "]"); }
    | IDENTIFIER LBRACKET RBRACKET                              { $$ = new std::string(*$1 + "[]"); }
    ;

rvalue
    : expression                                                { $$ = new std::string(*$1); }
    | assignment                                                { $$ = new std::string(*$1); }
    ;

type
    : K_INTEGER                                                 { $$ = new std::string("integer"); }
    | K_DOUBLE                                                  { $$ = new std::string("double"); }
    | K_STRING                                                  { $$ = new std::string("string"); }
    ;


    // expressions

expression
    : arithmetic {}                                             { $$ = new std::string("(" + *$1 + ")"); }
    | boolean {}                                                { $$ = new std::string("(" + *$1 + ")"); }
    | builtin LPAREN arguments RPAREN {}                        { $$ = new std::string("(" + *$1 + "|" + *$3 + ")"); }
    | LPAREN expression RPAREN {}                               { $$ = new std::string("(" + *$2 + ")"); }
    | IDENTIFIER LPAREN arguments RPAREN {}                     { $$ = new std::string("(" + *$1 + "(" + *$3 + "))"); }
    | IDENTIFIER LBRACKET expression RBRACKET                   { $$ = new std::string("(" + *$1 + "[" + *$3 + "])"); }
    | ICONSTANT                                                 { $$ = new std::string(std::to_string($1)); }
    | DCONSTANT                                                 { $$ = new std::string(std::to_string($1)); }
    | SCONSTANT                                                 { $$ = new std::string(*$1); }
    | IDENTIFIER                                                { $$ = new std::string(*$1); }
    ;

expression_list
    : expression                                                { $$ = new std::string(*$1); }
    | expression_list COMMA expression                          { $$ = new std::string(*$1 + ", " + *$3); }
    ;

builtin
    : K_PRINT_INTEGER                                           { $$ = new std::string("(procedure:print_integer"); }
    | K_PRINT_DOUBLE                                            { $$ = new std::string("(procedure:print_double"); }
    | K_PRINT_STRING                                            { $$ = new std::string("(procedure:print_string"); }
    | K_READ_INTEGER                                            { $$ = new std::string("(procedure:read_integer"); }
    | K_READ_DOUBLE                                             { $$ = new std::string("(procedure:read_double"); }
    | K_READ_STRING                                             { $$ = new std::string("(procedure:read_string"); }
    ;

arithmetic
    : expression PLUS expression                                { $$ = new std::string(*$1 + "+" + *$3); }
    | expression MINUS expression                               { $$ = new std::string(*$1 + "-" + *$3); }
    | expression MULTIPLY expression                            { $$ = new std::string(*$1 + "*" + *$3); }
    | expression DIVIDE expression                              { $$ = new std::string(*$1 + "/" + *$3); }
    | expression MOD expression                                 { $$ = new std::string(*$1 + "%" + *$3); }
    | expression POW expression                                 { $$ = new std::string(*$1 + "^" + *$3); }
    | expression INCREMENT                                      { $$ = new std::string(*$1 + "++"); }
    | expression DECREMENT                                      { $$ = new std::string(*$1 + "--"); }
    | MINUS expression                                          { $$ = new std::string("-" + *$2); }
    ;

boolean
    : expression GT expression                                  { $$ = new std::string(*$1 + ">" + *$3); }
    | expression GEQ expression                                 { $$ = new std::string(*$1 + ">=" + *$3); }
    | expression LT expression                                  { $$ = new std::string(*$1 + "<" + *$3); }
    | expression LEQ expression                                 { $$ = new std::string(*$1 + "<=" + *$3); }
    | expression DEQ expression                                 { $$ = new std::string(*$1 + "==" + *$3); }
    | expression NE expression                                  { $$ = new std::string(*$1 + "!=" + *$3); }
    | expression DAND expression                                { $$ = new std::string(*$1 + "&&" + *$3); }
    | expression DOR expression                                 { $$ = new std::string(*$1 + "||" + *$3); }
    | NOT expression                                            { $$ = new std::string("!" + *$2); }
    ;

%%

void yyerror(const char* s)
{
    std::cerr << "Error: " << s << std::endl;
}