#include "ast.hpp"




    /* AST */

std::string AST::toString() const
{
    std::string* result = new std::string("AST Class Output");
    return *result;
}

void AST::print(std::ostream& os) const
{
    os << toString();
}

std::ostream& operator<<(std::ostream& os, const AST& ast)
{
    ast.print(os);
    return os;
}




    /* Statement */

std::string Statement::toString() const
{
    std::string* result = new std::string("Statement class output");
    return *result;
}

void Statement::print(std::ostream& os) const
{
    os << toString();
}




    /* Routine */

Routine::Routine() {}
Routine::~Routine() {}

std::string Routine::toString() const
{
    std::string* result = new std::string("Routine class output");
    return *result;
}

void Routine::print(std::ostream& os) const
{
    os << toString();
}




    /* Expression */

std::string Expression::toString() const
{
    std::string* result = new std::string("Expression class output");
    return *result;
}

void Expression::print(std::ostream& os) const
{
    os << toString();
}




    /* Variable */

std::string Variable::toString() const
{
    std::string* result = new std::string("Variable class output");
    return *result;
}

void Variable::print(std::ostream& os) const
{
    os << toString();
}




    /* Reference */

std::string Reference::toString() const
{
    return std::string("Reference class output");
}

void Reference::print(std::ostream& os) const
{
    os << toString();
}




    /* StatementGroup */

StatementGroup::StatementGroup() {};

StatementGroup::StatementGroup(StatementGroup* statement_group, Statement* statement)
{
    if (statement_group->statement_list == nullptr)
    {
        statement_group->statement_list = new std::vector<Statement*>();
    }
    statement_group->statement_list->push_back(statement);
    this->statement_list = statement_group->statement_list;
}

std::string StatementGroup::toString() const
{
    std::string* result = new std::string();
    for (Statement* item : *statement_list) {
        if (item) {
            result->append(item->toString() + "\n");
        }
    }
    return *result;
}

void StatementGroup::print(std::ostream& os) const
{
    os << toString();
}




    /* RoutineGroup */

RoutineGroup::RoutineGroup() {};

RoutineGroup::RoutineGroup(RoutineGroup* routine_group, Routine* routine)
{
    if (routine_group->routine_list == nullptr)
    {
        routine_group->routine_list = new std::vector<Routine*>();
    }
    routine_group->routine_list->push_back(routine);
    this->routine_list = routine_group->routine_list;
}

std::string RoutineGroup::toString() const
{
    std::string* result = new std::string();
    for (Routine* item : *routine_list) {
        if (item) {
            result->append(item->toString() + "\n");
        }
    }
    return *result;
}

void RoutineGroup::print(std::ostream& os) const
{
    os << toString();
}




    /* ExpressionGroup  */

ExpressionGroup::ExpressionGroup(Expression* expression)
{
    if (expression_list == nullptr)
        expression_list = new std::vector<Expression*>();
    expression_list->push_back(expression);
}

ExpressionGroup::ExpressionGroup(ExpressionGroup* expression_group, Expression* expression)
{
    if (expression_group->expression_list == nullptr)
        expression_group->expression_list = new std::vector<Expression*>();
    expression_group->expression_list->push_back(expression);
    this->expression_list = expression_group->expression_list;
}

std::string ExpressionGroup::toString() const
{
    std::string* result = new std::string();
    for (Expression* item : *expression_list) {
        if (item) {
            result->append(item->toString() + "\n");
        }
    }
    return *result;
}

void ExpressionGroup::print(std::ostream& os) const
{
    os << toString();
}




    /* VariableGroup  */

VariableGroup::VariableGroup(Variable* variable)
{
    if (variable_list == nullptr)
        variable_list = new std::vector<Variable*>();
    variable_list->push_back(variable);
}

VariableGroup::VariableGroup(VariableGroup* variable_group,
                             Variable*      variable)
{
    if (variable_group->variable_list == nullptr)
        variable_group->variable_list = new std::vector<Variable*>();
    variable_group->variable_list->push_back(variable);
    this->variable_list = variable_group->variable_list;
}

std::string VariableGroup::toString() const
{
    std::string* result = new std::string();
    for (Variable* item : *variable_list) {
        if (item) {
            result->append(item->toString() + "\n");
        }
    }
    return *result;
}

void VariableGroup::print(std::ostream& os) const
{
    os << toString();
}




    /* Program */

Program::Program(std::string* name, RoutineGroup* routine_group) : name(name), routine_group(routine_group) {}

std::string Program::toString() const
{
    // std::string* result = new std::string("");
    std::string* result = new std::string("(program:" + *name + "\n" + routine_group->toString() + ")");
    return *result;
}

