#ifndef OPERATION_H
#define OPERATION_H



#include <unordered_map>
#include <string>

#include "token.h"



std::unordered_map<std::string, std::string> operation_map = {
    {"+",  "PLUS"},
    {"++", "INCREMENT"},
    {"-",  "MINUS"},
    {"--", "DECREMENT"},
    {"*",  "MULTIPLY"},
    {"/",  "DIVIDE"},
    {"%",  "MOD"},
    {"||", "DOR"},
    {"&&", "DAND"},
    {"!",  "NOT"},
    {"==", "DEQ"},
    {">=", "GEQ"},
    {">",  "GT"},
    {"<=", "LEQ"},
    {"<",  "LT"},
    {"!=", "NE"},
    {":=", "ASSIGN"},
    {"+=", "ASSIGN_PLUS"},
    {"-=", "ASSIGN_MINUS"},
    {"*=", "ASSIGN_MULTIPLY"},
    {"/=", "ASSIGN_DIVIDE"},
    {"%=", "ASSIGN_MOD"}
};



std::string operation_to_token(const std::string& operation)
{
    std::unordered_map<std::string, std::string>::iterator mapping = operation_map.find(operation);
    if (mapping != operation_map.end())
        return mapping->second;  // Return token if found
    return "REJECT";             // Otherwise REJECT
}


#endif // OPERATION_H