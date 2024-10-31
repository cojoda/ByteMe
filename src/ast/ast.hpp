#ifndef Node_HPP
#define Node_HPP

#include <string>
#include <vector>
#include <iostream>

#include "src/symbol/symbol.hpp"




class Routine;
class Declaration;






template <typename T, typename V>
class Block : public virtual V
{
protected:
    std::vector<T>* list;

public:
    Block() {list = new std::vector<T>();}

    Block(T item)
    {
        if (!item) return;
        if (!list) list = new std::vector<T>();
        list->push_back(item);
    } 

    Block(Block<T,V>* block, T item)
    {
        if (block) list = block->list;
        if (item) list->push_back(item);
    }

    std::vector<T>* getList()
    {
        return list;
    }

    std::string toString() const override
    {
        std::string result = std::string();
        if (!list) return result;
        for (T item : *list) {
            if (item) result += *item;
        }
        return result;
    }
};






class Node
{
public:
    Node() = default;
    virtual ~Node() = default;

    virtual std::string toString() const;
    virtual void print(std::ostream& os) const;

    virtual void initSymbolTree();
    virtual void initSymbolTree(Scope* scope);

    friend std::ostream& operator<<(std::ostream& os, const Node& node);
    friend std::string operator+(const Node& node, const std::string& str);
    friend std::string operator+(const std::string& str, const Node& node);
    friend std::string& operator+=(std::string& lhs, const Node& rhs);
    operator std::string() const { return toString(); }
};





class Statement : public virtual Node
{
public:
    virtual ~Statement() = default;
};






class Expression : public virtual Statement
{
public:
    virtual ~Expression() = default;
};






class Reference : public virtual Expression
{
private:
    std::string* name;
    Expression*  index;
public:
    Reference(std::string *value) : name(value) {}

    Reference(std::string* name,
              Expression* index) : name(name),
                                   index(index) {};

    std::string* getName() { return name; }

    // std::string toString() const override
    // {
    //     std::string result = std::string("<reference:");
    //     result += (name ? *name : "NULL,");
    //     result += (index ? std::string(*index ) : "NULL") + ">";
    //     return result;
    // }
};






class Return : public virtual Statement
{
private:
    Expression* return_value;

public:
    Return() = default;

    Return(Expression* return_value) : return_value(return_value) {};

    void initSymbolTree();

    // std::string toString() const override
    // {
    //     std::string result = std::string("<return:");
    //     if (return_value) result += *return_value;
    //     return result + ">";
    // }
};








class Program : public virtual Node
{
private:
    std::string*           name;
    Block<Routine*, Node>* body;
    Scope* scope;

public:
    Program(std::string*           name,
            Block<Routine*, Node>* routine_block) : name(name),
                                                    body(routine_block)
    {
        std::cerr << "st init started!" << std::endl;initSymbolTree(); std::cerr << "st init finished!" << std::endl;
    }


    void initSymbolTree();

    std::string toString() const override;

    
    // std::string toString() const
    // {
    //     std::string result = std::string("<Program:");
    //     result += (name ? *name : "null");
    //     result += "{" + (body ? std::string(*body ) : "null") + "}";
    //     return result;
    // }
};






class Routine : public virtual Statement
{
protected:
    std::string*                    name;
    Block<Declaration*, Statement>* parameter_list;
    Block<Statement*,   Statement>* body;
    std::string*                    type;
    Scope* scope;

public:
    Routine(std::string*                    name,
            Block<Declaration*, Statement>* parameter_list,
            Block<Statement*,   Statement>* body) : name(name),
                                                    parameter_list(parameter_list),
                                                    body(body) {}

    Routine(std::string*                    name,
            Block<Declaration*, Statement>* parameter_list,
            Block<Statement*,   Statement>* body,
            std::string*                    type) : name(name),
                                                    parameter_list(parameter_list),
                                                    body(body),
                                                    type(type) {}
    
    virtual ~Routine() = default;

    void initSymbolTree(Scope* parent);

    std::string getName()
    {
        return (name ? *name : "NULL");
    }

    std::string toString() const override;

    // std::string toString() const override
    // {
    //     std::string result = std::string("<");
    //     result += (type ? ("Function:" + *type + ",") : ("Procedure:"));
    //     result += (name ? *name : "null");
    //     result += "(";
    //     if (parameter_list) result += *parameter_list;
    //     result += "){";
    //     result += (body ? std::string(*body) : "null");
    //     return result + "}";
    // }
};




class UniDec : public virtual Node
{
private:
    Reference*  name;
    Expression* value;

public:
    UniDec(Reference* name) : name(name) {}

    UniDec(Reference*  name,
           Expression* value) : name(name),
                                value(value) {}

    std::string* getName() { return name->getName(); }

    // std::string toString() const override
    // {
    //     std::string result = std::string("<");
    //     result += (name ? std::string(*name) : "NULL");
    //     result += (value ? (":=" + *value) : ":=NULL");
    //     return result + ">";
    // }
};





