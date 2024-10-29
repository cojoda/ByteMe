#ifndef SYMBOL_HPP
#define SYMBOL_HPP

#include <string>
#include <unordered_map>

#include "src/ast/ast.hpp"







class Symbol 
{
public:
    std::string name;
    std::string type;
    int         scopeLevel;

    Symbol(const std::string& name,
           const std::string& type,
                 int          scopeLevel);
};




class SymbolTable 
{
private:
    std::unordered_map<std::string, Symbol*> table
            = std::unordered_map<std::string, Symbol*>();

public:
    SymbolTable() = default;
    ~SymbolTable() = default;

    void insert(const std::string& name,
                      Symbol*      symbol);

    Symbol* lookup(const std::string& name);
};



class Scope 
{
public:
    SymbolTable symbols;
    Scope*      parent;

    Scope() = default;
    Scope(Scope* parent);
};



// Creates a stack of scopes
class SymbolStack
{
private:
    std::vector<Scope*> scope_stack = std::vector<Scope*>();

public:
    SymbolStack() = default;
    ~SymbolStack() = default;

    Scope* currentScope();
    void enterScope();
    void exitScope();
};






#endif