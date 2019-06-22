      program gerador
      implicit none
      integer elem_lat,nnos,nelem,elem,nnos_elem,tipo_elem
      integer divisao, no, no_relativo, degrau
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
      print *, 'Número de elementos nas laterais (ex: 16 para 16x16):'
      read *, elem_lat

c     Pede ao usuário o tipo de material que será utilizado
      print *, 'Qual o ID do tipo de elemento utilizado?'
      print *, '1 - Triângulo no estado plano de tensão'
      print *, '2 - Quadrilátero no estado plano de tensão'
      read *, tipo_elem

c     Se o elemento é triangular, são 3 nós, se quadrilátero são 4.
      if (tipo_elem .eq. 1) then
            nnos_elem = 3
c           Cálculo do número de elementos.
            nelem = ((elem_lat)**2 )*2
      end if
      if (tipo_elem .eq. 2) then
            nnos_elem = 4
c           Cálculo do número de elementos.
            nelem = (elem_lat)**2
      end if

c     Se o elemento for triangular, o número de elementos nas laterais deverá ser par
c       exceto se for apenas 1 elemento na lateral (caso de um quadrilátero dividido ao meio).
      divisao = (elem_lat / 2) * 2
      if (
     .      (tipo_elem .eq. 1).and.
     .      (divisao .lt. elem_lat).and.
     .      (elem_lat .ne. 1)) then
            print *, 'Para elementos triangulares, o número de'
            print *, 'elementos deve ser par!'
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
c     1ª e 2ª linha
c     ==================================================================
      print *, nnos, nelem, 1, nnos_elem
      print *, 1, tipo_elem

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
                  y = tamanho_elem * (degrau - 1)
            else
                  y = tamanho_elem * degrau
            end if

            print *, no, x, y, 0.0
100   continue

c     ==================================================================
c     Nós de cada elemento
c     ==================================================================
      do 200 elem = 1, nelem

c           A divisão é periódica com período elem_lat, logo precisa começar de (elem - 1).
            linha = (elem - 1) / elem_lat
            a = linha + (elem - 1) + 1
            b = linha + (elem - 1) + 2
            c = linha + (elem - 1) + elem_lat + 2
            d = linha + (elem - 1) + elem_lat + 3

c           Nós para os elementos quadriláteros.
            if (nnos_elem .eq. 4) then
                  print *, elem, a, b, c, d, 1
            end if

c           Nós para elementos triangulares (repare que é baseado nos pontos do quadrilátero).
            if (nnos_elem .eq. 3) then
c                 Vamos imprimir 2 elementos por vez, logo vamos imprimir somente os impares.
                  if (mod(elem, 2) .eq. 1) then
                        print *, elem  , a, b, c, 0, 1
                        print *, elem+1, b, c, d, 0, 1
                  end if
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
      primeiro_no = nnos-elem_lat
      do 400 no = primeiro_no, nnos
c           Verificamos cada nó para saber se ele possui uma força aplicada.
c             Lembrando que esse gerador de malha gera forças nos nós superiores.
c           O primeiro nó já é o primeiro da última linha (nnos-elem_lat).

c           Sabemos que os nós da lateral direita e esqueda recebem metade da força que os nós centrais.
            
            if ((no .eq. primeiro_no).or.(no .eq. nnos)) then
                  print *, no, 0.0, forca/2
            else
                  print *, no, 0.0, forca
            end if
400   continue
      print *, 0, 0, 0

c     Fecha o arquivo.
      close (unit=unit)

      end