#include <string>
#include <unordered_map>

#include "src/ast/ast.hpp"



class Symbol {
public:
    std::string name;
    std::string type;
    int scopeLevel;
    // Additional attributes like memory address, line number, etc.

    Symbol(const std::string& name, const std::string& type, int scopeLevel)
        : name(name), type(type), scopeLevel(scopeLevel) {}
};




class SymbolTable {
private:
    std::unordered_map<std::string, Symbol*> table;
public:
    void insert(const std::string& name, Symbol* symbol) {
        table[name] = symbol;
    }

    Symbol* lookup(const std::string& name) {
        auto it = table.find(name);
        return it != table.end() ? it->second : nullptr;
    }

    // Handle scope management if necessary
};



class Scope {
public:
    SymbolTable symbols;
    Scope* parentScope;

    Scope(Scope* parent = nullptr) : parentScope(parent) {}
};

// Maintain a stack of scopes
std::vector<Scope*> scopeStack;

void enterScope() {
    scopeStack.push_back(new Scope(currentScope()));
}

void exitScope() {
    scopeStack.pop_back();
}

Scope* currentScope() {
    return scopeStack.empty() ? nullptr : scopeStack.back();
}




class Variable : public Expression {
public:
    Symbol* symbol;

    Variable(const std::string& name) {
        symbol = currentScope()->symbols.lookup(name);
        if (!symbol) {
            // Handle undeclared variable error
            std::cerr << "Undeclared variable: " << name << std::endl;
        }
    }

    std::string toString() const override {
        return symbol ? symbol->name : "undefined";
    }
};




void checkAssignmentTypes(Expression* lhs, Expression* rhs) {
    if (lhs->type != rhs->type) {
        std::cerr << "Type mismatch in assignment: " << lhs->type << " != " << rhs->type << std::endl;
    }
}