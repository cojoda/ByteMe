#ifndef AST_HPP
#define AST_HPP




#include <string>
#include <vector>
#include <iostream>


class AST;
class Program;
class Routines;
class Routine;
class Function;
class Procedure;
class Statements;
class Statement;




class AST {
public:
    AST() = default;
    virtual ~AST() = default;
    virtual std::string toString() const;
    virtual void print(std::ostream& os) const;
    friend std::ostream& operator<<(std::ostream& os, const AST& ast);
};




class Program : public AST
{
private:
    std::string* name;
    Routines*    routines;
public:
    Program(std::string* name,
            Routines*    routines);
    std::string toString() const;
    void print(std::ostream& os) const override;
};


class Routines : public AST 
{
private:
    std::vector<Routine*>* routines_list;
public:
    Routines();
    Routines(Routines* routines,
             Routine*  routine);
    std::string toString() const;
    void print(std::ostream& os) const override;
};


class Routine : public virtual AST
{
public:
    Routine();
    virtual ~Routine();
    std::string toString() const;
    void print(std::ostream& os) const override;
};


class Function : public virtual Routine
{
private:
    std::string* type;
    std::string* name;
    std::string* parameters;
    std::string* block;
public:
    Function();
    Function(std::string* type,
             std::string* name,
             std::string* parameters,
             std::string* block);
    std::string toString() const;
    void print(std::ostream& os) const override;
};


class Procedure : public virtual Routine
{
private:
    std::string* type;
    std::string* parameters;
    std::string* block;
public:
    Procedure();
    Procedure(std::string* type,
              std::string* parameters,
              std::string* block);
    std::string toString() const;
    void print(std::ostream& os) const override;
};



class Statements : public AST
{
private:
    std::vector<Statement*>* statement_list;
public:
    Statements();
    Statements(Statements* statements,
               Statement* statement);
    std::string toString() const;
    void print(std::ostream& os) const override;
};




class Statement : public virtual AST
{
public:
    Statement() = default;
    virtual ~Statement() = default;
    std::string toString() const;
    void print(std::ostream& os) const override;
};




// class Block : public virtual Statement
// {

// };


// class If_Statement : public virtual Statement
// {

// };


// class Do_Statement : public virtual Statement
// {

// };


// class Expression : public virtual Statement
// {

// };


// class Declaration : public virtual Statement
// {

// };

// class Assignment : public virtual Statement
// {

// };


// class Return : public virtual Statement
// {

// };





#endif // AST_HPP