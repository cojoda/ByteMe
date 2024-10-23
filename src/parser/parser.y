%{
    #include <iostream>
    #include <string>

    class AST;
    #include "src/ast/ast.hpp"

    int yparse();
    int yylex(void);

    // debugging
    void yyerror(const char *s);
%}

    // debugging
%define parse.error detailed
%define api.prefix {yy}
%define parse.trace

%union
{
    int              i_val;
    double           d_val;
    std::string*     s_val;
    AST*             ast;
    Program*         prog_ast;
    RoutineGroup*    rout_g_ast;
    Routine*         rout_ast;
    Function*        fun_ast;
    Procedure*       proc_ast;
    StatementGroup*  state_g_ast;
    Statement*       state_ast;
    If_Statement*    if_ast;
    Do_Statement*    do_ast;
    VariableGroup*   var_g_ast;
    Variable*        var_ast;
    Declaration*     dec_ast;
    Return*          ret_ast;
    Arithmetic*      arith_ast;
    Boolean*         bool_ast;
    ExpressionGroup* exp_g_ast;
    Expression*      exp_ast;
    Reference*       ref_ast;
    Atomic*          atomref_ast;
    Array*           arrref_ast;
    Assignment*      assign_ast;
}

    // type keywords
%token K_INTEGER K_DOUBLE K_STRING

    // function keywords
%token K_PROCEDURE K_PROGRAM K_FUNCTION
%token K_READ_INTEGER K_READ_DOUBLE K_READ_STRING
%token K_PRINT_INTEGER K_PRINT_DOUBLE K_PRINT_STRING


    // statement keywords
%token K_DO K_WHILE K_UNTIL

%token    K_IF K_THEN
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
%type  <ast>         start
%type  <prog_ast>    program
%type  <rout_g_ast>  routines
%type  <rout_ast>    routine
%type  <dec_ast>     parameters
%type  <dec_ast>     declaration
%type  <var_g_ast>   variable_list
%type  <var_ast>     variable
%type  <s_val>       type
%type  <state_g_ast> block
%type  <state_g_ast> statements
%type  <state_ast>   statement
%type  <if_ast>      if
%type  <state_ast>   then
%type  <state_ast>   else
%type  <do_ast>      do
%type  <assign_ast>  assignment
%type  <ref_ast>     reference
%type  <var_ast>     binding
%type  <exp_ast>     rvalue
%type  <exp_ast>     arguments
%type  <exp_ast>     expression
%type  <exp_g_ast>   expression_list
%type  <s_val>       builtin
%type  <arith_ast>   arithmetic
%type  <bool_ast>    boolean

    // start variable
%start start

%%

start
    : program                                                   { std::cout << *$1; }
    ;

program
    : K_PROGRAM IDENTIFIER LCURLY routines RCURLY               { $$ = new Program($2, $4); }
    ;


    // functions

routines
    : routines routine                                          { $$ = new RoutineGroup($1, $2); }
    | %empty                                                    { $$ = new RoutineGroup(); }
    ;

routine
    : K_FUNCTION type IDENTIFIER LPAREN parameters RPAREN block { $$ = new Function($2, $3, $5, $7); }
    | K_PROCEDURE IDENTIFIER LPAREN parameters RPAREN block     { $$ = new Procedure($2, $4, $6); }
    ;

parameters
    : declaration                                               { $$ = $1; }
    | %empty                                                    { $$ = nullptr; }
    ;

arguments
    : expression_list                                           { $$ = $1; }
    | %empty                                                    { $$ = nullptr; }
    ;


    // statements

statement
    : block                                                     { $$ = $1; }
    | if                                                        { $$ = $1; }
    | do                                                        { $$ = $1; }
    | expression SEMI                                           { $$ = $1; }
    | declaration SEMI                                          { $$ = $1; }
    | assignment SEMI                                           { $$ = $1; }
    | routine                                                   { $$ = $1; }
    | K_RETURN SEMI                                             { $$ = new Return(); }
    | K_RETURN expression SEMI                                  { $$ = new Return($2); }
    | K_RETURN assignment SEMI                                  { $$ = new Return($2); }
    | SEMI                                                      { $$ = nullptr; }
    ;

block
    : LCURLY statements RCURLY                                  { $$ = $2; }
    ;

statements
    : statements statement                                      { $$ = new StatementGroup($1, $2); }
    | %empty                                                    { $$ = nullptr; }
    ;


    // control statements

if
    : K_IF LPAREN expression RPAREN then %prec LOWER_THAN_ELSE  { $$ = new If_Statement($3, $5); }
    | K_IF LPAREN expression RPAREN then else                   { $$ = new If_Statement($3, $5, $6); }
    ;

then
    : K_THEN statement                                          { $$ = $2; }
    ;

else
    : K_ELSE statement                                          { $$ = $2;}
    ;

