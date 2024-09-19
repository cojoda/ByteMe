// #define yyFlexLexer ArgsFlexLexer
// #include <FlexLexer.h>
// #undef yyFlexLexer

#define yyFlexLexer ByteFlexLexer
#include <FlexLexer.h>
#undef yyFlexLexer



// #include <fstream>
// #include <sstream>
// #include <string>



// std::ofstream lex_ofstream;
// std::string ifilename;
// std::string ofilename;



int main(int argc, char** argv) {

//     // arg lexing

//     // aggregate argv into a single string
//     std::string args;
//     for(int i = 1; i < argc; i++) args.append(argv[i]).append(" ");

//     // i/ostreams for arg_flexlexer
//     std::istringstream arg_istream(args);
//     std::ostringstream arg_ostream;

//     // lex args
//     FlexLexer* arg_flexlexer = new ArgsFlexLexer(arg_istream, arg_ostream);
//     arg_flexlexer->yylex();
//     delete arg_flexlexer;

//     // Compiler lexing
//     std::istream* input_stream;
//     std::ifstream file_input_stream;
    
//     // Check if input filename is provided (from args)
//     if (!ifilename.empty()) {
//         // Open input file
//         file_input_stream.open(ifilename);
//         if (!file_input_stream.is_open()) {
//             std::cerr << "Error: Could not open input file: " << ifilename << std::endl;
//             return EXIT_FAILURE;
//         }
//         input_stream = &file_input_stream;  // Use file input
//     } else {
//         // Use standard input (e.g., redirection from shell)
//         input_stream = &std::cin;
//     }

//     // Open output file for writing
//     lex_ofstream.open(ofilename);
//     if (!lex_ofstream.is_open()) {
//         std::cerr << "Error: Could not open output file: " << ofilename << std::endl;
//         return EXIT_FAILURE;
//     }

    // Lex input using the primary lexer
    FlexLexer* flexlexer = new ByteFlexLexer();
    flexlexer->yylex();
    delete flexlexer;

    // // Close output file
    // lex_ofstream.close();
    
    // // Close input file if it was used
    // if (file_input_stream.is_open()) {
    //     file_input_stream.close();
    // }

    exit(EXIT_SUCCESS);
}
