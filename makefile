.DEFAULT_GOAL := bin/byte

test: bin/byte mg.f24
	bin/byte -i mg.f24 -o mg.s
	diff -y mg.s mg.t

bin/byte: obj/byte.o obj/lexer.o obj/args.o
	g++ -std=c++11 -o bin/byte obj/byte.o obj/lexer.o obj/args.o

obj/byte.o: src/byte.cpp
	g++ -std=c++11 -o obj/byte.o -c src/byte.cpp

obj/lexer.o: src/lexer.cpp
	g++ -std=c++11 -o obj/lexer.o -c src/lexer.cpp

src/lexer.cpp: src/lexer.l src/token.h src/keyword.h
	flex -p -o src/lexer.cpp -i src/lexer.l 

obj/args.o: src/args.cpp
	g++ -std=c++11 -o obj/args.o -c src/args.cpp

src/args.cpp: src/args.l
	flex -o src/args.cpp -i src/args.l 

clean:
	rm -f bin/* obj/*.o src/lexer.cpp src/args.cpp *.s
	clear && clear