#ifndef PUNCTUATION_H
#define PUNCTUATION_H



#include <unordered_map>
#include <string>

// #include "token.h"
#include "parser.hpp"



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



int punctuation_to_token(const std::string& keyword)
{
    std::unordered_map<std::string, int>::iterator mapping = punctuation_map.find(keyword);
    if (mapping != punctuation_map.end()) 
        return mapping->second;  // Return token if found
    return UNKNOWN;              // Otherwise UNKNOWN
}



#endif // PUNCTUATION_H