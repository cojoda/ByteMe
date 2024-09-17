#ifndef PUNCTUATION_H
#define PUNCTUATION_H


#include <iostream>
#include <unordered_map>
#include <string>

#include "token.h"



// TODO: codomain type back to Token (by removing quotes from codomain).
// I set it this way for debugging so I can print to std::cout
// std::unordered_map<std::string, Token> punctuation_map = {
std::unordered_map<std::string, std::string> punctuation_map = {
         {".", "PERIOD"},
         {";", "SEMI"},
         {"[", "LBRACKET"},
         {"]", "RBRACKET"},
         {"{", "LCURLY"},
         {"}", "RCURLY"},
         {"(", "LPAREN"},
         {")", "RPAREN"},
         {",", "COMMA"}
};



// TODO: change back Token
// Token keyword_to_token(const std::string& keyword)
std::string punctuation_to_token(const std::string& keyword)
{
    // TODO: change back to Token
    // std::unordered_map<std::string, Token>::iterator mapping = punctuation_map.find(keyword);
    std::unordered_map<std::string, std::string>::iterator mapping = punctuation_map.find(keyword);
    if (mapping != punctuation_map.end()) {
        return mapping->second; // found
    }
    
    // not found, is identifier?
    // TODO: change back to Token
    // return IDENTIFIER
    return "REJECT";
}


#endif // PUNCTUATION_H