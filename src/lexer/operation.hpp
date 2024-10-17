#ifndef OPERATION_H
#define OPERATION_H



#include <unordered_map>
#include <string>

// #include "token.h"
 #include "../parser/parser.hpp"



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



int operation_to_token(const std::string& operation)
{
    std::unordered_map<std::string, int>::iterator mapping = operation_map.find(operation);
    if (mapping != operation_map.end())
        return mapping->second;  // Return token if found
    return UNKNOWN;              // Otherwise UNKNOWN
}


#endif // OPERATION_H