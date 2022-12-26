/*+−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
|         UNIFAL−Universidade  Federal  de  Alfenas
|            BACHARELADO EM CIENCIA DA COMPUTACAO
| Trabalho..: Vetor e verificacao de tipos
| Disciplina: Teoria de Linguagens e Compiladores
| Professor.: Luiz Eduardo da Silva
| Aluno.....: Otávio Augusto Faria
| Data......: 15/12/2019
+−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−*/


/* usar tabulacao 2 */

%{
	#include "utils.h"
	int numLinha = 1;
	char atomo[80];
  enum Tipo tip;
	enum Categoria cat = variavel;
    
	
%}

identificador [a-zA-Z]([a-zA-Z0-9])*
numero        [0-9]+
espaco        [ \t]+
novalinha     [\n]

%option noyywrap

%x comentario

%%

programa return T_PROGRAMA;
inicio 	return T_INICIO;
fimprograma return T_FIM;

leia return T_LEIA;
escreva return T_ESCREVA;

se return T_SE;
entao return T_ENTAO;
senao return T_SENAO;
fimse return T_FIMSE;

enquanto return T_ENQTO;
faca return T_FACA;
fimenquanto return T_FIMENQTO;

"+" return T_MAIS;
"-" return T_MENOS;
"*" return T_VEZES;
div return T_DIV;

">" return T_MAIOR;
"<" return T_MENOR;
"=" return T_IGUAL;

e return T_E;
ou return T_OU;
nao return T_NAO;

"<-" return T_ATRIB;
"(" return T_ABRE;
")" return T_FECHA;

"[" {  /* ao indentificar um colchete, a categoria passa a ser vetor,
	  caso contrario é definida como variavel    */

	cat = vetor; 
       	return T_ABRE_V; 
    }
    
"]" return T_FECHA_V;

inteiro {   
					/* ao indentificar um inteiro, 
					a variavel 'tip' passa a ser inteiro   */
	   				tip = inteiro;
            return T_INTEIRO; 
        }

logico { 	/* ao indentificar um inteiro, 
					a variavel 'tip' passa a ser inteiro   */   
					
						tip = logico;
            return T_LOGICO; 
        }
V return T_V;
F return T_F;

{identificador} {   strcpy (atomo, yytext); return T_IDENTIF; }
{numero}     		{   strcpy (atomo, yytext); return  T_NUMERO; }
{espaco} 
{novalinha} numLinha++;


"//".+ /* comentario de linha */

"/*" BEGIN(comentario);
<comentario>"*/" BEGIN(INITIAL);
<comentario>"." /* nao faz nada */
<comentario>"\n" numLinha++;

. msg("ERRO LEXICO");


%%








