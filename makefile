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



# Morph

bin/morph: bin obj/symbol.o obj/ast.o obj/lexer.o obj/parser.o obj/morph.o
	$(CXX) $(CXXFLAGS) obj/symbol.o obj/ast.o obj/lexer.o obj/parser.o obj/morph.o -o bin/morph

bin:
	mkdir bin



# Object Files

obj/symbol.o: obj src/symbol/symbol.cpp src/symbol/symbol.hpp
	$(CXX) $(CXXFLAGS) -c src/symbol/symbol.cpp -o obj/symbol.o

obj/ast.o: obj src/ast/ast.cpp src/ast/ast.hpp
	$(CXX) $(CXXFLAGS) -c src/ast/ast.cpp -o obj/ast.o

obj/lexer.o: obj src/lexer/lexer.cpp src/parser/parser.hpp
	$(CXX) $(CXXFLAGS) -c src/lexer/lexer.cpp -o obj/lexer.o

obj/parser.o: obj src/parser/parser.cpp src/parser/parser.hpp src/ast/ast.hpp
	$(CXX) $(CXXFLAGS) -c src/parser/parser.cpp -o obj/parser.o

obj/morph.o: obj src/morph.cpp
	$(CXX) $(CXXFLAGS) -c src/morph.cpp -o obj/morph.o

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
	

test: clean bin/morph
	bin/morph < examples/mg.f24

test-conflicts: src/parser/parser.y
	@/opt/homebrew/opt/bison/bin/bison -d src/parser/parser.y -o src/parser/parser.cpp \
    2>&1 | tee /tmp/bison_output.txt | grep -iE 'shift/reduce|reduce/reduce' \
    | sed -nE 's/.*(warning: [0-9]+ (shift|reduce)\/reduce conflict[s]?).*/\1/p'; \
    if [ ! -s /tmp/bison_output.txt ]; then echo "No shift/reduce or reduce/reduce conflicts found."; fi

# Test parser grammar for conflicts & test against all functions/procedures in mg.f24
GRAMMAR_TESTS := $(wildcard tests/grammar/*.f24)
test-grammar: bin/morph $(GRAMMAR_TESTS)
	@echo $(shell make -s clean)
	@echo $(shell make -s)
	clear && clear
	@/opt/homebrew/opt/bison/bin/bison -d src/parser/parser.y -o src/parser/parser.cpp \
    2>&1 | tee /tmp/bison_output.txt | grep -iE 'shift/reduce|reduce/reduce' \
    | sed -nE 's/.*(warning: [0-9]+ (shift|reduce)\/reduce conflict[s]?).*/\1/p'; \
    if [ ! -s /tmp/bison_output.txt ]; then echo "No shift/reduce or reduce/reduce conflicts found."; fi
	@for testfile in $(GRAMMAR_TESTS); do \
		echo "Running $$testfile" && bin/morph < $$testfile || exit 1; \
	done
	@echo "All tests passed!"
	



prelexer: obj src/lexer/lexer.cpp src/parser/parser.hpp src/lexer/token.hpp
	$(CXX) $(CXXFLAGS) $(CXXINCLUDE) -E src/lexer/lexer.cpp -o src/lexer/prelexer.cpp  

preparser: obj src/parser/parser.cpp src/parser/parser.hpp src/ast/ast.hpp
	$(CXX) $(CXXFLAGS) $(CXXINCLUDE) -E src/parser/parser.cpp -o src/parser/preparser.cpp