void Program::print(std::ostream& os) const
{
    os << toString();
}



    /* Function */

Function::Function() {};

Function::Function(std::string*       type,
                   std::string*       name,
                   Declaration*       parameters,
                   StatementGroup*    block): type(type), name(name), parameters(parameters), block(block) {}

std::string Function::toString() const
{
    std::string* result = new std::string("Statement class output");
    return *result;
}

void Function::print(std::ostream& os) const
{
    os << toString();
}



    /* Procedure */

Procedure::Procedure() {};

Procedure::Procedure(std::string*      type,
                     Declaration*      parameters,
                     StatementGroup*   block) : type(type), parameters(parameters), block(block) {}

std::string Procedure::toString() const
{
    std::string* result = new std::string("Statement class output");
    return *result;
}

void Procedure::print(std::ostream& os) const
{
    os << toString();
}




    /* If Statement */
If_Statement::If_Statement(Expression* condition,
                           Statement*  then_statement) : condition(condition),
                                                          then_statement(then_statement) {}
If_Statement::If_Statement(Expression* condition,
                           Statement*  then_statement,
                           Statement*  else_statement) : condition(condition),
                                                          then_statement(then_statement),
                                                          else_statement(else_statement) {}

std::string If_Statement::toString() const
{
    std::string result = std::string("if then ");
    if (else_statement != nullptr)
        result.append("else");
    return result;
}

void If_Statement::print(std::ostream& os) const
{
    os << toString();
}




    /* Do Statement */

Do_Statement::Do_Statement(Variable*   initialization,
                           Expression* condition,
                           Expression* update,
                           Statement*  block) : initialization(initialization),
                                                condition(condition),
                                                update(update),
                                                block(block) {};

std::string Do_Statement::toString() const
{
    return std::string("Do_Statement class output");
}

void Do_Statement::print(std::ostream& os) const
{
    os << toString();
}



    /* Return */

Return::Return() {};
Return::Return(Expression* value) : value(value) {};

std::string Return::toString() const
{
    std::string* result = new std::string("Return class output");
    return *result;
}

void Return::print(std::ostream& os) const
{
    os << toString();
}




    /* Declaration */

Declaration::Declaration(std::string*   type,
                         VariableGroup* variable_group) : type(type),
                                                          variable_group(variable_group) {};

std::string Declaration::toString() const
{
    return std::string("Declaration Class output");
}

void Declaration::print(std::ostream& os) const
{
    os << toString();
}



    /* Assignment */

Assignment::Assignment(Reference*   lvalue,
                       Expression*  rvalue,
                       std::string* operation) : lvalue(lvalue), rvalue(rvalue), operation(operation) {};

std::string Assignment::toString() const
{
    std::string* result = new std::string("Assignment class output");
    return *result;
}

void Assignment::print(std::ostream& os) const
{
    os << toString();
}




    /* Atomic */

Atomic::Atomic(std::string* name) : name(name) {};

std::string Atomic::toString() const
{
    return std::string("Atomic Class output");
}

void Atomic::print(std::ostream& os) const
{
    os << toString();
}




    /* Array */

Array::Array(std::string* name) : name(name) {};

Array::Array(std::string* name, Expression* index) : index(index) {}; 

std::string Array::toString() const
{
    return std::string("Array Class output");
}

void Array::print(std::ostream& os) const
{
    os << toString();
}




 /* Constants */

Constant::Constant(void* value) : value(value) {}

std::string Constant::toString() const
{
    std::string* result = new std::string("Constant class output");
    return *result;
}

void Constant::print(std::ostream& os) const
{
    os << toString();
}



    /* Arithmetic */

Arithmetic::Arithmetic(Expression*  operand,
                                 std::string* operation) : roperand(operand),
                                                           operation(operation) {};

Arithmetic::Arithmetic(Expression*  loperand,
                       Expression*  roperand,
                       std::string* operation) : loperand(loperand),
                                                 roperand(roperand),
                                                 operation(operation){};

std::string Arithmetic::toString() const
{
    std::string* result = new std::string("Arithmetic class output");
    return *result;
}

void Arithmetic::print(std::ostream& os) const
{
    os << toString();
}



    /* Boolean */

Boolean::Boolean(Expression*  operand,
                           std::string* operation) : roperand(operand),
                                                     operation(operation) {};

Boolean::Boolean(Expression*  loperand,
                 Expression*  roperand,
                 std::string* operation) : loperand(loperand),
                                           roperand(roperand),
                                           operation(operation) {};

std::string Boolean::toString() const
{
    std::string* result = new std::string("Boolean class output");
    return *result;
}

void Boolean::print(std::ostream& os) const
{
    os << toString();
}


