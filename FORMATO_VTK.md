# Formato VTK

O formato VTK é o formado entendido pelo programa ParaView utilizado nesse trabalho. O formato VTK é específico para visualização de estruturas e outros tipos de informações semelhantes, logo usaremos o mesmo em um conversor do formato de saída do programa.

O arquivo VTk é dividido em seções, cada uma com as seguintes informações:
- Coordenadas
- Elementos
- Forças nodais
- Deslocamentos prescritos

As coordenadas são importantes no conversor pois alguns `datasets` utilizam pontos para delimitar seus limites. No caso desse trabalho, utilizaremos o `dataset` do tipo *unstructured_grid*, pois as coordenadas/pontos se assemelham com os nós e os elementes se assemelham às células.

## Estrutura do arquivo

O arquivo VTk possui seções, sendo elas o cabeçalho (exemplicado a seguir) e os dados do `dataset`, no caso do *unstructured_grid*, pontos e células.


O cabeçalho pode ser visto a seguir:
```
# vtk DataFile Version 3.0
Dataset convertido do arquivo t10x10.out                                                                      
ASCII
```

### Dataset + Pontos

O dataset é descrito utilizando a palavra chave `DATASET` seguida pelo nome da mesma. Logo a seguir, deve existir um linha informando ao programa quantas serão os pontos/coordenadas informados e o tipo (no caso float). Cada ponto/coordenada deverá ter seu valor em x, y e z.

Exemplo:
```
DATASET UNSTRUCTURED_GRID
POINTS         121 float
x, y, x
```

Repare que os nomes não apresentam nesse momento um identificador. Por padrão, o Paraview utiliza os identificadores numéricos, sendo a primeira linha com a identificação zero (0), a segunda linha com a identificação 1 e assim por diante.

### Células / Elementos

Os elementos no Paraview são chamados de células. Cada célula deve ser representada por uma linha contendo como colunas: o número de nós/pontos da célula e a identificação de cada um. Essa identificação é a numérica que começa por zero explicada na seção anterior.

Essa seção possui um cabeçalho próprio com as seguintes informações: a palavra `CELLS` seguida do número de células/elementos e do número total de pontos que será lido. Veja um exemplo a seguir:
```
CELLS       200       800
         3         0        11        12
         3         0        12         1
         3         1        12        13
         3         1        13         2
         3         2        13        14
         ...
```

Repare que o número `800` é o número total de pontos lidos pela Paraview. Ou seja, temos 200 elementos/células. cada um descrito através de 4 colunas nas linhas subsequentes. Dessa forma, teremos `4*200=800` pontos no total.

As linhas que descrevem cada elemento possuem as seguintes colunas: número de nós do elemento, nó A, nó b, ... . Ou seja, o Paraview sabe o número de nós que deve ler a cada linha através do valor da primeira.

