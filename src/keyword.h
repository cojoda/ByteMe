#ifndef KEYWORD_H
#define KEYWORD_H



#include <unordered_map>
#include <string>

// #include "token.h"
#include "parser.hpp"



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



int keyword_to_token(const std::string& keyword)
{
    std::unordered_map<std::string, int>::iterator mapping = keyword_map.find(keyword);
    
    if (mapping != keyword_map.end())
        return mapping->second;  // Return token if found
    return IDENTIFIER;           // Otherwise, return identifier
}



#endif // KEYWORD_H