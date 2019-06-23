# Formato de entrada do programa MEF

O arquivo recebido pelo programa MEF, tem um formato de dados específico. Repare que nos exemplos foi utilizado o separador ` | ` para maior clareza, mas no arquivo de dados devem ser utilizados apenas espaços.

O arquivo de entrada é dividido nas seguintes seções:

## Informações gerais

Nessa seção, existem informações gerais sobre a malha. Número de nós e elementos, materiais e suas relações são descritas nessa seção. Essa seção possui, para o escopo desse trabalho, apenas 2 linhas.

1ª Linha:
```
número de nós | número de elementos | número de materiais | número máximo de nós por elemento | graus de liberdade por nó | dimensão do problema
```

2ª Linha:
```
ID do material | ID do tipo do elemento
```

3ª Linha:
```
Elasticidade do material | Coeficiente de Poisson do material | Espessira | ...
```

Onde cada coluna representa uma constante física do material. As colunas significam, respectivamente:
- Módulo da elasticidade/Módulo de Young
- Coeficiente de Poisson
- Espessura
- Densidade
- Condutividade térmica
- ...

Observações:
* (1ª linha) Repare que o número de materiais é fixo nesse problema, assim como o número de graus de liberdade por nó (2) e a dimensão do problema (2). 
* (2ª linha) Repare que se mais de um material é utilizado, existiriam outras linhas semelhando a 2ª linha (mas não é caso desse trabalho).
* (2ª linha)  O ID do tipo do material é o identificador que foi utilizado para esse material no próprio arquivo de dados (normalmente utilizamos 1 pois nesse trabalho estamos lidando com apenas um tipo de material).
* (2ª linha)  O ID do tipo de elemento é o identificador interno usado no programa. Nos exemplos, o valor `1` é o triângulo do estado plano de tensão. Existe uma biblioteca com os tipos de elementos e as suas respectivas rotinas. Nesse trabalho específico, é necessário implementar o elemento quadrilátero (que teria o ID `3`).
* (3ª linha) No problema, o coeficiente de Poisson é fixo em 0,30 (aço). O módulo da elasticidade é 1.0 (está na faixa dos polímeros), o que é bastante elástico.

## Informações dos nós

As linhas a seguir devem ter as informações dos nós. Além do número do nó, a linha deve ter suas coordenadas em x, y e z.

Exemplo:
```
número do nó | x | y | z
```

Observação:
* Os valores das posições de x, y e z são números reais.
* Repare que como nesse trabalho estamos lidando apenas com 2 dimensões, mantemos a coordenada Z com valor de `0.0`.

## Informações dos elementos.

As linhas dessa seção, possuem a representação de quais nós fazem parte de cada elemento. Além disso, cada elemento possui o material do qual o mesmo é composto.

Exemplo:
```
número do elemento | nó 1 | nó 2 | nó 3 | nó 4 | material
```

Observação:
* Caso o elemento só possua 3 nós (triângulo), o nó 4 não deve ser impresso.
* Repare que para o escopo do trabalho, todos os elementos são do mesmo material.

## Condições de contorno

As linhas dessa seção indicam as condições de contorno para cada nó. Nessa seção especificamente, somente os nós com condições de contorno podem ser especificados. Finalmente, essa seção possui um marcador de fim, caracterizado com uma linha com todos os valores iguais a zero.

Exemplo:
```
nó | x | y
0  | 0.0 | 0.0 <------- Marcador de fim
```

Observação:
* O valor de x ou y deverá ser `0` ou `1`. O valor `1` indica que o nó está preso na direção correspondente e `0` indica que o nó está livre naquela direção.

## Forças

As linhas dessa seção indicam as forças aplicadas nos nós em cada direção. Assim como na seção de condições de contorno, nesta somente os nós com forças podem ser especificados. Essa seção possui um marcador de fim, caracterizado com uma linha com todos os valores iguais a zero.

Exemplo:
```
nó | forçca em x | força em y
0  | 0.0 | 0.0
```

Observação:
* Os valores das forças são números reais e não inteiros.
