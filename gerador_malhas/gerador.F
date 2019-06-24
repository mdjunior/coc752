      program gerador
      implicit none
      integer elem_lat,nnos,nelem,elem,nnos_elem,tipo_elem
      integer divisao, no, no_relativo, degrau, nquadrilateros
      character*80 output_file
      real tamanho_elem, x, y
      integer linha, a,b,c,d
      integer primeiro_no
      real forca
      integer unit

c     ==================================================================
      print *, 'Atenção: esse é um programa gerador de malhas'
      print *, '  específico para malhas uniformes com elementos'
      print *, '  quadriláteros e triangulares. As malhas produzidas'
      print *, '  são sempre presas na lateral esquerda com forças'
      print *, '  aplicadas na parte superior.'
      print *, 'Não utilize para fins generalistas.'
c     ==================================================================

c     Pede ao usuário o número de elementos e carrega o valor em nelem
      print *, 'Número de elementos nas laterais (ex: 16 para 16x16).'
      print *, 'Se for usar o elemento triagular, coloque o metade:'
      read *, elem_lat

c     Pede ao usuário o tipo de material que será utilizado
      print *, 'Qual o ID do tipo de elemento utilizado?'
      print *, '1 - Triângulo no estado plano de tensão'
      print *, '3 - Quadrilátero no estado plano de tensão'
      read *, tipo_elem

c     Se o elemento é triangular, são 3 nós, se quadrilátero são 4.
      nquadrilateros = (elem_lat)**2
      if (tipo_elem .eq. 1) then
            nnos_elem = 3
c           Cálculo do número de elementos.
            nelem = nquadrilateros*2
      end if
      if (tipo_elem .eq. 3) then
            nnos_elem = 4
c           Cálculo do número de elementos.
            nelem = nquadrilateros
      end if
      if ((tipo_elem .ne. 1).and.(tipo_elem .ne. 3)) then
            print *, 'Tipo de elemento não suportado pelo gerador!'
            stop 1
      end if

c     Cálculo do número de nós
      nnos = (elem_lat + 1)**2

c     Pede ao usuário o nome do arquivo para salvar a malha
      print *, 'Qual nome do arquivo para salvar? (ex: q8x8.dat)'
      read *, output_file

c     Utilizar a unit=6 faz com que todos os prints a seguir vão direto para o arquivo.
      unit = 6
      open(unit=unit,file=output_file,action="write",status="replace")

c     ==================================================================
c     1ª, 2ª e 3ª linha
c     ==================================================================
      print *, nnos, nelem, 1, nnos_elem, 2, 2
      print *, 1, tipo_elem
      print *, 1.0, 0.3

c     ==================================================================
c     Coordenadas de cada nó
c     ==================================================================
      do 100 no = 1,nnos
c           Dividimos o comprimento total (1) pelo número de elementos na lateral.
            tamanho_elem = 1.0/elem_lat

c           Chamamos de no_relativo pois ele incrementa até o no elem_lat.
c           Ou seja, para 2 elementos (3 nós por linha), no_relativo será
c             sempre 1, 2, 0 (repare que o nó 3 é zero por causa do mod).
            no_relativo = mod(no, elem_lat+1)
            if (no_relativo .eq. 0) then
                  x = tamanho_elem * elem_lat
            else
                  x = tamanho_elem * (no_relativo - 1)
            end if
            
c           Como degrau é inteiro, ele tem o valor da divisao (o resto está
c             armazenado em no_relativo.
c           Repare que no último nó de cada linha, a divisão muda de valor.
c             Sabemos disso pois o mod (no_relativo) fica igual a zero.
            degrau = no / (elem_lat + 1)
            if (no_relativo .eq. 0) then
c                 A logica de tamanho_elem * degrau é aumentar conforme os elementos
c                   aumentam. Como queremos que o primeiro elemento esteja no alto,
c                   fazemos (1 - valor).
                  y = 1.0 - (tamanho_elem * (degrau - 1.0))
            else
                  y = 1.0 - (tamanho_elem * degrau)
            end if

            print *, no, x, y, 0.0
100   continue

c     ==================================================================
c     Nós de cada elemento (usamos os quadriláteros)
c     ==================================================================
      do 200 elem = 1, nquadrilateros

c           A divisão é periódica com período elem_lat, logo precisa começar de (elem - 1).
            linha = (elem - 1) / elem_lat
            a = linha + (elem - 1) + 1
            b = linha + (elem - 1) + 2
            c = linha + (elem - 1) + elem_lat + 2
            d = linha + (elem - 1) + elem_lat + 3

c           Nós para os elementos quadriláteros.
            if (nnos_elem .eq. 4) then
                  print *, elem, a, c, d, b, 1
            end if

c           Nós para elementos triangulares (repare que é baseado nos pontos do quadrilátero).
c             A ordem dos nós em cada elemento é muito importante. Ela precisa estar no sentido
c             anti-horário. Caso não esteja, o determinante do elemento vai ficar nulo.
            if (nnos_elem .eq. 3) then
                  print *, 2*elem -1 , a, c, d, 1
                  print *, 2*elem    , a, d, b, 1
            end if
200   continue

c     ==================================================================
c     Condições de contorno
c     ==================================================================
      do 300 no = 1,nnos
c           Verificamos cada nó para saber se ele possui uma condição de contorno.
c             Lembrando que esse gerador de malha gera condições de contorno nos
c             nós da lateral esquerda, deixando-os presos nas duas direções.
            if ( mod((no-1), (elem_lat+1)) .eq. 0 ) then
c           Nesse IF usamos o (no-1) para recontar os nós como se eles começassem de 0,
c             pois assim podemos utilizar o MOD sem problemas.
                  print *, no, 1, 1
            end if
300   continue
      print *, 0, 0, 0

c     ==================================================================
c     Forças
c     ==================================================================
c     A força será dividida igualmente entre os elementos.
      forca = -1.0/elem_lat
      do 400 no = 1, elem_lat+1

c           Verificamos cada nó para saber se ele possui uma força aplicada.
c             Lembrando que esse gerador de malha gera forças nos nós superiores.
c           O primeiro nó já é o primeiro da última linha (nnos-elem_lat).

c           Sabemos que os nós da lateral direita recebem metade da força que os nós centrais.
c             Não imprimimos o primeiro nó pois ele está preso.
            if (no .eq. 1) then
c                 nada... Esse nó está preso
            else if (no .eq. (elem_lat+1)) then
                  print *, no, 0.0, forca/2
            else
                  print *, no, 0.0, forca
            end if
400   continue
      print *, 0, 0, 0

c     Fecha o arquivo.
      close (unit=unit)

      end