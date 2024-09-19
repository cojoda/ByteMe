#define  yyFlexLexer ByteFlexLexer
#include <FlexLexer.h>
#undef   yyFlexLexer


int main(int argc, char** argv) 
{
    FlexLexer* flexlexer = new ByteFlexLexer();
    flexlexer->yylex();
    delete flexlexer;

    exit(EXIT_SUCCESS);
}
