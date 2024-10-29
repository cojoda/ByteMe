#ifndef AST_HPP
#define AST_HPP

#include <string>
#include <vector>
#include <iostream>




class Program;
class Routine;
class Declaration;
class Reference;
class Expression;
class UniDec;





class AST
{
public:
    AST() = default;
    virtual ~AST() = default;

    virtual std::string toString() const;
    virtual void print(std::ostream& os) const;
    friend std::ostream& operator<<(std::ostream& os, const AST& ast);
    friend std::string operator+(const AST& ast, const std::string& str);
    friend std::string operator+(const std::string& str, const AST& ast);
    friend std::string& operator+=(std::string& lhs, const AST& rhs);
    operator std::string() const { return toString(); }
};






class Statement : public virtual AST
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
    Expression* index;
public:
    Reference(std::string *value) : name(value) {}

    Reference(std::string* name,
              Expression* index) : name(name),
                                   index(index) {};

    std::string toString() const override
    {
        std::string result = std::string("<reference:");
        result += (name ? *name : "NULL,");
        result += (index ? std::string(*index ) : "NULL") + ">";
        std::cerr << result << std::endl;
        return result;
    }
};






class Return : public virtual Statement
{
private:
    Expression* return_value;
public:
    Return() = default;
    Return(Expression* return_value) : return_value(return_value) {};

    std::string toString() const override
    {
        std::string result = std::string("<return:");
        if (return_value) result += *return_value;
        return result + ">";
    }
};






template <typename T, typename V>
class Block : public virtual V
{
private:
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
    std::string toString() const override
    {
        std::string result = std::string();
        if (!list) return result;
        for (T item : *list) {
            if (item) result += *item + "\n";
        }
        return result;
    }
};






class Program : public virtual AST
{
private:
    std::string*          name;
    Block<Routine*, AST>* body;

public:
    Program(std::string*           name,
            Block<Routine*, AST>* routine_block) : name(name),
                                                   body(routine_block) {}

    std::string toString() const
    {
        std::string result = std::string("<Program:");
        result += (name ? *name : "null");
        result += "{" + (body ? std::string(*body ) : "null") + "}";
        return result;
    }
};






class Routine : public virtual Statement
{
private:
    std::string* name;
    Block<Declaration*, Statement>* parameters;
    Block<Statement*, Statement>*   body;
    std::string* type;

public:
    Routine(std::string*                    name,
            Block<Declaration*, Statement>* parameters,
            Block<Statement*, Statement>*   body) : name(name),
                                                    parameters(parameters),
                                                    body(body) {}

    Routine(std::string*                    name,
            Block<Declaration*, Statement>* parameters,
            Block<Statement*, Statement>*   body,
            std::string*                    type) : name(name),
                                                    parameters(parameters),
                                                    body(body),
                                                    type(type) {}

    virtual ~Routine() = default;

    std::string toString() const override
    {
        std::string result = std::string("<");
        result += (type ? ("Function:" + *type + ",") : ("Procedure:"));
        result += (name ? *name : "null");
        result += "(";
        if (parameters) result += *parameters;
        result += "){";
        result += (body ? std::string(*body) : "null");
        return result + "}";
    }
};






class Declaration : public virtual Statement
{
private:
    std::string*         type;
    Block<UniDec*, Statement>* name_list;

public:
    Declaration(std::string*         type,
                Block<UniDec*, Statement>* name_list) : type(type),
                                                  name_list(name_list) {}

    std::string toString() const override
    {
        std::string result = std::string("<Declaration:");
        result += (type ? *type : "null_type");
        result += "(";
        if (name_list) result += *name_list;
        return result + ")>";
    }
};






class UniDec : public virtual AST
{
private:
    Reference*  name;
    Expression* value;

public:
    UniDec(Reference* name) : name(name) {}

    UniDec(Reference*  name,
           Expression* value) : name(name),
                                value(value) {}

    std::string toString() const override
    {
        std::string result = std::string("<");
        result += (name ? std::string(*name) : "NULL");
        result += (value ? (":=" + *value) : ":=NULL");
        return result + ">";
    }
};





class Constant : public virtual Expression
{
private:
    std::string* value;

public:
    Constant(std::string* value) : value(value) {}

    std::string toString() const override
    {
        return (value ? *value : "NULL");
    }
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

    std::string toString() const override
    {
        std::string result = std::string("<");
        result += (lvalue ? std::string(*lvalue) : "NULL");
        result += (value ? ("," + *value): ",NULL") + ">";
        return result;
    }
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

    std::string toString() const override
    {
        std::string result = std::string("<");
        result += (operation ? *operation : "NULL ");
        result += (operand ? std::string(*operand) : " NULL") + ">";
        return result;
    }
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

    std::string toString() const override
    {
        std::string result = std::string("<");
        result += (loperand ? std::string(*loperand) : "NULL ");
        result += (operation ? *operation : " NULL ");
        result += (roperand ? std::string(*roperand) : " NULL") + ">";
        return  result;
    }
};





class RoutineCall : public virtual Expression
{
private:
    std::string*             name;
    Block<Expression*, AST>* argument_list;

public:
    RoutineCall(std::string*             name,
                Block<Expression*, AST>* argument_list) : name(name),
                                                          argument_list(argument_list) {}

    std::string toString() const override
    {
        std::string result = std::string("<");
        result += (name ? *name : "NULL");
        result += "(";
        result += (argument_list ? std::string(*argument_list ) : "NULL") + ")>";
        return result;
    }
};





class IfStatement : public virtual Statement
{
private:
    Expression* condition;
    Statement*  then_statement;
    Statement*  else_statement;

public:
    IfStatement(Expression* condition,
                Statement*  then_statement) : condition(condition),
                                              then_statement(then_statement) {}

    IfStatement(Expression* condition,
                Statement*  then_statement,
                Statement*  else_statement) : condition(condition),
                                              then_statement(then_statement),
                                              else_statement(else_statement) {}

    std::string toString() const override
    {
        std::string result = std::string("<if:");
        result += (condition ? ("(" + *condition + ")") : "()");
        result += "then:{";
        if (then_statement) result += *then_statement;
        result += "}";
        if (else_statement) result += *else_statement;
        return result;
    }
};




class DoStatement : public virtual Statement
{
private:
    Statement*  initialization;
    Expression* condition;
    Expression* update;
    Statement*  body;

public:
    DoStatement(Statement*  initialization,
                 Expression* condition,
                 Expression* update,
                 Statement*  body) : initialization(initialization),
                                      condition(condition),
                                      update(update),
                                      body(body) {};

    std::string toString() const override
    {
        std::string result = std::string("<do:(");
        result += (initialization ? (*initialization + ";") : ";");
        result += (condition ? (*condition + ";") : ";");
        if (update) result += *update;
        result += "{" + (body ? std::string(*body) : "") + "}>";
        return result;
    }
};


class WhileStatement : public virtual Statement
{
private:
    Expression* condition;
    Statement* body;
public:
    WhileStatement(Expression* condition, Statement* body) : condition(condition), body(body) {}

    std::string toString() const override
    {
        std::string result = std::string("<while:(");
        result += (condition ? (*condition + ")") : ")");
        result += "{" + (body ? (*body + "}>") : "}>");
        return result;
    }
};


#endif // AST_HPP