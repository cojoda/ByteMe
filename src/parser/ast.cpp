#include "ast.hpp"



Program::Program(std::string* name, std::string* routines) : name(name), routines(routines) {}

std::ostream& operator<<(std::ostream& os, const Program& program) {
    os << "<Program," << *(program.name) << ", " << *(program.routines) << ">";
    return os;
}



// Routines::Routines() {};

// Routines::Routines(Routines* routines, Routine* routine)
// {
//     if (routines == nullptr)
//         this->routines = new std::vector<Routine*>;
//     this->routines->push_back(routine);
// }

// bool Routines::operator==(std::nullptr_t) const
// {
//     return routines == nullptr;
// }




// std::ostream& operator<<(std::ostream& os, const Routines& rs)
// {
//     // for (Routine routine : rs.routines) {
//     //     os << routine;
//     // }
// }




// Routine::Routine(std::string* type, std::string* name, std::string* parameters, std::string* block)
//         : type(type), name(name), parameters(parameters), block(block) {}

// std::ostream& operator<<(std::ostream& os, const Routine& routine)
// {
//     os << "<Routine," << routine.name << ">";
// }