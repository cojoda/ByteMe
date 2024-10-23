#ifndef AST_HPP
#define AST_HPP

#include <string>
#include <vector>
#include <iostream>

class Program;
class RoutineGroup;
class Function;
class Procedure;
class StatementGroup;
class VariableGroup;
class Declaration;




class AST
{
public:
    AST() = default;
    virtual ~AST() = default;

    virtual std::string toString() const;
    virtual void print(std::ostream& os) const;
    friend std::ostream& operator<<(std::ostream& os, const AST& ast);
};



class Statement : public virtual AST
{
public:
    Statement() = default;
    virtual ~Statement() = default;

    virtual std::string toString() const override;;
    virtual void print(std::ostream& os) const override;
};



class Routine : public virtual Statement
{
public:
    Routine();
    virtual ~Routine();

    virtual std::string toString() const override;;
    virtual void print(std::ostream& os) const override;
};



class Expression : public virtual Statement
{
public:
    Expression() = default;
    virtual ~Expression() = default;

    virtual std::string toString() const override;;
    virtual void print(std::ostream& os) const override;
};



class Variable : public virtual Expression
{
public:
    Variable() = default;
    virtual ~Variable() = default;

    virtual std::string toString() const override;;
    virtual void print(std::ostream& os) const override;
};



class Reference : public virtual Variable
{
public:
    Reference() = default;
    virtual ~Reference() = default;

    virtual std::string toString() const override;;
    virtual void print(std::ostream& os) const override;
};



class StatementGroup : public virtual Statement
{
private:
    std::vector<Statement*>* statement_list;
public:
    StatementGroup();

    StatementGroup(StatementGroup* statement_group,
                   Statement*      statement);

    std::string toString() const override;;
    void print(std::ostream& os) const override;
};



class RoutineGroup : public AST 
{
private:
    std::vector<Routine*>* routine_list;
public:
    RoutineGroup();

    RoutineGroup(RoutineGroup* routine_group,
                 Routine*      routine);

    std::string toString() const override;;
    void print(std::ostream& os) const override;
};



class ExpressionGroup : public virtual Expression
{
private:
    std::vector<Expression*>* expression_list;
public:
    ExpressionGroup(Expression*      expression);

    ExpressionGroup(ExpressionGroup* expression_group,
                    Expression*      expression);

    std::string toString() const override;;
    void print(std::ostream& os) const override;
};



class VariableGroup : public virtual Variable
{
private:
    std::vector<Variable*>* variable_list;
public:
    VariableGroup(Variable*      variable);

    VariableGroup(VariableGroup* variable_group,
                  Variable*      variable);

    std::string toString() const override;;
    void print(std::ostream& os) const override;
};



class Program : public AST
{
private:
    std::string*  name;
    RoutineGroup* routine_group;
public:
    Program(std::string*  name,
            RoutineGroup* routine_group);

    std::string toString() const override;;
    void print(std::ostream& os) const override;
};



class Function : public virtual Routine
{
private:
    std::string*    type;
    std::string*    name;
    Declaration*    parameters;
    StatementGroup* block;
public:
    Function();

    Function(std::string*    type,
             std::string*    name,
             Declaration*    parameters,
             StatementGroup* block);

    std::string toString() const override;;
    void print(std::ostream& os) const override;
};



class Procedure : public virtual Routine
{
private:
    std::string*    type;
    Declaration*    parameters;
    StatementGroup* block;
public:
    Procedure();

    Procedure(std::string*    type,
              Declaration*    parameters,
              StatementGroup* block);

    std::string toString() const override;;
    void print(std::ostream& os) const override;
};



class If_Statement : public virtual Statement
{
private:
    Expression* condition;
    Statement*  then_statement;
    Statement*  else_statement;
public:
    If_Statement(Expression* condition,
                 Statement*  then_statement);

    If_Statement(Expression* condition,
                 Statement*  then_statement,
                 Statement*  else_statement);

    std::string toString() const override;;
    void print(std::ostream& os) const override;
};



class Do_Statement : public virtual Statement
{
private:
    Variable*   initialization;
    Expression* condition;
    Expression* update;
    Statement*  block;
public:
    Do_Statement(Variable*   initialization,
                 Expression* condition,
                 Expression* update,
                 Statement*  block);

    std::string toString() const override;;
    void print(std::ostream& os) const override;
};



class Return : public virtual Statement
{
private:
    Expression* value;
public:
    Return();

    Return(Expression* value);

    std::string toString() const override;;
    void print(std::ostream& os) const override;
};



class Declaration : public virtual Variable
{
private:
    std::string*   type;
    VariableGroup* variable_group;
public:
    Declaration(std::string*   type,
                VariableGroup* variable_group);

    std::string toString() const override;;
    void print(std::ostream& os) const override;
};



class Assignment : public virtual Variable
{
private:
    Reference*   lvalue;
    Expression*  rvalue;
    std::string* operation;
public:
    Assignment(Reference*   lvalue,
               Expression*  rvalue,
               std::string* operation);

    std::string toString() const override;;
    void print(std::ostream& os) const override;
};


class Atomic : public virtual Reference
{
private:
    std::string* name;
public:
    Atomic(std::string* name);

    std::string toString() const;
    void print(std::ostream& os) const override;
};



class Array : public virtual Reference
{
private:
    std::string* name;
    Expression*  index;
public:
    Array(std::string* name);

    Array(std::string* name,
          Expression*  index);

    std::string toString() const override;;
    void print(std::ostream& os) const override;
};




class Constant : public virtual Expression
{
private:
    void* value;
public:
    Constant(void* value);

    std::string toString() const override;;
    void print(std::ostream& os) const override;
};



class Arithmetic : public virtual Expression
{
private:
    Expression*  loperand;
    Expression*  roperand;
    std::string* operation;
public:
    Arithmetic(Expression*       operand,
                    std::string* operation);

    Arithmetic(Expression*        loperand,
                    Expression*   roperand,
                    std::string*  operation);

    std::string toString() const override;;
    void print(std::ostream& os) const override;
};



class Boolean : public virtual Expression
{
private:
    Expression*  loperand;
    Expression*  roperand;
    std::string* operation;
public:
    Boolean(Expression*  loperand,
            Expression*  roperand,
            std::string* operation);

    Boolean(Expression*  operand,
            std::string* operation);

    std::string toString() const override;
    void print(std::ostream& os) const override;
};



#endif // AST_HPP