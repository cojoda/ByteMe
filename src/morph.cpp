#include <iostream>



extern int yydebug;

int yyparse();



int main(int argc, char** argv) 
{
    yydebug = 0;
    return yyparse();
}