class Declaration : public virtual Statement
{
protected:
    std::string*               type;
    Block<UniDec*, Statement>* name_list;

public:
    Declaration(std::string*               type,
                Block<UniDec*, Statement>* name_list) : type(type),
                                                        name_list(name_list) {}

    void initSymbolTree(Scope* scope);


    // std::string toString() const override
    // {
    //     std::string result = std::string("<Declaration:");
    //     result += (type ? *type : "null_type");
    //     result += "(";
    //     if (name_list) result += *name_list;
    //     return result + ")>";
    // }
};






class Constant : public virtual Expression
{
private:
    std::string* value;

public:
    Constant(std::string* value) : value(value) {}

    // std::string toString() const override
    // {
    //     return (value ? *value : "NULL");
    // }
};





class Assignment : public virtual Expression
{
private:
    Reference*   lvalue;
    std::string* operation;
    Expression*  value;

public:
    Assignment(Reference*   lvalue,
               std::string* operation,
               Expression*  value) : lvalue(lvalue),
                                     operation(operation),
                                     value(value) {}

    // std::string toString() const override
    // {
    //     std::string result = std::string("<");
    //     result += (lvalue ? std::string(*lvalue) : "NULL");
    //     result += (value ? ("," + *value): ",NULL") + ">";
    //     return result;
    // }
};





class UnaryOp : public virtual Expression
{
private:
    std::string* operation;
    Expression*  operand;

public:
    UnaryOp(std::string* operation,
            Expression*  operand) : operation(operation),
                                    operand(operand) {};

    // std::string toString() const override
    // {
    //     std::string result = std::string("<");
    //     result += (operation ? *operation : "NULL ");
    //     result += (operand ? std::string(*operand) : " NULL") + ">";
    //     return result;
    // }
};





class BinaryOp : public virtual Expression
{
private:
    Expression*  loperand;
    std::string* operation;
    Expression*  roperand;

public:
    BinaryOp(Expression*  loperand,
             std::string* operation,
             Expression*  roperand) : loperand(loperand),
                                      roperand(roperand),
                                      operation(operation) {};

    // std::string toString() const override
    // {
    //     std::string result = std::string("<");
    //     result += (loperand ? std::string(*loperand) : "NULL ");
    //     result += (operation ? *operation : " NULL ");
    //     result += (roperand ? std::string(*roperand) : " NULL") + ">";
    //     return  result;
    // }
};





class RoutineCall : public virtual Expression
{
private:
    std::string*              name;
    Block<Expression*, Node>* argument_list;

public:
    RoutineCall(std::string*             name,
                Block<Expression*, Node>* argument_list) : name(name),
                                                           argument_list(argument_list) {}

    // std::string toString() const override
    // {
    //     std::string result = std::string("<");
    //     result += (name ? *name : "NULL");
    //     result += "(";
    //     result += (argument_list ? std::string(*argument_list ) : "NULL") + ")>";
    //     return result;
    // }
};





class IfStatement : public virtual Statement
{
private:
    Expression* condition;
    Statement*  then_statement;
    Statement*  else_statement;
    Scope*      scope;

public:
    IfStatement(Expression* condition,
                Statement*  then_statement) : condition(condition),
                                              then_statement(then_statement) {}

    IfStatement(Expression* condition,
                Statement*  then_statement,
                Statement*  else_statement) : condition(condition),
                                              then_statement(then_statement),
                                              else_statement(else_statement) {}

    void initSymbolTree(Scope* parent);

    std::string toString() const override;
    
    // std::string toString() const override
    // {
    //     std::string result = std::string("<if:");
    //     result += (condition ? ("(" + *condition + ")") : "()");
    //     result += "then:{";
    //     if (then_statement) result += *then_statement;
    //     result += "}";
    //     if (else_statement) result += *else_statement;
    //     return result;
    // }
};




class DoStatement : public virtual Statement
{
private:
    Statement*  initialization;
    Expression* condition;
    Expression* update;
    Statement*  body;
    Scope*      scope;

public:
    DoStatement(Statement*  initialization,
                Expression* condition,
                Expression* update,
                Statement*  body) : initialization(initialization),
                                    condition(condition),
                                    update(update),
                                    body(body) {};

    void initSymbolTree(Scope* parent);

    std::string toString() const override;
    
    // std::string toString() const override
    // {
    //     std::string result = std::string("<do:(");
    //     result += (initialization ? (*initialization + ";") : ";");
    //     result += (condition ? (*condition + ";") : ";");
    //     if (update) result += *update;
    //     result += "{" + (body ? std::string(*body) : "") + "}>";
    //     return result;
    // }
};





class WhileStatement : public virtual Statement
{
private:
    Expression* condition;
    Statement* body;
    Scope* scope;

public:
    WhileStatement(Expression* condition,
                   Statement*  body) : condition(condition),
                                       body(body) {}

    void initSymbolTree(Scope* parent);

    std::string toString() const override;

    // std::string toString() const override
    // {
    //     std::string result = std::string("<while:(");
    //     result += (condition ? (*condition + ")") : ")");
    //     result += "{" + (body ? (*body + "}>") : "}>");
    //     return result;
    // }
};





#endif // Node_HPP