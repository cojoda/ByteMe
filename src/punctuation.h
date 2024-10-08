#ifndef PUNCTUATION_H
#define PUNCTUATION_H



#include <unordered_map>
#include <string>

#include "token.h"



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



std::string punctuation_to_token(const std::string& keyword)
{
    std::unordered_map<std::string, std::string>::iterator mapping = punctuation_map.find(keyword);
    if (mapping != punctuation_map.end()) 
        return mapping->second;  // Return token if found
    return "REJECT";             // Otherwise REJECT
}



#endif // PUNCTUATION_H