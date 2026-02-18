all : analyzer flexer compile

run : mycompiler
	./mycompiler < correct2.ka > correct2.c

analyzer : myanalyzer.y
	bison -d -v -r all myanalyzer.y
flexer : mylexer.l
	flex mylexer.l
compile : lex.yy.c myanalyzer.tab.c
	gcc -o mycompiler lex.yy.c myanalyzer.tab.c cgen.c -lfl
