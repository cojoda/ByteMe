// #include <FlexLexer.h>
#include <iostream>


int yyparse(); 
extern int yydebug;


int main(int argc, char** argv) 
{
    yydebug = 1;
    return yyparse();
}
