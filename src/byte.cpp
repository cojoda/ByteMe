// #include <FlexLexer.h>
#include <iostream>


#define YYDEBUG
// yyFlexLexer* flexlexer;  // Declare the flexlexer instance (static pointer to heap allocation)
int yyparse();  // Declare the parser function
extern int yydebug;


int main(int argc, char** argv) 
{
    yydebug = 0;
    // flexlexer = new yyFlexLexer();
    return yyparse();
    
}
