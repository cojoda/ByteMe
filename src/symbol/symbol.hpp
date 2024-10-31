#ifndef SYMBOL_HPP
#define SYMBOL_HPP

#include <string>
#include <unordered_map>
#include <vector>
#include <iostream>



class Symbol 
{
public:
    std::string* type;
    std::string* name;

    Symbol(std::string* type,
           std::string* name);

    std::string* getName();

    std::string toString() const;
    void print(std::ostream& os) const;
    friend std::ostream& operator<<(std::ostream& os, const Symbol& symbol);
    friend std::string operator+(const Symbol& symbol, const std::string& str);
    friend std::string operator+(const std::string& str, const Symbol& symbol);
    friend std::string& operator+=(std::string& lhs, const Symbol& rhs);
};



class SymbolTable 
{
private:
    std::unordered_map<std::string*, Symbol*> table
            = std::unordered_map<std::string*, Symbol*>();

public:
    SymbolTable() = default;
    ~SymbolTable() = default;

    void insert(Symbol* symbol);

    Symbol* lookup(std::string* name);

    std::string toString() const;
    void print(std::ostream& os) const;
    friend std::ostream& operator<<(std::ostream& os, const SymbolTable& symbol_table);
    friend std::string operator+(const SymbolTable& symbol_table, const std::string& str);
    friend std::string operator+(const std::string& str, const SymbolTable& symbol_table);
    friend std::string& operator+=(std::string& lhs, const SymbolTable& rhs);
};



class Scope 
{
public:
    SymbolTable symbol_table;
    Scope*      parent;
    int         depth = 0;

    Scope() = default;
    Scope(Scope* parent);

    std::string toString() const;
    void print(std::ostream& os) const;
    friend std::ostream& operator<<(std::ostream& os, const Scope& scope);
    friend std::string operator+(const Scope& scope, const std::string& str);
    friend std::string operator+(const std::string& str, const Scope& scope);
    friend std::string& operator+=(std::string& lhs, const Scope& rhs);
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