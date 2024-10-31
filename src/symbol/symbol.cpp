

#include "src/symbol/symbol.hpp"



std::string getOffset(int depth)
{
    std::string offset = std::string();
    for (int i = 0; i < depth; i++) offset += "\t";
    return offset;
}




    /* Scope */

Scope::Scope(Scope* parent) : parent(parent),
                              depth(parent->depth + 1) { symbol_table.setDepth(depth); }

std::string Scope::toString() const
{
    std::string result = std::string("depth:" + std::to_string(depth));
    return result + "\n" + symbol_table.toString();
}

void Scope::print(std::ostream& os) const { os << toString(); }


std::ostream& operator<<(std::ostream& os, const Scope& scope)
{
    scope.print(os);
    return os;
}

std::string operator+(const Scope& scope, const std::string& str)
{
    return scope.toString() + str;
}

std::string operator+(const std::string& str, const Scope& scope)
{
    return str + scope.toString();
}

std::string& operator+=(std::string& lhs, const Scope& rhs) {
    lhs += rhs.toString();
    return lhs;
}



    /* Symbol */

Symbol::Symbol(std::string* type,
               std::string* name) : type(type),
                                    name(name) {}

std::string* Symbol::getName() { return name; }

std::string Symbol::toString() const
{
    return *type + ":" + *name;
}

void Symbol::print(std::ostream& os) const { os << toString(); }

std::ostream& operator<<(std::ostream& os, const Symbol& symbol)
{
    symbol.print(os);
    return os;
}

std::string operator+(const Symbol& symbol, const std::string& str)
{
    return symbol.toString() + str;
}

std::string operator+(const std::string& str, const Symbol& symbol)
{
    return str + symbol.toString();
}

std::string& operator+=(std::string& lhs, const Symbol& symbol) {
    lhs += symbol.toString();
    return lhs;
}



    /* SymbolTable  */

void SymbolTable::insert(Symbol* symbol) 
{
    if (symbol) table.insert(std::make_pair(symbol->getName(), symbol));
}

Symbol* SymbolTable::lookup(std::string* name) 
{
    auto item = table.find(name);
    return item != table.end() ? item->second : nullptr;
}

std::string SymbolTable::toString() const
{
    std::string off = getOffset(depth + 1);
    std::string result = std::string(off + "symbol table:");

    for (auto pair : table) {
        std::string* key = pair.first;
        Symbol*    value = pair.second;
        result += + "\n\t" + off + value->toString();
    }
    return result;
}

void SymbolTable::print(std::ostream& os) const
{ os << toString(); }

std::ostream& operator<<(std::ostream& os, const SymbolTable& symbol_table)
{
    symbol_table.print(os);
    return os;
}

std::string operator+(const SymbolTable& symbol_table, const std::string& str)
{
    return symbol_table.toString() + str;
}

std::string operator+(const std::string& str, const SymbolTable& symbol_table)
{
    return str + symbol_table.toString();
}

std::string& operator+=(std::string& lhs, const SymbolTable& symbol_table) {
    lhs += symbol_table.toString();
    return lhs;
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





// void checkAssignmentTypes(Variable* lhs,
//                           Variable* rhs) 
// {
//     if (lhs == nullptr)
//         std::cerr << "Can't assign to an lvalue of null" << std::endl; return;

//     if (rhs == nullptr)
//         std::cerr << "rvalue has no type" << std::endl; return;


//     if (lhs->type != rhs->type) 
//         std::cerr << "Type mismatch in assignment: " << lhs->type << " != " << rhs->type << std::endl;
// }