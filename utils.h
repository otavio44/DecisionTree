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

#ifndef __UTILS__s
#define __UTILS__

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <stdarg.h>

#include "sintatico.h"

/* tamanho do vetor de ponteiros da tabela hash, um número primo é utilizado para reduzir a quantidade de colisoes */

#define TAM 997


enum Tipo {
    logico, inteiro
};

enum Categoria {
    variavel, vetor
};



/* estrutura da pilha semantica */

typedef struct tNo Node;

struct tNo {
    int valor;
    Node * prox;

};


/* estrutura para alocar informacoes da tabela de simbolos, trata-se de uma lista encadeada */
typedef struct lista lNode;

struct lista {
    char id[80];
    int end;
    enum Categoria tipo;
    enum Categoria categoria;
    int tamanho;

    lNode * prox;
    
};





//vetor de ponteiro para lista encadeada
lNode * tab[TAM];


void msg(char *);
int yyerror(char *);
int yylex();

/* funções para realizar operações na pilha */

void empilha(int);
int desempilha();



/* funções para realizar operações na tabela de simbolos */

lNode * consulta(char *);
void insere(char *, enum Tipo tipo, enum Categoria categoria, int, int);
void mostra(void);

/* procedimento que valida uma expressao e empilha o seu tipo 
   * t1: tipo invalido
   * t2: tipo esperado
   * t3: tipo resultante  
*/
void verificaTipo(enum Tipo t1, enum Tipo t2, enum Tipo t3);

/* procedimento que limpa as estruturas ao finalizar o programa*/
void limpaED(void);

#endif