do
    : K_DO LPAREN variable SEMI expression SEMI expression RPAREN statement {}  { $$ = new Do_Statement($3, $5, $7, $9); }
    | K_DO K_WHILE LPAREN expression RPAREN statement                           { $$ = new Do_Statement(nullptr, $4, nullptr, $4); }
    | K_DO K_UNTIL LPAREN expression RPAREN statement                           { $$ = new Do_Statement(nullptr, $4, nullptr, $4); }
    ;


    // variables

variable
    : reference                                                 { $$ = $1; }
    | binding                                                   { $$ = $1; }
    ;

variable_list
    : variable                                                  { $$ = new VariableGroup($1); }
    | variable_list COMMA variable                              { $$ = new VariableGroup($1, $3); }
    ;

reference
    : IDENTIFIER LBRACKET RBRACKET                              { $$ = new Array($1); }
    | IDENTIFIER LBRACKET expression RBRACKET                   { $$ = new Array($1, $3); }
    | IDENTIFIER                                                { $$ = new Atomic($1); }
    ;

binding
    : declaration                                               { $$ = $1; }
    | assignment                                                { $$ = $1; }
    ;

assignment
    : reference ASSIGN rvalue                                   { $$ = new Assignment($1, $3, new std::string(":=")); }
    | reference ASSIGN_PLUS rvalue                              { $$ = new Assignment($1, $3, new std::string("+=")); }
    | reference ASSIGN_MINUS rvalue                             { $$ = new Assignment($1, $3, new std::string("-=")); }
    | reference ASSIGN_MULTIPLY rvalue                          { $$ = new Assignment($1, $3, new std::string("*=")); }
    | reference ASSIGN_DIVIDE rvalue                            { $$ = new Assignment($1, $3, new std::string("/=")); }
    | reference ASSIGN_MOD rvalue                               { $$ = new Assignment($1, $3, new std::string("%=")); }
    ;

rvalue
    : expression                                                { $$ = $1; }
    | assignment                                                { $$ = $1; }
    ;

declaration
    : type variable_list                                        { $$ = new Declaration($1, $2); }
    ;

type
    : K_INTEGER                                                 { $$ = new std::string("integer"); }
    | K_DOUBLE                                                  { $$ = new std::string("double"); }
    | K_STRING                                                  { $$ = new std::string("string"); }
    ;


    // expressions

expression
    : arithmetic {}                                             { $$ = $1; }
    | boolean {}                                                { $$ = $1; }
    | builtin LPAREN arguments RPAREN {}                        { $$ = nullptr; }
    | LPAREN expression RPAREN {}                               { $$ = $2 ;}
    | IDENTIFIER LPAREN arguments RPAREN {}                     { $$ = new Array($1, $3);}
    | IDENTIFIER LBRACKET expression RBRACKET                   { $$ = new Array($1, $3); }
    | ICONSTANT                                                 { $$ = new Constant(new int($1)); }
    | DCONSTANT                                                 { $$ = new Constant(new double($1)) ; }
    | SCONSTANT                                                 { $$ = new Constant($1) ; }
    | IDENTIFIER                                                { $$ = new Constant($1) ; }
    ;

expression_list
    : expression                                                { $$ = new ExpressionGroup($1); }
    | expression_list COMMA expression                          { $$ = new ExpressionGroup($1, $3); }
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
    : expression PLUS expression                                { $$ = new Arithmetic($1, $3, new std::string( "+")); }
    | expression MINUS expression                               { $$ = new Arithmetic($1, $3, new std::string( "-")); }
    | expression MULTIPLY expression                            { $$ = new Arithmetic($1, $3, new std::string( "*")); }
    | expression DIVIDE expression                              { $$ = new Arithmetic($1, $3, new std::string( "/")); }
    | expression MOD expression                                 { $$ = new Arithmetic($1, $3, new std::string( "%")); }
    | expression POW expression                                 { $$ = new Arithmetic($1, $3, new std::string( "^")); }
    | expression INCREMENT                                      { $$ = new Arithmetic($1, new std::string( "++")); }
    | expression DECREMENT                                      { $$ = new Arithmetic($1, new std::string( "--")); }
    | MINUS expression                                          { $$ = new Arithmetic($2, new std::string( "-")); }
    ;

    
boolean
    : expression GT expression                                  { $$ = new Boolean($1, $3, new std::string(">")); }
    | expression GEQ expression                                 { $$ = new Boolean($1, $3, new std::string(">=")); }
    | expression LT expression                                  { $$ = new Boolean($1, $3, new std::string("<")); }
    | expression LEQ expression                                 { $$ = new Boolean($1, $3, new std::string("<=")); }
    | expression DEQ expression                                 { $$ = new Boolean($1, $3, new std::string("==")); }
    | expression NE expression                                  { $$ = new Boolean($1, $3, new std::string("!=")); }
    | expression DAND expression                                { $$ = new Boolean($1, $3, new std::string("&&")); }
    | expression DOR expression                                 { $$ = new Boolean($1, $3, new std::string("||")); }
    | NOT expression                                            { $$ = new Boolean($2, new std::string("!")); }
    ;

%%

void yyerror(const char* s)
{
    std::cerr << "Error: " << s << std::endl;
}