%{
    #include <string>
    #include "src/parser/ast.hpp"
    #include "src/parser/parser.hpp"
%}

%option noyywrap

    /* Character Class Macros */
a       [a-zA-Z]
EXP     [dD]
s       [ \t\n\r\f\v]
S       [^ \t\n\r\f\v]
w       [a-zA-Z0-9_]
W       [^a-zA-Z0-9_]
d       [0-9]
D       [^0-9]
OP1     [-+*/%=|&!><:]
OP2     [-+=|&]
PUN     [.;\[\]{}(),]

%%

    /* Comments */
\/\/.*\n                                        { } 

    /* Whitespace */
{s}+                                            { }

    /* String Constants */
[\"][^\"]*[\"]                                  { yylval.s_val = new std::string(yytext, yyleng); return SCONSTANT; }

    /* Integer Constants */
{d}+                                            { yylval.i_val = atoi(yytext); return ICONSTANT;                    }

    /* Floating-point Constants */
(({d}+\.?{d}*)|({d}*\.?{d}+))({EXP}[-+]?{d}+)?  { yylval.d_val = atof(yytext); return DCONSTANT;                    }

    /* Operators */
"+"                     { return PLUS;              }
"-"                     { return MINUS;             }
"*"                     { return MULTIPLY;          }
"/"                     { return DIVIDE;            }
"%"                     { return MOD;               }
"||"                    { return DOR;               }
"&&"                    { return DAND;              }
"!"                     { return NOT;               }
"=="                    { return DEQ;               }
"!="                    { return NE;                }
">="                    { return GEQ;               }
">"                     { return GT;                }
"<="                    { return LEQ;               }
"<"                     { return LT;                }
":="                    { return ASSIGN;            }
"+="                    { return ASSIGN_PLUS;       }
"-="                    { return ASSIGN_MINUS;      }
"*="                    { return ASSIGN_MULTIPLY;   }
"/="                    { return ASSIGN_DIVIDE;     }
"%="                    { return ASSIGN_MOD;        }
"++"                    { return INCREMENT;         }
"--"                    { return DECREMENT;         }

    /* Punctuation */
"."                     { return PERIOD;            }
";"                     { return SEMI;              }
"["                     { return LBRACKET;          }
"]"                     { return RBRACKET;          }
"{"                     { return LCURLY;            }
"}"                     { return RCURLY;            }
"("                     { return LPAREN;            }
")"                     { return RPAREN;            }
","                     { return COMMA;             }

    /* Identifiers */
"program"               { return K_PROGRAM;         }
"procedure"             { return K_PROCEDURE;       }
"function"              { return K_FUNCTION;        }
"read_integer"          { return K_READ_INTEGER;    }
"read_double"           { return K_READ_DOUBLE;     }
"read_string"           { return K_READ_STRING;     }
"print_integer"         { return K_PRINT_INTEGER;   }
"print_double"          { return K_PRINT_DOUBLE;    }
"print_string"          { return K_PRINT_STRING;    }
"do"                    { return K_DO;              }
"until"                 { return K_UNTIL;           }
"while"                 { return K_WHILE;           }
"if"                    { return K_IF;              }
"then"                  { return K_THEN;            }
"else"                  { return K_ELSE;            }
"return"                { return K_RETURN;          }
"exit"                  { return K_EXIT;            }
"integer"               { return K_INTEGER;         }
"double"                { return K_DOUBLE;          }
"string"                { return K_STRING;          }

    /* Keywords */
({a}|[_$])({w}|[$])*    { yylval.s_val = new std::string(yytext, yyleng); return IDENTIFIER; }

    /* End of File */
<<EOF>>                 { return EOF; return 0; }

%%
