%{
    // Include necessary header files
    #include <string>

    #include "keyword.h"
    #include "operation.h"
    #include "punctuation.h"
    #include "token.h"

    // Macros for token output
    #define TOKEN1(arg1)        yyout << "<" << arg1 << ">";
    #define TOKEN2(arg1, arg2)  yyout << "<" << arg1 << "," << arg2 << ">";

    #define GET_TOKEN(_1, _2, NAME, ...) NAME
    #define TOKEN(...)                   GET_TOKEN(__VA_ARGS__, TOKEN2, TOKEN1) (__VA_ARGS__)
%}



%option noyywrap
%option c++
%option prefix="Byte"



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
\/\/.*\n                                        { yyout << '\n'; } 



    /* Whitespace */
{s}+                                            { yyout << yytext;}



    /* String Constants */
[\"][^\"]*[\"]                                  { TOKEN("SCONSTANT", yytext); }



    /* Integer Constants */
{d}+                                            { TOKEN("ICONSTANT", yytext); }



    /* Floating-point Constants */
(({d}+\.?{d}*)|({d}*\.?{d}+))({EXP}[-+]?{d}+)?  { TOKEN("DCONSTANT", yytext); }



    /* Operators */
{OP1}{OP2}?                 {
    std::string word = operation_to_token((std::string)yytext);
    
    if (word == "REJECT") TOKEN("UNKNOWN")
    else                  TOKEN(word);
}



    /* Punctuation */
{PUN}                       {
    std::string word = punctuation_to_token((std::string)yytext);
    
    if (word == "REJECT") TOKEN("UNKNOWN")
    else                  TOKEN(word);
}



    /* Keywords & Identifiers */
({a}|[_$])({w}|[$])*        { 
    std::string word = keyword_to_token((std::string)yytext);
    
    if (word == "IDENTIFIER") TOKEN(word, yytext)
    else                      TOKEN(word);
}



    /* End of File */
<<EOF>>             { TOKEN("EOF"); return 0; }



%%
