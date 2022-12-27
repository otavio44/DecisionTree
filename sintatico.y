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

extern int numLinha;
extern char atomo[80];
extern enum Tipo tip;
extern enum Categoria cat;
int contaVar = 0;
int rotulo = 0;

%}

//simbolo de partida
%start programa

//simbolos terminais

%token T_ABRE_V;
%token T_FECHA_V;
%token T_PROGRAMA
%token T_INICIO
%token T_FIM
%token T_IDENTIF
%token T_LEIA
%token T_ESCREVA
%token T_ENQTO
%token T_FACA
%token T_FIMENQTO
%token T_SE
%token T_ENTAO
%token T_SENAO
%token T_FIMSE
%token T_ATRIB
%token T_VEZES
%token T_DIV
%token T_MAIS
%token T_MENOS
%token T_MAIOR
%token T_MENOR
%token T_IGUAL
%token T_E
%token T_OU
%token T_V
%token T_F
%token T_NUMERO
%token T_NAO
%token T_ABRE
%token T_FECHA
%token T_LOGICO
%token T_INTEIRO


// precedencia
%left T_E T_OU
%left T_IGUAL
%left T_MAIOR T_MENOR
%left T_MAIS T_MENOS
%left T_VEZES T_DIV

%%

//gramatica

programa : cabecalho { 
              printf("\tINPP\n"); 
           }
	variaveis T_INICIO lista_comandos T_FIM { 

			printf("\tDMEM\t%d\n", contaVar);
			printf("\tFIMP\n"); 
  }
	;

cabecalho
	: T_PROGRAMA T_IDENTIF              
	;

variaveis
	: // vazio 
	| declaracao_variaveis { 

        printf("\tAMEM\t%d\n", contaVar); 
    }
	;

declaracao_variaveis
	: tipo lista_variaveis declaracao_variaveis
	| tipo lista_variaveis
	;

tipo 
	: T_LOGICO
	| T_INTEIRO 
  ;


lista_variaveis
	: lista_variaveis
	  T_IDENTIF
			{  insere(atomo, tip, cat, contaVar, 1);  contaVar++; }

	| T_IDENTIF
			{	insere(atomo, tip, cat,  contaVar, 1);  contaVar++; }

    /* atraves do terminal T_NUMERO, seu valor é convertido de char para int, para gerar o AMEM */

   | lista_variaveis T_ABRE_V T_NUMERO   {  
      
      int n = strtol(atomo, NULL, 10);
      if(n <= 0) msg("O tamanho do array deve ser maior que 0.");
      empilha(n);   

  }
    T_FECHA_V T_IDENTIF {  

          int tamanho = desempilha();
          insere(atomo, tip, cat, contaVar, tamanho);
			    contaVar += tamanho;
			    cat = variavel;
    }

    | T_ABRE_V T_NUMERO   {
  
          int n = strtol(atomo, NULL, 10);
          if(n <= 0) msg("O tamanho do array deve ser maior que 0.");
          empilha(n);  
  
    }
    T_FECHA_V T_IDENTIF {  

			    int tamanho = desempilha();
          insere(atomo, tip, cat, contaVar, tamanho);
			    contaVar += tamanho;
			    cat = variavel;
    }
	;

lista_comandos 
	: //vazio
	| comando lista_comandos
	;

comando 
	: entrada_saida
	| repeticao
	| selecao
	| atribuicao
	;

entrada_saida
	: leitura
	| escrita
	;

leitura 
     : T_LEIA variavel {

        enum Tipo tipo = desempilha();
     
     		enum Tipo categoria = desempilha();    
     		
     		if(categoria == variavel) {
     		
     			  printf ("\tLEIA\n\tARZG\t%d\n", desempilha());

     		} else if(categoria == vetor) {
     		
     			  printf ("\tLEIA\n\tARZV\t%d\n", desempilha());

     		}
     
     }      
        
	;


escrita
	
	: T_ESCREVA expressao  { 
	  
      /* desempilhando o tipo gerado pela expressao, para nao causar problemas na pilha */
			desempilha();
      printf ("\tESCR\n"); 

    } 
	;
	
	

repeticao 
	: T_ENQTO { 
	
			printf("L%d\tNADA\n",++rotulo); 
			empilha(rotulo);
			 
		}
		expressao { 

			enum Tipo tipo = desempilha();      
      if(tipo != logico) msg("A condição de repeticao deve ser um valor logico.\n   Encontrado: inteiro");
      
    }
	T_FACA { 
	
		printf("\tDSVF\tL%d\n", ++rotulo); 
		empilha(rotulo); 
	}	
	lista_comandos 
	T_FIMENQTO {

			int rot1 = desempilha();
			int rot2 =  desempilha();
			printf("\tDSVS\tL%d\nL%d\tNADA\n", rot2, rot1);
			
	} 
	;
	
	
	
selecao
	: T_SE expressao { 
	
      /* desempilha-se o tipo gerado pela expressao, se diferente de logico um erro e gerado */
			enum Tipo tipo = desempilha();
      if(tipo != logico) msg("A condição de selecao deve ser um valor logico.\n   Encontrado: inteiro");

      printf("\tDSVF\tL%d\n", ++rotulo); empilha(rotulo); 
  }
	T_ENTAO lista_comandos 
	T_SENAO {
	  
			printf("\tDSVS\tL%d\nL%d\tNADA\n", ++rotulo, desempilha()); empilha(rotulo); 	
			
	}	
	lista_comandos T_FIMSE { 
	
			printf("L%d\tNADA\n",desempilha()); 
	}
	;
	

