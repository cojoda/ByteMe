%{
#include <iostream>
#include <fstream>

extern std::ofstream lex_ofstream;

#define TOKEN1(arg1)        lex_ofstream << "<" << arg1 << ">";
#define TOKEN2(arg1, arg2)  lex_ofstream << "<" << arg1 << "," << arg2 << ">";
#define GET_TOKEN(_1, _2, NAME, ...) NAME
#define TOKEN(...) GET_TOKEN(__VA_ARGS__, TOKEN2, TOKEN1) (__VA_ARGS__)
%}


%option noyywrap
%option c++
%option prefix="Byte"


%%

    /* comments */
\/\/.*\n                { TOKEN("COMMENT"); lex_ofstream << '\n'; } 

    /* white space */
[\t\n ]+;



    /* SCONSTANT */
[\"][^\"]*[\"]                      { TOKEN("SCONSTANT", yytext); }

    /* ICONSTANT */
[0-9]+                              { TOKEN("ICONSTANT", yytext); }

    /* DCONSTANT */
        /* mantisa only */
[0-9]+\.[0-9]*                      { TOKEN("DCONSTANT", yytext); }
\.[0-9]+                            { TOKEN("DCONSTANT", yytext); }
        /* mantisa + exponent */
[0-9]+\.[0-9]*d(\+|\-)?[0-9]+       { TOKEN("DCONSTANT", yytext); }
\.[0-9]+d(\+|\-)?[0-9]              { TOKEN("DCONSTANT", yytext); }

        /* incorrectly formatted */
[0-9]+\.[0-9]*[d]                   { TOKEN("UNKNOWN_DCONSTANT", yytext);   }
[0-9]+\.[0.9]?d[0-9\+\-]?[0-9]      { TOKEN("", yytext);                    }



    /* keywords */
do              { TOKEN("K_DO");            }
double          { TOKEN("K_DOUBLE");        }
else            { TOKEN("K_ELSE");          }
exit            { TOKEN("K_EXIT");          }
function        { TOKEN("K_FUNCTION");      }
if              { TOKEN("K_IF");            }
integer         { TOKEN("K_INTEGER");       }
print_double    { TOKEN("K_PRINT_DOUBLE");  }
print_integer   { TOKEN("K_PRINT_INTEGER"); }
program         { TOKEN("K_PROGRAM");       }
print_string    { TOKEN("K_PRINT_STRING");  }
read_double     { TOKEN("K_READ_DOUBLE");   }
procedure       { TOKEN("K_PROCEDURE");     }
read_integer    { TOKEN("K_READ_INTEGER");  }
read_string     { TOKEN("K_READ_STRING");   }
return          { TOKEN("K_RETURN");        }
string          { TOKEN("K_STRING");        }
then            { TOKEN("K_THEN");          }
until           { TOKEN("K_UNTIL");         }
while           { TOKEN("K_WHILE");         }



    /* IDENTIFIER */
[a-zA-Z_$][a-zA-Z0-9_$]*     { TOKEN("IDENTIFIER", yytext); }



    /* arithmetic operators */
"+"         { TOKEN("PLUS");        }
"++"        { TOKEN("INCREMENT");   }
"/"         { TOKEN("DIVIDE");      }
"-"         { TOKEN("MINUS");       }
"--"        { TOKEN("DECREMENT");   }
"%"         { TOKEN("MOD");         }
"*"         { TOKEN("MULTIPLY");    }

    /* logic operators */
"||"        { TOKEN("DOR");     }
"&&"        { TOKEN("DAND");    }
"!"         { TOKEN("NOT");     }

    /* comparision operators */
"=="        { TOKEN("DEQ");     }
">="        { TOKEN("GEQ");     }
">"         { TOKEN("GT");      }
"<="        { TOKEN("LEQ");     }
"<"         { TOKEN("LT");      }
"!="        { TOKEN("NE");      }

    /* assignment operators */
":="        { TOKEN("ASSIGN");          }
"+="        { TOKEN("ASSIGN_PLUS");     }
"-="        { TOKEN("ASSIGN_MINUS");    }
"*="        { TOKEN("ASSIGN_MULTIPLY"); }
"/="        { TOKEN("ASSIGN_DIVIDE");   }
"%="        { TOKEN("ASSIGN_MOD");      }

    /* punctuation */
"."         { TOKEN("PERIOD");      }
";"         { TOKEN("SEMI");        }
"["         { TOKEN("LBRACKET");    }
"]"         { TOKEN("RBRACKET");    }
"{"         { TOKEN("LCURLY");      }
"}"         { TOKEN("RCURLY");      }
"("         { TOKEN("LPAREN");      }
")"         { TOKEN("RPAREN");      }
","         { TOKEN("COMMA");       }


    /* end of file */
<<EOF>>     { TOKEN("EOF"); return 0; }


%%
