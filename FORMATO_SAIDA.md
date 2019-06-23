# Formato de saída do programa MEF

O formato de saída do programa MEF é estrutura nas seguintes partes:
- Coordenadas
- Elementos
- Forças nodais
- Deslocamentos prescritos


## Coordenadas

As coordenadas finais dos pontos, são listadas logo depois da entrada `coor N`, onde `N` é o número de linhas com as coordenadas.

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
* Repare que a palavra `coor` sempre virá seguida do número de coordenadas.
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