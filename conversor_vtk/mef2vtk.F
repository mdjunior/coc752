      program mef2vtk
      implicit none
      integer input_unit, output_unit, number, nos_elemento
      character*80 input_file, output_file, buffer, section
      integer coor, no, no_in
      integer elem, cell, cell_in, elem_points
      integer fn_dimensoes
c     Coordenadas são para cada nó, em x, y e z (3 dimensões)
      real   coordenadas(500000,3)
c     Os elementos e seus nós
      integer   elements(500000,5)
c     As forças nodais são para cada nó (50000) em x e y (2 dimensões)
      real forcas_nodais(500000,2)
c     Os deslocamentos são para cada nó, em x, y e z (3 dimensões)
      real deslocamentos(500000,3)

c     ==================================================================
      print *, 'Atenção: esse é um programa conversor de resultados'
      print *, '  específico para malhas resultantes do programa MEF.'
      print *, 'Não utilize para fins generalistas.'
c     ==================================================================

c     Pede ao usuário o nome do arquivo para salvar a malha
      print *, 'Qual nome do arquivo para leitura? (ex: q8x8.out)'
      read *, input_file
      input_unit = 99
      open(unit=input_unit,file=input_file,action="read")

      print *, 'Quantos nós tem cada elemento? (ex: 3)'
      read *, nos_elemento

c     Processando as coordenadas
c     ==================================================================
      read(input_unit,*) section, number
      if (section .eq. 'coor') then
            coor = number
      else
            print *, 'Coordenadas não encontradas!'
            stop 1
      end if
      do 100 no = 1, coor
            read(input_unit,*) no_in, coordenadas(no,1), 
     .            coordenadas(no,2), coordenadas(no,3)
100   continue

c     Processando os elementos
c     ==================================================================
      read(input_unit,*) section, number
      if (section .eq. 'elem') then
            elem = number
      else
            print *, 'Elementos não encontrados!'
            stop 2
      end if
c     elem_points acumula o número total de pontos
      elem_points = 0
      do 200 cell = 1, elem
            if (nos_elemento .eq. 3) then
                  read(input_unit,*) cell_in, elements(cell,1), 
     .                  elements(cell,2), elements(cell,3), 
     .                  elements(cell,4)
            else if (nos_elemento .eq. 4) then
                  read(input_unit,*) cell_in, elements(cell,1), 
     .                  elements(cell,2), elements(cell,3), 
     .                  elements(cell,4), elements(cell,5)
            else
                  print *,'Número de nós por elemento não suportado!'
                  stop 3
            end if
            elem_points = elem_points + elements(cell,1)
200   continue
      elem_points = elem_points + elem

c     Processando as forças nodais
c     ==================================================================
      read(input_unit,*) section, number
      if (section .eq. 'nosc') then
            fn_dimensoes = number
      else
            print *, 'Forças nodais não encontradas!'
            stop 4
      end if
      do 500 no = 1, coor
            read(input_unit,*) no_in, forcas_nodais(no,1), 
     .            forcas_nodais(no,2)
500   continue

c     Processando os deslocamentos
c     ==================================================================
      read(input_unit,*) section
      if (section .ne. 'nvec') then
            print *, 'Deslocamentos não encontradas!'
            stop 5
      end if
      do 600 no = 1, coor
            read(input_unit,*) no_in, deslocamentos(no,1), 
     .            deslocamentos(no,2), deslocamentos(no,3)
600   continue


c     ==================================================================
c     Gerando arquivo no final
c     ==================================================================

c     Pede ao usuário o nome do arquivo para salvar a malha
      print *, 'Qual nome do arquivo para salvar? (ex: q8x8.vtk)'
      read *, output_file
      output_unit = 100
      open(unit=output_unit, file=output_file, action="write",
     .     status="replace")

c     Imprime cabeçalho do arquivo de saída
      write (output_unit,'(a)') '# vtk DataFile Version 3.0'
      write (output_unit,'(a,a)') 'Dataset convertido do arquivo ',
     .                              input_file
      write (output_unit,'(a)') 'ASCII'
      write (output_unit,'(a)') ''

c     Pontos/coordenadas
c     Escreve cabeçalho para os pontos/coordenadas
      write (output_unit,'(a)') 'DATASET UNSTRUCTURED_GRID'
      write (output_unit,'(a,i10,X,a)') 'POINTS', coor,'float'
      do 1000 no = 1, coor
c           A linha a seguir, gera as coordenadas iniciais (da malha)
            write (output_unit,'(3e15.5,3e15.5,3e15.5)')
     .            coordenadas(no,1), coordenadas(no,2), 
     .            coordenadas(no,3)
1000  continue
      write (output_unit,'(a)') ''

c     Células/elementos
      write (output_unit,'(a,i10,i10)') 'CELLS', elem, elem_points
      do 1300 cell = 1, elem
            if (nos_elemento .eq. 3) then
                  write (output_unit,'(i10,i10,i10,i10)') 
     .                  elements(cell,1),   elements(cell,2)-1,
     .                  elements(cell,3)-1, elements(cell,4)-1
            else if (nos_elemento .eq. 4) then
                  write (output_unit,'(i10,i10,i10,i10,i10)') 
     .                  elements(cell,1),   elements(cell,2)-1,
     .                  elements(cell,3)-1, elements(cell,4)-1,
     .                  elements(cell,5)-1
            else
                  print *,'Número de nós por elemento não suportado!'
                  stop 3
            end if

1300  continue
      write (output_unit,'(a)') ''

c     Gerando tipos de células para arquivo de saida (os elementos começam de zero)
      write (output_unit,'(a,i10)') 'CELL_TYPES', elem
      do 1400 cell = 1, elem
            if (elements(cell,1) .eq. 3) then
                  write (output_unit,'(i10)') 5
            else if (elements(cell,1) .eq. 4) then
                  write (output_unit,'(i10)') 9
            else
                  print *,'Número de nós por elemento não suportado!'
                  stop 3
            end if
1400   continue
      write (output_unit,'(a)') ''

c     Gerando vetores de deslocamento para arquivo de saida
      write (output_unit,'(a,i10)') 'POINT_DATA ', coor
      write (output_unit,'(a)') 'VECTORS deslocamento double'
      do 1500 no = 1, coor
            write (output_unit,'(6e15.5e3)')
     .            deslocamentos(no,1),
     .            deslocamentos(no,2),
     .            deslocamentos(no,3)
1500  continue

      end