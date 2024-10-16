// #define  yyFlexLexer ByteFlexLexer
#include <FlexLexer.h>
// #undef   yyFlexLexer

#include <iostream>

extern int yydebug;

yyFlexLexer* flexlexer;  // Declare the flexlexer instance (static pointer to heap allocation)

int yyparse();  // Declare the parser function


int main(int argc, char** argv) 
{
    flexlexer = new yyFlexLexer();
    // yyFlexLexer->yylex();
    yydebug = 1;
    yyparse();
    delete flexlexer;
    exit(EXIT_SUCCESS);
}
