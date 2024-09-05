#define yyFlexLexer ArgsFlexLexer
#include <FlexLexer.h>
#undef yyFlexLexer

#define yyFlexLexer ByteFlexLexer
#include <FlexLexer.h>
#undef yyFlexLexer

#include <fstream>
#include <sstream>
#include <string>

std::ofstream lex_ofstream;
std::string ifilename;
std::string ofilename;

int main(int argc, char** argv) {

    // aggregate argv into a single string
    std::string args;
    for(int i = 1; i < argc; i++) args.append(argv[i]).append(" ");

    // i/ostreams for arg_flexlexer
    std::istringstream arg_istream(args);
    std::ostringstream arg_ostream;

    // lex args
    FlexLexer* arg_flexlexer = new ArgsFlexLexer(arg_istream, arg_ostream);
    arg_flexlexer->yylex();
    delete arg_flexlexer;

    // i/ostreams for primary lexer using filenames from args
    std::ifstream lex_ifstream(ifilename);
    lex_ofstream = std::ofstream(ofilename);

    // lex input file
    FlexLexer* flexlexer = new ByteFlexLexer(lex_ifstream, lex_ofstream);
    flexlexer->yylex();
    delete flexlexer;

    lex_ofstream.close();

    exit(EXIT_SUCCESS);
}