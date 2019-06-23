# Formato de entrada do programa MEF

[[_TOC_]]

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

# Formato de saída do programa MEF

O formato de saída do programa MEF é estrutura nas seguintes partes:
- Coordenadas
- Elementos
- Forças nodais
- Deslocamentos prescritos


## Coordenadas

As coordenadas finais dos pontos, são listadas logo depois da entrada `coord N`, onde `N` é o número de linhas com as coordenadas.

Exemplo:
```
coor   121
         1    0.00000E+00    0.10000E+01    0.00000E+00
         2    0.10000E+00    0.10000E+01    0.00000E+00
         3    0.20000E+00    0.10000E+01    0.00000E+00
         ...
       121    0.30000E+00    0.10000E+01    0.00000E+00
```

Observações:
* Repare que a palavra `coord` sempre virá seguida do número de coordenadas.
* Cada linha de coordenada possui um inteiro que numera a linha e 3 reais que são os valores nas coordenadas x, y e z.

## Elementos

Os nós que compõem cada elemento são listados a seguir, depois da palavra `elem X`, onde `X` é o número de elementos esperados.

```
elem        200
         1         3         1        12        13
         2         3         1        13         2
         3         3         2        13        14
         4         3         2        14         3
         5         3         3        14        15
         6         3         3        15         4
         ...
       200         3       109       121       110
```

Observações:
* Repare que a primeira coluna possui a identificação do elemento
* A segunda coluna possui o número de nós que o elemento possui.

## Forças nodas

As forças nodais em cada nó são listadas a seguir. A palavra chave `nosc F`, onde `F` é o número de graus de liberdade indica o número de colunas esperadas.

Exemplo:
```
nosc  2
         1   0.00000E+000   0.00000E+000
         2   0.38588E+000  -0.54723E+000
         3   0.62195E+000  -0.93002E+000
         ...
       121  -0.89066E+000  -0.27493E+001
```

## Deslocamentos prescritos

Os deslocamentos prescritos são listados a seguir. Repare que sempre são fornecidas as coordenadas x, y e z. Repare também que os valores são os mesmos das forças nodais.

Exemplo:
```
nvec 
         1   0.00000E+000   0.00000E+000   0.00000E+000
         2   0.38588E+000  -0.54723E+000   0.00000E+000
         3   0.62195E+000  -0.93002E+000   0.00000E+000
         ...
         121  -0.89066E+000  -0.27493E+001   0.00000E+000
```