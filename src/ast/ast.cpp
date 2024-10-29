#include "ast.hpp"

class Routine;



    /* Node */

std::string Node::toString() const
{
    return std::string();
}

void Node::print(std::ostream& os) const
{
    os << toString();
}


std::ostream& operator<<(std::ostream& os, const Node& ast)
{
    ast.print(os);
    return os;
}

std::string operator+(const Node& ast, const std::string& str)
{
    return ast.toString() + str;
}

std::string operator+(const std::string& str, const Node& ast)
{
    return str + ast.toString();
}

std::string& operator+=(std::string& lhs, const Node& rhs) {
    lhs += rhs.toString();
    return lhs;
}




