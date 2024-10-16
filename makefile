# Check if the directory /opt/homebrew/opt/flex exists
FLEX_PATH := /opt/homebrew/opt/flex
FLEX_INCLUDE := $(shell [ -d $(FLEX_PATH) ] && echo "-I $(FLEX_PATH)/include")

CXX := g++
CXXFLAGS := --std=c++11 $(FLEX_INCLUDE)

default: bin/byte

test: bin/byte examples/test.f24
	bin/byte < examples/test.f24

bin/byte: obj/parser.o obj/lexer.o obj/byte.o bin
	$(CXX) $(CXXFLAGS) obj/lexer.o obj/parser.o obj/byte.o -o bin/byte

obj/byte.o: src/byte.cpp
	$(CXX) $(CXXFLAGS) -c src/byte.cpp -o obj/byte.o

obj/lexer.o: src/lexer.cpp obj
	$(CXX) $(CXXFLAGS) -c src/lexer.cpp -o obj/lexer.o

obj/parser.o: src/parser.cpp src/parser.hpp obj
	$(CXX) $(CXXFLAGS) -c src/parser.cpp -o obj/parser.o

src/lexer.cpp: src/lexer.l
	flex -o src/lexer.cpp src/lexer.l

src/parser.cpp: src/parser.y
	bison -d src/parser.y -o src/parser.cpp

src/parser.hpp: src/parser.y
	bison -d src/parser.y -o src/parser.cpp




obj:
	mkdir obj

bin:
	mkdir bin

clean:
	rm -f src/parser.cpp src/parser.hpp src/lexer.cpp
	rm -rf obj bin