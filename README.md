# Compilador Linguagem Simples

## Sobre
Este projeto foi desenvolvido na disciplina de Teoria de Linguagens e Compiladores no curso de Ciência da Computaçã na Universidade Federal de Alfenas. O projeto consistia no uso das ferramentas Flex e GNU Bison com objetivo de adicionar funcionalidades a linguagem simples.

## Requisitos

- Flex: 2.6.4
- GNU Bison: 3.5.1
- GCC: 9.4.0

Em versões mais atuais do `gcc` (GNU Compiler Collection) tive problemas de compatibilidade com a biblioteca `libc6`, por isso recomendo utilizar a versão descrita acima para este projeto.

## Sintaxe da linguagem simples

Todo programa em simples começa com a palavra reservada `programa` seguido do nome do programa. Exemplo:
```
programa palindromo
```

Em seguida temos as declarações de variáveis que tem o tipo seguido do nome da variável. Atualmente o projeto suporta tipos inteiros e lógicos, tanto para variáveis normais como vetores. Exemplo:

```
programa variaveis
	inteiro [5]vetor
	inteiro i j 
```

Os comandos que compõe o programa ficam dentro das palavras reservadas `inicio` e `fimprograma`. Exemplo:

```
programa variaveis
	inteiro [5]vetor
	inteiro i j 
inicio
    <comandos>
fimprograma
```

Os comandos suportados atualmente são:

- Atribuição de valores em variáveis (normais e vetores):
```
i <- 5
vetor[0] <- 10
```

O indice do vetor pode ser um inteiro ou uma expressão:
```
i <- 5
vetor[0] <- 10
vetor[i + 10] <- 10
```

- Leitura de valores do usuário:
```
leia i
leia vetor[0]
```
- Escrita de valores:
```
escreva i
escreva vetor[0]
```
- Estruturas de repetição:
```
i <- 0
 enquanto i < 4 faca
	vetor[1] <- 10
	escreva i
 	i <- i + 1
 fimenquanto
```

- Estruturas condicionais:
```
i <- 10
se i > 5 entao
    escreva i
	senao escreva 5 
```

- Exemplo de um programa completo:

```
programa exemplo
 	inteiro [4]vetor
 	inteiro i j
inicio
 	i <- 0
 	enquanto i < 4 faca
 	    se i < 2
 	        vetor[1] <-  534
		    escreva i
 		    senao escreva 534
 		i <- i + 1
 	fimenquanto
fimprograma
```

## Como executar os programas
Na raiz do projeto execute o comando abaixo para compilar os arquivos e gerar o binário `simples`:

```sh
make lexico
```
Caso queira limpar os arquivos gerados:
```sh
make limpa
```

Após isso, basta executar o binário `simples` passando um programa simples como entrada:

```sh
./simples < programa.simples > prog.vms
```

Nesse exemplo, direcionei a saída da execução para o arquivo `prog.vms`, esse arquivo contem as instruções da linguagem para que o interpretador execute o programa.

Para utilizar o interpretador:

```sh
gcc interpretador.c -o interpretador
./interpretador < prog.vms
```

## Créditos

Agradecimentos ao Professor Luís Eduardo por todo conhecimento compartilhado e pelas partes do projeto construídas em sala com a turma.
## Licença

MIT

**Free Software, Hell Yeah!**


