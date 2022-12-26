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

#include "utils.h"

extern int numLinha;

Node * topo2 = NULL;

void msg(char *s) {

    printf("\n%d: %s\n\n", numLinha, s);
    limpaED();
    exit(10);
}

int yyerror(char *s) {
    msg("ERRO SINTATICO");
}

/* * empilhamento de uma pilha encadeada 
   * valor: inteiro a ser empilhado
*/
void empilha(int valor) {

    if (topo2 == NULL) {
        topo2 = malloc(sizeof (Node));
        topo2->valor = valor;
        topo2->prox = NULL;
     

    } else {
        
        Node * x = malloc(sizeof (Node));
        x->valor = valor;
        x->prox = topo2;
        topo2 = x;

    }
}



int desempilha() {
    if (topo2 != NULL) {

        int n = topo2->valor;

        Node * r = topo2;

        topo2 = r->prox;

        free(r);

        return n;
    }

    msg("pilha vazia");
}


/* funcao hash calculada a partir do identificador da variavel */
int hash(char * id) {

    unsigned int hs = id[0];
    int i = 0;

    for (i = 1; id[i] != '\0'; i++)
        hs = (hs * 5 + id[i]);

    return hs % TAM;
}

/* insercao na tabela de dispersao */

void insere(char *id, enum Tipo t, enum Categoria c, int end, int tamanho) {

    lNode * aux = consulta(id);

    if (aux == NULL) {

        int pos = hash(id);

        lNode * primeiro = tab[pos];
        lNode * novo = malloc(sizeof (lNode));

        novo->end = end;
        novo->tamanho = tamanho;
        strncpy(novo->id, id, 80);
        novo->tipo = t;
        novo->categoria = c;

        if (primeiro == NULL) {
            tab[pos] = novo;

        } else {

            while (primeiro->prox != NULL) {

                primeiro = primeiro->prox;
            }

            primeiro->prox = novo;
        }

    } else
        msg("Indentificador duplicado");

}

/* consulta na tabela de dispersao, atraves do identificador */

lNode * consulta(char * id) {

    int pos = hash(id);
    lNode * primeiro = tab[pos];


    if (primeiro == NULL) {
        return NULL;
    } else {

        while (primeiro != NULL) {

            if (!strcmp(id, primeiro->id))
                return primeiro;

            primeiro = primeiro->prox;
        }

    }
    return NULL;
}

/* funcao de printar a tabela de simbolos */
void mostra() {


    lNode * aux;
    int j = 0;

    char * it = "INT";
    char * lg = "LOG";
    char * vt = "VET";
    char * vr = "VAR";


    printf("id         end         tipo         cat      tamanho\n");
    for (int i = 0; i < TAM; i++) {
        aux = tab[i];

        while (aux != NULL) {
            printf(" %-10s %-10d ", aux->id, aux->end);
            if (aux->tipo == inteiro) printf(" %-10s ", it);
            else printf(" %-10s ", lg);

            if (aux->categoria == variavel) printf(" %-10s ", vr);
            else printf(" %-10s ", vt);
            printf(" %-10d\n", aux->tamanho);
            aux = aux->prox;
        }
    }


}



void verificaTipo(enum Tipo tipoInvalido, enum Tipo tipoEsperado, enum Tipo resultadoExpressao) {
    
    enum Tipo tipo1 = desempilha();
    enum Tipo tipo2 = desempilha();

    if (tipo1 == tipoInvalido || tipo2 == tipoInvalido) {  

        if(tipoEsperado == inteiro && tipoInvalido == logico)
            msg("erro de tipagem\n Esperado: inteiro\n Encontrado: logico");
        
        else if(tipoEsperado == logico && tipoInvalido == inteiro) 
            msg("erro de tipagem\n Esperado: logico\n Encontrado: inteiro");
    
    }
    empilha(resultadoExpressao);

}


/* funcao para limpar as estruturas no final da execucao ou ao gerar um erro */

void limpaED() {


    lNode * aux;

    for (int i = 0; i < TAM; i++) {
        aux = tab[i];

        while (aux != NULL) {
            free(aux);
            aux = aux->prox;
        }
    }

    Node * tp;
    tp = topo2;

    while (tp != NULL) {
        free(tp);
        tp = tp->prox;
    }

}



