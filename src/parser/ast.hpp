#ifndef AST_HPP
#define AST_HPP




#include <string>
#include <vector>
#include <iostream>




class AST {
public:
    virtual ~AST() = default;
    virtual void print(std::ostream& os) const;
    friend std::ostream& operator<<(std::ostream& os, const AST& ast);
};




class Program : public AST
{
private:
    std::string* name;
    std::string* routines;
public:
    Program(std::string* name, std::string* routines);
    void print(std::ostream& os) const override;
};







// class Routine : public AST 
// {
// private:
//     std::string* type;
//     std::string* name;
//     std::string* parameters;
//     std::string* block;
    
// public:
//     Routine(std::string* type, std::string* name, std::string* parameters, std::string* block);
//     friend std::ostream& operator<<(std::ostream& os, const Routine& routine);
// };






// class Routines : public AST 
// {
// private:
//     std::vector<Routine*>* routines;
// public:
//     Routines();
//     Routines(Routines* routines, Routine* routine);

//     bool operator==(std::nullptr_t) const;
//     // friend std::ostream& operator<<(std::ostream& os, const Routines& routines);
// };








// // Base class for expressions
// class Expression : public AST {
// };

// // Constant node
// class Constant : public Expression {
// public:
//     int value;  // For simplicity, using only integers here, you can expand to other types
//     Constant(int value) : value(value) {}
// };

// // Identifier node
// class Identifier : public Expression {
// public:
//     std::string name;
//     Identifier(const std::string& name) : name(name) {}
// };

// // Binary operation node (e.g., x + y)
// class BinaryOperation : public Expression {
// public:
//     std::string op;
//     Expression* left;
//     Expression* right;
//     BinaryOperation(const std::string& op, Expression* left, Expression* right)
//         : op(op), left(left), right(right) {}
// };

// // Variable declaration node
// class Declaration : public AST {
// public:
//     std::string type;
//     std::string name;
//     Declaration(const std::string& type, const std::string& name)
//         : type(type), name(name) {}
// };

// // Assignment node
// class Assignment : public AST {
// public:
//     Identifier* var;
//     Expression* value;
//     Assignment(Identifier* var, Expression* value) : var(var), value(value) {}
// };

// // Program node
// class Program : public AST {
// public:
//     std::string name;
//     std::vector<AST*> routines;
//     Program(const std::string& name, const std::vector<AST*>& routines) : name(name), routines(routines) {}
// };

#endif // AST_HPP