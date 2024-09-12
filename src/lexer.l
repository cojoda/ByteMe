%{
#include <iostream>
#include <fstream>
#include "keyword.h"
#include "token.h"

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
[\t\n\f ]+;

    /* SCONSTANT */
[\"][^\"]*[\"]                      { TOKEN("SCONSTANT", yytext); }

    /* ICONSTANT */
[0-9]+                              { TOKEN("ICONSTANT", yytext); }

    /* DCONSTANT */
-?(([0-9]+.?[0-9]*)|([0-9]*.?[0-9]+))([dD][-+]?[0-9]+)?     { TOKEN("DCONSTANT", yytext); }

    /* arithmetic operators */
"+"         { TOKEN("PLUS");        }
"++"        { TOKEN("INCREMENT");   }
"-"         { TOKEN("MINUS");       }
"--"        { TOKEN("DECREMENT");   }
"*"         { TOKEN("MULTIPLY");    }
"/"         { TOKEN("DIVIDE");      }
"%"         { TOKEN("MOD");         }

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

    /* keywords & identifiers */
[a-zA-Z_$][a-zA-Z0-9_$]* { 

    // TODO: change back type to Token
    std::string word = keyword_to_token((std::string)yytext);
    
    // TODO: change type back to Token
    if (word == "IDENTIFIER") {
        TOKEN(word, yytext);
    }
    else {
        TOKEN( word);
    }
}

    /* end of file */
<<EOF>>     { TOKEN("EOF"); return 0; }


%%