atribuicao : variavel T_ATRIB expressao {
    
    /* desempilha-se o tipo gerado pela variavel e gerado pela expressao, 
       sao comparados, se diferentes a atribuicao e invalida e um erro é gerado */

		enum Tipo tipo1 = desempilha();
    enum Tipo tipo2 = desempilha();

    if(tipo1 != tipo2) msg("Atribuicao invalida!");


    /* desempilha-se a categoria da variavel, com objetivo de gerar 
       a instrução  e armazenamento correta     */
        
    enum Categoria categoria = desempilha();


    /* apos a comparacao, desempilha-se o endereço da variavel em questao */

		if(categoria == vetor) 
			  printf("\tARZV\t%d\n", desempilha());     

		else if(categoria == variavel) 
				printf("\tARZG\t%d\n", desempilha());
     
		
	}
    ;

indice 
	://vazio
	| T_ABRE_V expressao {  

        /* desempilha-se o tipo da expressao, se diferente de inteiro, nao eh possivel acessar o vetor
           e entao um erro eh gerado        */

        enum Tipo tipo = desempilha();
        
        if(tipo != inteiro) msg("O acesso a uma posicao do array deve ser inteiro.\n   Encontrado: logico");

    }
     T_FECHA_V
	;
	
	
	
	

variavel : T_IDENTIF { 

      /* através do identificador da variavel, consulta-se na tabela se o mesmo existe */
  
			lNode * aux = consulta(atomo);
			if(aux == NULL) msg("Variavel nao declarada.");
    

      /* se a variavel existe, entao seu endereco, categoria e tipo sao empilhados
         para posteriormente gerar instrucoes de carregamento, armazenamento e gerar
         verificacao de tipo    */

			empilha(aux->end); 
      empilha(aux->categoria);
      empilha(aux->tipo);
               
		} 
		indice 
	;





expressao
	: expressao T_VEZES expressao 	{ 
  
      /* para cada expressao matematica ou logica é chamado a funcao de verificacao de tipo,
         para ela é passado: o tipo invalido, o tipo esperado, o tipo resultante da expressao. */
	
			
			verificaTipo(logico, inteiro, inteiro);
			printf ("\tMULT\n"); 

	}
	| expressao T_DIV expressao	    { 
	
	
			verificaTipo(logico, inteiro, inteiro);
			printf ("\tDIVI\n"); 
			
	}
	| expressao  T_MAIS expressao	{ 
			
			verificaTipo(logico, inteiro, inteiro);	
			printf ("\tSOMA\n"); 
			
	}
	| expressao T_MENOS expressao	{ 
	
			
			verificaTipo(logico, inteiro,  inteiro);
			printf ("\tSUBT\n"); 
	}
	| expressao T_MAIOR expressao	{ 
	
			verificaTipo(logico, inteiro, logico);
			printf ("\tCMMA\n"); 
			
	}
	| expressao T_MENOR expressao	{ 
	
			verificaTipo(logico, inteiro, logico);
			printf ("\tCMME\n"); 
			
	}
	| expressao T_IGUAL expressao	{ 
    
      /* neste caso em especifico, a igualdade pode ser realizada para ambos os tipos, logo
         somente o empilhamento do tipo resultante da expressao eh realizado.  */
			
			empilha(logico);
			printf ("\tCMIG\n"); 
			
	}
	| expressao T_E expressao	    { 
			
			verificaTipo(inteiro, logico, logico);
			printf ("\tCONJ\n"); 
			
	}
	| expressao T_OU expressao	    { 
	
			verificaTipo(inteiro, logico, logico);
			printf ("\tDISJ\n"); 
			
	}
	| termo
	
	;

termo 
	: variavel {

        /* desempilha-se as informacoes da variavel */

        enum Tipo tipo = desempilha();

        enum Categoria categoria = desempilha();

    /* verificacao atraves da categoria para gerar a instrucao correta de carregamento */  
    
		if(categoria == vetor){ 
		
				printf("\tCRVV\t%d\n", desempilha());

        /* apos gerar a instrucao, o tipo da variavel e verificado e novamente empilhado,
           isso eh necessario devido a ordem de empilhamento ao identificar uma variavel, durante
           a verificacao de tipo eh levado em consideracao que o tipo da expressao/variavel esteja
           sempre no topo da pilha  */

        if(tipo == inteiro) empilha(inteiro);
		    else empilha(logico);
			  
			
		} else if (categoria == variavel) {
			
				printf ("\tCRVG\t%d\n", desempilha());

        if(tipo == inteiro) empilha(inteiro);
		    else empilha(logico);
		}
		
	}
	| T_NUMERO 	{ 
      
        /* empilhando o tipo dos terminais */
	
				empilha(inteiro);
				printf("\tCRCT\t%s\n", atomo);  
				  
	} 					
	| T_V	{ 
	
				empilha(logico);
				printf("\tCRCT\t1\n");   		  
	}
	| T_F	{ 
	
				empilha(logico);
				printf("\tCRCT\t0\n");   		 
	}
	| T_NAO termo { 
	
        
        /* verificacao de tipo sobre a negacao logica, se encontrado um inteiro o erro e gerado */
				enum Tipo tipo = desempilha();
				
				if(tipo != logico) msg("A negacao so eh aplicavel a tipos logicos.\n    Encotrado: inteiro");

				empilha(logico);
				
				printf("\tNEGA\n");   		
	}
	| T_ABRE expressao T_FECHA
	
	;
%%

int main(void){

	yyparse();
  //mostra();	
	limpaED();
	
}
