#ifndef OPERATION_H
#define OPERATION_H


#include <iostream>
#include <unordered_map>
#include <string>

#include "token.h"



// TODO: codomain type back to Token (by removing quotes from codomain).
// I set it this way for debugging so I can print to std::cout
// std::unordered_map<std::string, Token> keyword_map = {
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



// TODO: change back Token
// Token keyword_to_token(const std::string& operation)
std::string operation_to_token(const std::string& operation)
{
    // TODO: change back to Token
    // std::unordered_map<std::string, Token>::iterator mapping = keyword_map.find(operation);
    std::unordered_map<std::string, std::string>::iterator mapping = operation_map.find(operation);
    if (mapping != operation_map.end()) {
        return mapping->second; // found
    }
    
    // not found, is identifier?
    // TODO: change back to Token
    // return REJECT
    return "REJECT";
}


#endif // OPERATION_H