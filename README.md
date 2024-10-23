
# ByteMe Lexer and Parser

## Project Overview
This project is a lexer and parser designed for a custom language (F24). The lexer reads the source code, processes keywords, operators, punctuation, and identifiers, and returns corresponding tokens. The parser processes these tokens, building an Abstract Syntax Tree (AST) for further analysis. The project uses `flex` to define lexical rules and `bison` to define grammar rules for the parser.

## Repository URL
You can find the project repository at: [ByteMe GitHub](https://github.com/cojoda/ByteMe.git).

## How to Build and Run

### Prerequisites
- `flex` should be installed on your system.
- `bison` should be installed for grammar parsing.
- A C++ compiler (such as `g++` or `clang`) is required to compile the generated lexer and parser code.

### Building the Lexer and Parser
To build the lexer and parser, use the provided Makefile. Run the following command in the root directory of the project:

```bash
make
```

This will:
- Compile the `byte.cpp`, `lexer.cpp`, and `parser.cpp` source files.
- Generate an executable named `byte` in the `bin/` directory.

### Running the Lexer and Parser
Once built, you can run the lexer and parser on example files located in the `examples/` directory. For example, to process the `mg.f24` file and display the output, use the following command:

```bash
./bin/byte < examples/mg.f24
```

If you'd like to save the output to a file, you can redirect it like this:

```bash
./bin/byte < examples/mg.f24 > output.txt
```

You can replace `mg.f24` with `brain.f24` to run another example.

### Running Tests
You can run tests on all `.f24` files in the `examples/` directory by executing the following command:

```bash
make test
```

This will:
- Processs `mg.f24` file in the `examples/` directory.
- Output the results to `std::out`

For example, after running `make test`, the output for `mg.f24` will be output to `std::out`

### Example Files
The project includes two example `.f24` files:
- `brain.f24`
- `mg.f24`

These are located in the `examples/` directory.

## Testing Environments
This project was tested using:
- **LLVM/Clang and Flex/Bison** from the macOS Xcode command line tools.
- **GCC and Flex/Bison** from Homebrew on macOS.

Both environments successfully built and executed the lexer and parser.

## Flex and Bison Information
The `flex` lexical analyzer and `bison` parser generator are used in this project. If you need more information or want to download these tools, you can find them at:
- Flex URL: https://github.com/westes/flex
- Bison URL: https://www.gnu.org/software/bison/

## Makefile
The provided `Makefile` automates the build, clean, and test processes. Key commands include:
- `make`: Builds the lexer, parser, and their dependencies.
- `make test`: Runs tests on all example `.f24` files and stores the results in `test/outputs/`.
- `make clean`: Removes all generated files and directories, including binaries and test outputs.
