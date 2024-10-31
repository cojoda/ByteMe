#include "ast.hpp"

class Routine;


    /* Node */

void Node::initSymbolTree() {}
void Node::initSymbolTree(Scope* scope) {}

std::string Node::toString() const { return std::string(); }

void Node::print(std::ostream& os) const { os << toString(); }

std::ostream& operator<<(std::ostream& os, const Node& ast)
{
    ast.print(os);
    return os;
}

std::string operator+(const Node&        ast,
                      const std::string& str) { return ast.toString() + str; }

std::string operator+(const std::string& str,
                      const Node&        ast) { return str + ast.toString(); }

std::string& operator+=(std::string& lhs, const Node& rhs)
{
    lhs += rhs.toString();
    return lhs;
}



    /* Program */

void Program::initSymbolTree()
{
    scope = new Scope();
    std::vector <Routine*>* routine_list = body->getList();
    for (Routine* routine : *routine_list) {
        if (routine) routine->initSymbolTree(scope);
    }
}


std::string Program::toString() const
{
    std::string result = std::string("<program:\n\t");
    result += (name  ? *name             : "<NULL_NAME>")  + "\n\t";
    result += (scope ? scope->toString() : "<NULL_SCOPE>") + "\n";
    result += (body  ? body->toString()  : "<NULL_BODY>")  + "\n";
    return result + ">";
}



    /* Routine */

void Routine::initSymbolTree(Scope* parent)
{
    if (parent) scope = new Scope(parent);
    else scope = new Scope();

    // add routine's parameters to scope
    std::vector <Declaration*>* declaration_list = parameter_list->getList();
    for (Declaration* parameter : *declaration_list) {
        if (parameter) parameter->initSymbolTree(scope);
    }

    // create subscopes
    std::vector  <Statement*>* statement_list = body->getList();
    for (Statement* statement : *statement_list) {
        if (statement) statement->initSymbolTree(scope);
    }
}

std::string Routine::toString() const
{
    std::string result = std::string();
    result += (type  ? "<function:" + *type : "<procedure:") + "\n\t";
    result += (name  ? *name                : "<NULL_NAME>") + "\n\t";
    result += (scope ? scope->toString()    : "<MULL_SCOPE>") + "\n\t";
    result += (body  ? body->toString()     : "<NULL_BODY>");
    return result + ">";
}



void Return::initSymbolTree() {}



    /* Control Statements */

void IfStatement::initSymbolTree(Scope* parent)
{
    scope = new Scope(parent);
    if (then_statement) then_statement->initSymbolTree(scope);
    if (else_statement) else_statement->initSymbolTree(scope);
}

std::string IfStatement::toString() const
{
    std::string result = std::string("\n\t<if:");
    result += "\n\t" + (scope ? scope->toString() : "<NULL_SCOPE>");
    return result + ">";
}


void DoStatement::initSymbolTree(Scope* parent)
{
    scope = new Scope(parent);
    initialization->initSymbolTree(scope);
    body->initSymbolTree(scope);
}

std::string DoStatement::toString() const
{
    std::string result = std::string("\n\t<do:");
    result += "\n\t" + (scope ? scope->toString() : "<NULL_SCOPE>");
    return result + ">";
}

void WhileStatement::initSymbolTree(Scope* parent)
{
    scope = new Scope(parent);
    body->initSymbolTree(scope);
}

std::string WhileStatement::toString() const
{
    std::string result = std::string("\n\t<do_while:");
    result += "\n\t" + (scope ? scope->toString() : "<NULL_SCOPE>");
    return result + ">";
}



void Declaration::initSymbolTree(Scope* scope)
{
    std::vector <UniDec*>* declaration_list = name_list->getList();
    for (UniDec* declaration : *declaration_list) {
        Symbol* symbol = new Symbol(type, declaration->getName());
        scope->symbol_table.insert(symbol);
    }
}
