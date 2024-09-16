#ifndef KEYWORD_H
#define KEYWORD_H



#include <iostream>
#include <unordered_map>
#include <string>

#include "token.h"



// TODO: codomain type back to Token (by removing quotes from codomain).
// I set it this way for debugging so I can print to std::cout
// std::unordered_map<std::string, Token> keyword_map = {
std::unordered_map<std::string, std::string> keyword_map = {
    {"do",            "K_DO"},
    {"double",        "K_DOUBLE"},
    {"else",          "K_ELSE"},
    {"exit",          "K_EXIT"},
    {"function",      "K_FUNCTION"},
    {"if",            "K_IF"},
    {"integer",       "K_INTEGER"},
    {"print_double",  "K_PRINT_DOUBLE"},
    {"print_integer", "K_PRINT_INTEGER"},
    {"print_string",  "K_PRINT_STRING"},
    {"procedure",     "K_PROCEDURE"},
    {"program",       "K_PROGRAM"},
    {"read_double",   "K_READ_DOUBLE"},
    {"read_integer",  "K_READ_INTEGER"},
    {"read_string",   "K_READ_STRING"},
    {"return",        "K_RETURN"},
    {"string",        "K_STRING"},
    {"then",          "K_THEN"},
    {"until",         "K_UNTIL"},
    {"while",         "K_WHILE"}
};



// TODO: change back Token
// Token keyword_to_token(const std::string& keyword)
std::string keyword_to_token(const std::string& keyword)
{
    // TODO: change back to Token
    // std::unordered_map<std::string, Token>::iterator mapping = keyword_map.find(keyword);
    std::unordered_map<std::string, std::string>::iterator mapping = keyword_map.find(keyword);
    if (mapping != keyword_map.end()) {
        return mapping->second; // found
    }
    
    // not found, is identifier?
    // TODO: change back to Token
    // return IDENTIFIER
    return "IDENTIFIER";
}



#endif // KEYWORD_H