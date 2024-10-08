#ifndef TOKEN_H
#define TOKEN_H



enum Token
{
    // Keywords
    K_DO,
    K_DOUBLE,
    K_ELSE,
    K_EXIT,
    K_FUNCTION,
    K_IF,
    K_INTEGER,
    K_PRINT_DOUBLE,
    K_PRINT_INTEGER,
    K_PRINT_STRING,
    K_PROCEDURE,
    K_PROGRAM,
    K_READ_DOUBLE,
    K_READ_INTEGER,
    K_READ_STRING,
    K_RETURN,
    K_STRING,
    K_THEN,
    K_UNTIL,
    K_WHILE,
    // Names & Literal Types
    IDENTIFIER,
    DCONSTANT,
    ICONSTANT,
    SCONSTANT,
    // Operators
    PLUS,
    INCREMENT,
    MINUS,
    DECREMENT,
    MULTIPLY,
    DIVIDE,
    MOD,
    DAND,
    DOR,
    NOT,
    DEQ,
    GEQ,
    GT,
    LEQ,
    LT,
    NE,
    ASSIGN,
    ASSIGN_PLUS,
    ASSIGN_MINUS,
    ASSIGN_MULTIPLY,
    ASSIGN_DIVIDE,
    ASSIGN_MOD,
    // Punctuation
    PERIOD,
    SEMI,
    LBRACKET,
    RBRACKET,
    LCURLY,
    RCURLY,
    LPAREN,
    RPAREN,
    COMMA,
    UNKNOWN
};



#endif // TOKEN_H