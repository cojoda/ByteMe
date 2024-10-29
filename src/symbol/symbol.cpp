

#include "src/symbol/symbol.hpp"



    /* Scope */

Scope::Scope(Scope* parent) : parent(parent) {}




    /* Symbol */

Symbol::Symbol(const std::string& name,
               const std::string& type,
                     int          scopeLevel) : name(name),
                                                type(type),
                                                scopeLevel(scopeLevel) {}
 


    /* SymbolTable  */

void SymbolTable::insert(const std::string& name,
                               Symbol*      symbol) 
{
    table[name] = symbol;
}

Symbol* SymbolTable::lookup(const std::string& name) 
{
    auto item = table.find(name);
    return item != table.end() ? item->second : nullptr;
}







    /* SymbolStack */

Scope* SymbolStack::currentScope()
{
    return scope_stack.empty() ? nullptr : scope_stack.back();
}

void SymbolStack::enterScope()
{
    scope_stack.push_back(new Scope());
}

void SymbolStack::exitScope()
{
    scope_stack.pop_back();
}







void checkAssignmentTypes(Variable* lhs,
                          Variable* rhs) 
{
    if (lhs == nullptr)
        std::cerr << "Can't assign to an lvalue of null" << std::endl; return;
    
    if (rhs == nullptr)
        std::cerr << "rvalue has no type" << std::endl; return;


    if (lhs->type != rhs->type) 
        std::cerr << "Type mismatch in assignment: " << lhs->type << " != " << rhs->type << std::endl;
}