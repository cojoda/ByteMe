.DEFAULT_GOAL := bin/byte

test: clean bin/byte mg.f24
	bin/byte < mg.f24 > mg.s

bin/byte: obj/byte.o obj/lexer.o bin
	g++ -std=c++11 -o bin/byte obj/byte.o obj/lexer.o

obj/byte.o: src/byte.cpp obj
	g++ -std=c++11 -o obj/byte.o -c src/byte.cpp

obj/lexer.o: src/lexer.cpp obj
	g++ -std=c++11 -o obj/lexer.o -c src/lexer.cpp

src/lexer.cpp: src/lexer.l src/token.h src/keyword.h
	flex -p -o src/lexer.cpp -i src/lexer.l 

# obj/args.o: src/args.cpp obj
# 	g++ -std=c++11 -o obj/args.o -c src/args.cpp

# src/args.cpp: src/args.l
# 	flex -o src/args.cpp -i src/args.l 

bin:
	mkdir bin

obj:
	mkdir obj

clean:
	rm -rf bin obj src/lexer.cpp src/args.cpp *.s
	clear && clear