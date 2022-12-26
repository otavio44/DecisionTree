lexico: 	utils.c lexico.l sintatico.y;\
	  	flex -o lexico.c lexico.l;\
		bison -o sintatico.c sintatico.y -v -d;\
		gcc -o simples utils.c sintatico.c lexico.c -lm

limpa:
		rm -f lexico.c sintatico.c sintatico.output *~ sintatico.h sintatico\
