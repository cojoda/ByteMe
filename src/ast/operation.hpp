#ifndef OPERATION_HPP
#define OPERATION_HPP

#include <string>
#include <unordered_map>


enum class Op
{
    PLUS,
    MINUS,
    MULTIPLY,
    DIVIDE,
    MOD,
    DOR,
    DAND,
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
    INCREMENT,
    DECREMENT
};


std::unordered_map<std::string, Op> op_map = {
    {"+",  Op::PLUS},
    {"-",  Op::MINUS},
    {"*",  Op::MULTIPLY},
    {"/",  Op::DIVIDE},
    {"%",  Op::MOD},
    {"||", Op::DOR},
    {"&&", Op::DAND},
    {"!",  Op::NOT},
    {"==", Op::DEQ},
    {">=", Op::GEQ},
    {">",  Op::GT},
    {"<=", Op::LEQ},
    {"<",  Op::LT},
    {"!=", Op::NE},
    {":=", Op::ASSIGN},
    {"+=", Op::ASSIGN_PLUS},
    {"-=", Op::ASSIGN_MINUS},
    {"*=", Op::ASSIGN_MULTIPLY},
    {"/=", Op::ASSIGN_DIVIDE},
    {"%=", Op::ASSIGN_MOD},
    {"++", Op::INCREMENT},
    {"--", Op::DECREMENT}
};




#endif // OPERATION_HPP