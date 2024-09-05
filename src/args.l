%{
#include <iostream>
#include <stdio.h>
#include <string>

extern std::string ifilename;
extern std::string ofilename;

%}


%option noyywrap
%option c++
%option prefix="Args"

S               [^\t\n\f ]
FILE           ({S}+|\\[ ])


%%
    /* input file */
\-i\ {FILE}+                { ifilename = yytext + 3; }

    /* output file */
\-o\ {FILE}+                { ofilename = yytext + 3; }

{S}                         { /* unknown args handling */ }

%%
