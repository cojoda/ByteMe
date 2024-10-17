%{
    // Include necessary header files
    #include <string>
    #include <string.h>

    #include "keyword.hpp"
    #include "operation.hpp"
    #include "punctuation.hpp"
    
    #include "../parser/parser.hpp"

    // extern int yylval;

    // Macros for lexer output testing
    #define TOKEN1(arg1)        yyout << "<" << arg1 << ">";
    #define TOKEN2(arg1, arg2)  yyout << "<" << arg1 << "," << arg2 << ">";
    #define GET_TOKEN(_1, _2, NAME, ...) NAME
    #define TOKEN(...)                   GET_TOKEN(__VA_ARGS__, TOKEN2, TOKEN1) (__VA_ARGS__)
%}



%option noyywrap
%option c++
/* %option prefix="Byte" */



/* Character Class Macros */
a       [a-zA-Z]
EXP     [dD]
s       [ \t\n\r\f\v]
S       [^ \t\n\r\f\v]
w       [a-zA-Z0-9_]
W       [^a-zA-Z0-9_]
d       [0-9]
D       [^0-9]
OP1     [-+*/%=|&!><:]
OP2     [-+=|&]
PUN     [.;\[\]{}(),]



%%



    /* Comments */
\/\/.*\n                                        { } 



    /* Whitespace */
{s}+                                            { }



    /* String Constants */
[\"][^\"]*[\"]                                  { yylval.s_val = new std::string(yytext, yyleng); return SCONSTANT; }



    /* Integer Constants */
{d}+                                            { yylval.i_val = atoi(yytext); return ICONSTANT; }



    /* Floating-point Constants */
(({d}+\.?{d}*)|({d}*\.?{d}+))({EXP}[-+]?{d}+)?  { yylval.d_val = atof(yytext); return DCONSTANT; }



    /* Operators */
{OP1}{OP2}?                 {
    int token = operation_to_token((std::string)yytext);
    return token;
}



    /* Punctuation */
{PUN}                       {
    int token = punctuation_to_token((std::string)yytext);
    return token;
}



    /* Keywords & Identifiers */
({a}|[_$])({w}|[$])*        { 
    int token = keyword_to_token((std::string)yytext);
    
    if (token == IDENTIFIER) {
        strncpy(yylval.id_val, yytext, sizeof(yylval.id_val) - 1);
        yylval.id_val[sizeof(yylval.id_val) - 1] = '\0'; 
    }

    return token;
}



    /* End of File */
<<EOF>>             { ; return EOF; return 0; }



%%
