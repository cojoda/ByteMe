// #include <FlexLexer.h>
#include <iostream>



// yyFlexLexer* flexlexer;  // Declare the flexlexer instance (static pointer to heap allocation)
int yyparse();  // Declare the parser function


int main(int argc, char** argv) 
{
    // flexlexer = new yyFlexLexer();
    return yyparse();
    
}
