%{
// #include <iostream>
// #include <fstream>
#include "keyword.h"
#include "operation.h"
#include "punctuation.h"
#include "token.h"


// extern std::ofstream lex_ofstream;

#define TOKEN1(arg1)        yyout << "<" << arg1 << ">";
#define TOKEN2(arg1, arg2)  yyout << "<" << arg1 << "," << arg2 << ">";
#define GET_TOKEN(_1, _2, NAME, ...) NAME
#define TOKEN(...) GET_TOKEN(__VA_ARGS__, TOKEN2, TOKEN1) (__VA_ARGS__)
%}



%option noyywrap
%option c++
%option prefix="Byte"



ALPHA   [a-zA-Z]
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



    /* comments */
\/\/.*\n                                        { /*TOKEN("COMMENT"); yyout << '\n'; */} 



    /* white space */
{s}+;



    /* SCONSTANT */
[\"][^\"]*[\"]                                  { TOKEN("SCONSTANT", yytext); }



    /* ICONSTANT */
{d}+                                            { TOKEN("ICONSTANT", yytext); }



    /* DCONSTANT */
(({d}+\.?{d}*)|({d}*\.?{d}+))({EXP}[+-]?{d}+)?  { TOKEN("DCONSTANT", yytext); }



    /* operators */
{OP1}{OP2}?                                         {
    // TODO: change back type to Token
    std::string word = operation_to_token((std::string)yytext);
    
    // TODO: change type back to Token
    if (word == "REJECT") {
        TOKEN("UNKNOWN");
    }
    else {
        TOKEN(word);
    }
}



    /* punctuation */
{PUN}                                             {
    // TODO: change back type to Token
    std::string word = punctuation_to_token((std::string)yytext);
    
    // TODO: change type back to Token
    if (word == "REJECT") {
        TOKEN("UNKNOWN");
    }
    else {
        TOKEN(word);
    }
}



    /* keywords & identifiers */
({ALPHA}|[_$])({w}|[$])*                        { 

    // TODO: change back type to Token
    std::string word = keyword_to_token((std::string)yytext);
    
    // TODO: change type back to Token
    if (word == "IDENTIFIER") TOKEN(word, yytext)
    else                      TOKEN(word);
}


    /* .   {TOKEN("UNKNOWN");} */



    /* end of file */
<<EOF>>                                         { TOKEN("EOF"); return 0; }



%%
