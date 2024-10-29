# Prioritize homebrew installed paths of gcc/flex/bison on macos systems with xcode command line tools installed

GCC := $(shell if [ -x /opt/homebrew/bin/g++-14 ]; then echo /opt/homebrew/bin/g++-14; else echo g++; fi)

BREW_FLEX := /opt/homebrew/opt/flex
FLEX_INCLUDE := $(shell [ -d $(BREW_FLEX) ] && echo "-I $(BREW_FLEX)/include")
FLEX := $(shell if [ -x /opt/homebrew/opt/flex/bin/flex ]; then echo /opt/homebrew/opt/flex/bin/flex; else echo flex; fi)

BISON := $(shell if [ -x /opt/homebrew/opt/bison/bin/bison ]; then echo /opt/homebrew/opt/bison/bin/bison; else echo bison; fi)



# g++
CXX      := $(GCC)
CXXINCLUDE := -I .
CXXFLAGS := --std=c++11 $(FLEX_INCLUDE) $(CXXINCLUDE)



# ByteMe

bin/byte: bin obj/ast.o obj/lexer.o obj/parser.o obj/byte.o
	$(CXX) $(CXXFLAGS) obj/ast.o obj/lexer.o obj/parser.o obj/byte.o -o bin/byte

bin:
	mkdir bin



# Object Files

obj/ast.o: obj src/ast/ast.cpp src/ast/ast.hpp
	$(CXX) $(CXXFLAGS) -c src/ast/ast.cpp -o obj/ast.o

obj/lexer.o: obj src/lexer/lexer.cpp src/parser/parser.hpp src/lexer/token.hpp
	$(CXX) $(CXXFLAGS) -c src/lexer/lexer.cpp -o obj/lexer.o

obj/parser.o: obj src/parser/parser.cpp src/parser/parser.hpp src/ast/ast.hpp
	$(CXX) $(CXXFLAGS) -c src/parser/parser.cpp -o obj/parser.o

obj/byte.o: obj src/byte.cpp
	$(CXX) $(CXXFLAGS) -c src/byte.cpp -o obj/byte.o

obj:
	mkdir obj



# Bison & Flex

src/lexer/lexer.cpp: src/lexer/lexer.l
	$(FLEX) -o src/lexer/lexer.cpp src/lexer/lexer.l

src/parser/parser.cpp src/parser/parser.hpp: src/parser/parser.y
	$(BISON) -v -Dparse.trace -d src/parser/parser.y -o src/parser/parser.cpp



# Misc

clean:
	rm -f src/lexer/lexer.cpp
	rm -f src/parser/parser.cpp src/parser/parser.hpp src/parser/stack.hh
	rm -f src/lexer/prelexer.cpp src/parser/preparser.cpp src/parser/parser.output
	rm -rf obj bin
	clear && clear
	

test-mg: clean bin/byte
	bin/byte < examples/mg.f24

# Test parser grammar for conflicts & test against all functions/procedures in mg.f24
GRAMMAR_TESTS := $(wildcard tests/grammar/*.f24)
grammar: bin/byte $(GRAMMAR_TESTS)
	@echo $(shell make -s clean)
	@echo $(shell make -s)
	clear && clear
	@/opt/homebrew/opt/bison/bin/bison -d src/parser/parser.y -o src/parser/parser.cpp \
    2>&1 | tee /tmp/bison_output.txt | grep -iE 'shift/reduce|reduce/reduce' \
    | sed -nE 's/.*(warning: [0-9]+ (shift|reduce)\/reduce conflict[s]?).*/\1/p'; \
    if [ ! -s /tmp/bison_output.txt ]; then echo "No shift/reduce or reduce/reduce conflicts found."; fi
	@for testfile in $(GRAMMAR_TESTS); do \
		echo "Running $$testfile" && bin/byte < $$testfile || exit 1; \
	done
	@echo "Running tests/grammar/mg.f24" && bin/byte < tests/grammar/mg.f24 
	@echo "All tests passed!"
	



prelexer: obj src/lexer/lexer.cpp src/parser/parser.hpp src/lexer/token.hpp
	$(CXX) $(CXXFLAGS) $(CXXINCLUDE) -E src/lexer/lexer.cpp -o src/lexer/prelexer.cpp  

preparser: obj src/parser/parser.cpp src/parser/parser.hpp src/ast/ast.hpp
	$(CXX) $(CXXFLAGS) $(CXXINCLUDE) -E src/parser/parser.cpp -o src/parser/preparser.cpp