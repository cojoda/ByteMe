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


%%
    /* input file */
\-i\ [a-zA-Z0-9]+\.f24    { ifilename = yytext + 3; }

    /* output file */
\-o\ [a-zA-Z0-9]+\.[a-zA-Z0-9\.*]   { ofilename = yytext + 3; }

%%
