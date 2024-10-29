#include "ast.hpp"

class Routine;



    /* AST */

std::string AST::toString() const
{
    return std::string();
}

void AST::print(std::ostream& os) const
{
    os << toString();
}


std::ostream& operator<<(std::ostream& os, const AST& ast)
{
    ast.print(os);
    return os;
}

std::string operator+(const AST& ast, const std::string& str)
{
    return ast.toString() + str;
}

std::string operator+(const std::string& str, const AST& ast)
{
    return str + ast.toString();
}

std::string& operator+=(std::string& lhs, const AST& rhs) {
    lhs += rhs.toString();
    return lhs;
}




