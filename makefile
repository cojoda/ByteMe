# Check if the directory /opt/homebrew/opt/flex exists
FLEX_PATH := /opt/homebrew/opt/flex
FLEX_INCLUDE := $(shell [ -d $(FLEX_PATH) ] && echo "-I $(FLEX_PATH)/include")

CXX := g++
CXXFLAGS := --std=c++11 $(FLEX_INCLUDE)

PARSE :=src/parser
LEX :=src/lexer

default: bin/byte

test: bin/byte examples/mg.f24
	bin/byte < examples/mg.f24

bin/byte: obj/parser.o obj/lexer.o obj/byte.o bin
	$(CXX) $(CXXFLAGS) obj/lexer.o obj/parser.o obj/byte.o -o bin/byte

obj/byte.o: src/byte.cpp
	$(CXX) $(CXXFLAGS) -c src/byte.cpp -o obj/byte.o

obj/lexer.o: $(LEX)/lexer.cpp $(LEX)/keyword.hpp $(LEX)/operation.hpp $(LEX)/punctuation.hpp $(LEX)/token.hpp obj
	$(CXX) $(CXXFLAGS) -c $(LEX)/lexer.cpp -o obj/lexer.o

obj/parser.o: $(PARSE)/parser.cpp $(PARSE)/parser.hpp obj
	$(CXX) $(CXXFLAGS) -c $(PARSE)/parser.cpp -o obj/parser.o

$(LEX)/lexer.cpp: $(LEX)/lexer.l makefile
	flex -o $(LEX)/lexer.cpp $(LEX)/lexer.l

$(PARSE)/parser.cpp: $(PARSE)/parser.y makefile
	bison -d -v $(PARSE)/parser.y -o $(PARSE)/parser.cpp

$(PARSE)/parser.hpp: $(PARSE)/parser.y makefile
	bison -d -v $(PARSE)/parser.y -o $(PARSE)/parser.cpp




obj:
	mkdir obj

bin:
	mkdir bin

clean:
	rm -f $(PARSE)/parser.cpp $(PARSE).hpp $(LEX)/lexer.cpp
	rm -rf obj bin