.DEFAULT_GOAL := bin/byte

test: bin/byte
	bin/byte < mg.f24 > test/output.txt

# byte

bin/byte: obj/byte.o obj/lexer.o bin
	g++ -std=c++11 -o bin/byte obj/byte.o obj/lexer.o

obj/byte.o: src/byte.cpp obj
	g++ -std=c++11 -o obj/byte.o -c src/byte.cpp

# lexer

obj/lexer.o: src/lexer.cpp obj
	g++ -std=c++11 -o obj/lexer.o -c src/lexer.cpp

src/lexer.cpp: src/lexer.l src/token.h src/*.h
	flex -p -o src/lexer.cpp -i src/lexer.l 

# directories

bin:
	mkdir bin

obj:
	mkdir obj

# tidy er up

clean:
	rm -rf bin obj src/lexer.cpp src/args.cpp *.s
	clear && clear