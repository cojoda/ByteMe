#ifndef TOKEN_H
#define TOKEN_H

#include "../parser/parser.hpp"

#include <string>
#include <unordered_map>



std::unordered_map<std::string, int> keyword_map = {
    {"do",            K_DO},
    {"double",        K_DOUBLE},
    {"else",          K_ELSE},
    {"exit",          K_EXIT},
    {"function",      K_FUNCTION},
    {"if",            K_IF},
    {"integer",       K_INTEGER},
    {"print_double",  K_PRINT_DOUBLE},
    {"print_integer", K_PRINT_INTEGER},
    {"print_string",  K_PRINT_STRING},
    {"procedure",     K_PROCEDURE},
    {"program",       K_PROGRAM},
    {"read_double",   K_READ_DOUBLE},
    {"read_integer",  K_READ_INTEGER},
    {"read_string",   K_READ_STRING},
    {"return",        K_RETURN},
    {"string",        K_STRING},
    {"then",          K_THEN},
    {"until",         K_UNTIL},
    {"while",         K_WHILE}
};



std::unordered_map<std::string, int> operation_map = {
    {"+",  PLUS},
    {"-",  MINUS},
    {"*",  MULTIPLY},
    {"/",  DIVIDE},
    {"%",  MOD},
    {"||", DOR},
    {"&&", DAND},
    {"!",  NOT},
    {"==", DEQ},
    {">=", GEQ},
    {">",  GT},
    {"<=", LEQ},
    {"<",  LT},
    {"!=", NE},
    {":=", ASSIGN},
    {"+=", ASSIGN_PLUS},
    {"-=", ASSIGN_MINUS},
    {"*=", ASSIGN_MULTIPLY},
    {"/=", ASSIGN_DIVIDE},
    {"%=", ASSIGN_MOD},
    {"++", INCREMENT},
    {"--", DECREMENT}
};



std::unordered_map<std::string, int> punctuation_map = {
         {".", PERIOD},
         {";", SEMI},
         {"[", LBRACKET},
         {"]", RBRACKET},
         {"{", LCURLY},
         {"}", RCURLY},
         {"(", LPAREN},
         {")", RPAREN},
         {",", COMMA}
};




int keyword_to_token(const std::string& keyword)
{
    std::unordered_map<std::string, int>::iterator mapping = keyword_map.find(keyword);
    
    if (mapping != keyword_map.end())
        return mapping->second;  // Return token if found
    return IDENTIFIER;           // Otherwise, return IDENTIFIER
}

int operation_to_token(const std::string& operation)
{
    std::unordered_map<std::string, int>::iterator mapping = operation_map.find(operation);
    if (mapping != operation_map.end())
        return mapping->second;  // Return token if found
    return UNKNOWN;              // Otherwise UNKNOWN
}

int punctuation_to_token(const std::string& keyword)
{
    std::unordered_map<std::string, int>::iterator mapping = punctuation_map.find(keyword);
    if (mapping != punctuation_map.end()) 
        return mapping->second;  // Return token if found
    return UNKNOWN;              // Otherwise UNKNOWN
}

#endif // TOKEN_H