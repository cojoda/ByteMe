#include "ast.hpp"




    /* AST */

std::string AST::toString() const
{
    return "AST Class Output";
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

std::string operator+(const AST& ast, const std::string& str)
{
    return ast.toString() + str;
}

std::string operator+(const std::string& str, const AST& ast)
{
    return str + ast.toString();
}





    /* Statement */

std::string Statement::toString() const
{
    return "Statement class output";
}






    /* Routine */

Routine::Routine() {}
Routine::~Routine() {}

std::string Routine::toString() const
{
    return "Routine class output";
}






    /* Expression */

std::string Expression::toString() const
{
    return "Expression class output";
}






    /* Variable */

std::string Variable::toString() const
{
    return "Variable class output";
}






    /* Reference */

std::string Reference::toString() const
{
    return "Reference class output";
}






    /* StatementGroup */

StatementGroup::StatementGroup() {};

StatementGroup::StatementGroup(StatementGroup* statement_group,
                               Statement*      statement)
{
    if (statement_group == nullptr)
        statement_group = this;

    if (statement_group->statement_list == nullptr)
        statement_group->statement_list = new std::vector<Statement*>();
    
    statement_group->statement_list->push_back(statement);
    this->statement_list = statement_group->statement_list;
}

std::string StatementGroup::toString() const
{
    std::string result = std::string();
    for (Statement* item : *statement_list) {
        result += (item ? (*item + "\n") : "");
    }
    return result;
}






    /* RoutineGroup */

RoutineGroup::RoutineGroup() {};

RoutineGroup::RoutineGroup(RoutineGroup* routine_group,
                           Routine*      routine)
{
    if (routine_group == nullptr)
        routine_group = this;

    if (routine_group->routine_list == nullptr)
        routine_group->routine_list = new std::vector<Routine*>();

    routine_group->routine_list->push_back(routine);
    this->routine_list = routine_group->routine_list;
}

std::string RoutineGroup::toString() const
{
    std::string result = std::string();
    for (Routine* item : *routine_list) {
        result += (item ? (item->toString() + '\n') : "");
    }
    return result;
}






    /* ExpressionGroup  */

ExpressionGroup::ExpressionGroup(Expression* expression)
{
    if (expression_list == nullptr)
        expression_list = new std::vector<Expression*>();
    expression_list->push_back(expression);
}

ExpressionGroup::ExpressionGroup(ExpressionGroup* expression_group,
                                 Expression*      expression)
{
    if (expression_group->expression_list == nullptr)
        expression_group->expression_list = new std::vector<Expression*>();
    expression_group->expression_list->push_back(expression);
    this->expression_list = expression_group->expression_list;
}

std::string ExpressionGroup::toString() const
{
    std::string result = std::string();
    for (Expression* item : *expression_list) {
        result += (item ? item->toString() : "");
    }
    return result;
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
    std::string result = std::string();
    for (Variable* item : *variable_list) {
        result += (item ? item->toString() : "");
    }
    return result;
}






    /* Program */

Program::Program(std::string*  name,
                 RoutineGroup* routine_group) : name(name),
                                                routine_group(routine_group) {}

std::string Program::toString() const
{
    return "(program:" + *name
                       + "\n" + *routine_group + ")";
}





    /* Function */

Function::Function() {};

Function::Function(std::string*    type,
                   std::string*    name,
                   Declaration*    parameters,
                   StatementGroup* block): type(type),
                                           name(name),
                                           parameters(parameters),
                                           block(block) {}

std::string Function::toString() const
{
    return "(function:" + *type + ","
                        + *name + ","
                        + (parameters ? parameters->toString() : "")
                        + "\n" + *block + ")";
}





    /* Procedure */

Procedure::Procedure() {};

Procedure::Procedure(std::string*    name,
                     Declaration*    parameters,
                     StatementGroup* block) : name(name),
                                              parameters(parameters),
                                              block(block) {}

std::string Procedure::toString() const
{
    return "(procedure:" + *name + ","
                         + *parameters
                         + "\n\t" + block->toString() + ")";
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
    return "(if:" + *condition + "(then "
                  + "\n\t\t" + *then_statement + ")"
                  + (else_statement ? "(else\n\t\t" + *else_statement + ")" : ")");
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
    return "Do_Statement class output";
}





    /* Return */

Return::Return() {};
Return::Return(Expression* value) : value(value) {};

std::string Return::toString() const
{
    return "(Return:" + (value ? value->toString() : "") + ")";
}






    /* Declaration */

Declaration::Declaration(std::string*   type,
                         VariableGroup* variable_group) : type(type),
                                                          variable_group(variable_group) {};

std::string Declaration::toString() const
{
    return  (type           ? *type                      : "")
          + (variable_group ? variable_group->toString() : "");
}





    /* Assignment */

Assignment::Assignment(Reference*   lvalue,
                       Expression*  rvalue,
                       std::string* operation) : lvalue(lvalue),
                                                 rvalue(rvalue),
                                                 operation(operation) {};

std::string Assignment::toString() const
{
    return lvalue->toString() + *operation + rvalue->toString();
}





    /* Atomic */

Atomic::Atomic(std::string* name) : name(name) {};

std::string Atomic::toString() const
{
    return *name;
}






    /* Array */

Array::Array(std::string* name) : name(name) {};

Array::Array(std::string* name,
             Expression*  index) : index(index) {}; 

std::string Array::toString() const
{
    return (name  ? *name                : "")
         + (index ? ("[" + *index + "]") : "");
}






 /* Constants */

Constant::Constant(void* value) : value(value) {}

std::string Constant::toString() const
{
    return (value ? *((std::string*)value) : "");
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
    return (loperand  ? loperand->toString() : "")
         + (operation ? *operation           : "")
         + (roperand  ? roperand->toString() : "");
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
    return (loperand  ? loperand->toString() : "")
         + (operation ? *operation           : "")
         + (roperand  ? roperand->toString() : "");
}
