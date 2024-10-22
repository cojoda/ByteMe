#include "ast.hpp"




    /* AST */

std::string AST::toString() const
{
    std::string* result = new std::string("");
    return *result;
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




    /* Program */

Program::Program(std::string* name, Routines* routines) : name(name), routines(routines) {}

std::string Program::toString() const
{
    std::string* result = new std::string("(program:" + *name + "\n" + routines->toString() + ")");
    return *result;
}

void Program::print(std::ostream& os) const
{
    os << toString();
}




    /* Routines */

Routines::Routines() {};

Routines::Routines(Routines* routines, Routine* routine)
{
    if (routines->routines_list == nullptr)
    {
        routines->routines_list = new std::vector<Routine*>();
    }
    routines->routines_list->push_back(routine);
    this->routines_list = routines->routines_list;
}

std::string Routines::toString() const
{
    std::string* result = new std::string();
    for (Routine* item : *routines_list) {
        if (item) {
            result->append(item->toString() + "\n");
        }
    }
    return *result;
}

void Routines::print(std::ostream& os) const
{
    os << toString();
}



    /* Routine */

Routine::Routine() {}
Routine::~Routine() {}

std::string Routine::toString() const
{
    std::string* result = new std::string("Routine class output");
    return *result;
}

void Routine::print(std::ostream& os) const
{
    os << toString();
}




    /* Function */

Function::Function() {};

Function::Function(std::string* type,
                   std::string* name,
                   std::string* parameters,
                   std::string* block) : type(type), name(name), parameters(parameters), block(block) {}

std::string Function::toString() const
{
    std::string* result = new std::string(*type + *name + *parameters + *block);
    return *result;
}

void Function::print(std::ostream& os) const
{
    os << toString();
}




    /* Procedure */

Procedure::Procedure() {};

Procedure::Procedure(std::string* type,
                     std::string* parameters,
                     std::string* block) : type(type), parameters(parameters), block(block) {}

std::string Procedure::toString() const
{
    std::string* result = new std::string("procedure:" + *type + "(" + *parameters + ")" + "\n" + *block);
    return *result;
}

void Procedure::print(std::ostream& os) const
{
    os << toString();
}




    /* Statements */
Statements::Statements() {};

Statements::Statements(Statements* statements, Statement* statement)
{
    if (statements->statement_list == nullptr)
    {
        statements->statement_list = new std::vector<Statement*>();
    }
    statements->statement_list->push_back(statement);
    this->statement_list = statements->statement_list;
}

std::string Statements::toString() const
{
    std::string* result = new std::string();
    for (Statement* item : *statement_list) {
        if (item) {
            result->append(item->toString() + "\n");
        }
    }
    return *result;
}

void Statements::print(std::ostream& os) const
{
    os << toString();
}




    /* Statement */
Statement::Statement() {}
Statement::~Statement() {}

std::string Statement::toString() const
{
    std::string* result = new std::string("Statement class output");
    return *result;
}

void Statement::print(std::ostream& os) const
{
    os << toString();
}



