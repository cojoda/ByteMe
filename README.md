# Morph Lexer

## Project Overview
This project is a lexer designed for a custom language (F24). The lexer reads the source code, processes keywords, operators, punctuation, and identifiers, and returns corresponding tokens. It uses `flex` to define lexical rules and process input.

## Repository URL
You can find the project repository at: [Morph GitHub](https://github.com/cojoda/Morph.git).

## How to Build and Run

### Prerequisites
- `flex` should be installed on your system.
- A C++ compiler (such as `g++` or `clang`) is required to compile the generated lexer code.

### Building the Lexer
To build the lexer, simply use the provided Makefile. Run the following command in the root directory of the project:

```bash
make
```

This will:
- Compile the `morph.cpp` and `lexer.cpp` source files.
- Generate an executable named `morph` in the `bin/` directory.

### Running the Lexer
Once built, you can run the lexer on example files located in the `examples/` directory. For example, to process the `brain.f24` file and display the output, use the following command:

```bash
./bin/morph < examples/brain.f24
```

If you'd like to save the output to a file, you can redirect it like this:

```bash
./bin/morph < examples/brain.f24 > output.txt
```

You can replace `brain.f24` with `small.f24` or `mg.f24` to run other examples.

### Running Tests
You can run tests on all `.f24` files in the `examples/` directory by executing the following command:

```bash
make test
```

This will:
- Process all `.f24` files in the `examples/` directory.
- Output the results to corresponding `.txt` files in the `test/outputs/` directory.

For example, after running `make test`, the output for `brain.f24` will be stored in `test/outputs/brain.txt`.

### Example Files
The project includes three example `.f24` files:
- `brain.f24`
- `small.f24`
- `mg.f24`

These are located in the `examples/` directory.

## Testing Environments
This project was tested using:
- **LLVM/Clang and Flex** from the macOS Xcode command line tools.
- **GCC and Flex** from Pop!_OS.

Both environments successfully built and executed the lexer.

## Flex Information
The `flex` lexical analyzer is used in this project. If you need more information or want to download `flex`, you can find it at:  
- URL: https://github.com/westes/flex

## Makefile
The provided `Makefile` automates the build, clean, and test processes. Key commands include:
- `make`: Builds the lexer and its dependencies.
- `make test`: Runs tests on all example `.f24` files and stores the results in `test/outputs/`.
- `make clean`: Removes all generated files and directories, including binaries and test outputs.
