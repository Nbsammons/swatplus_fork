      subroutine res_read_weir
      
      use input_file_module
      use maximum_data_module
      use reservoir_data_module

!!    ~ ~ ~ PURPOSE ~ ~ ~
!!    this subroutine reads data from the lake water quality input file (.lwq).
!!    This file contains data related to initial pesticide and nutrient levels
!!    in the lake/reservoir and transformation processes occurring within the 
!!    lake/reservoir. Data in the lake water quality input file is assumed to
!!    apply to all reservoirs in the watershed.  

      implicit none

      character (len=80) :: titldum = ""  !             |title of file
      character (len=80) :: header = "" !             |header of file
      integer :: eof = 0                !             |end of file
      integer :: imax = 0               !             |determine max number for array (imax) and total number in file
      logical :: i_exist                !none         |check to determine if file exists
      integer :: ires = 0               !none         |counter

      eof = 0
      imax = 0

      inquire (file=in_res%weir_res,exist=i_exist)
      if (.not. i_exist .or. in_res%weir_res == "null") then
        allocate (res_weir(0:0))
      else
      do
        open (105,file=in_res%weir_res)
        read (105,*,iostat=eof) titldum
        if (eof < 0) exit
        read (105,*,iostat=eof) header
        if (eof < 0) exit
          do while (eof == 0)
            read (105,*,iostat=eof) titldum
            if (eof < 0) exit
            imax = imax + 1
          end do   
          
        db_mx%res_weir = imax
        
        allocate (res_weir(0:imax))
        rewind (105)
        read (105,*,iostat=eof) titldum
        if (eof < 0) exit
        read (105,*,iostat=eof) header
        if (eof < 0) exit
          
        do ires = 1, imax
          read (105,*,iostat=eof) titldum
          if (eof < 0) exit
          backspace (105)
          read (105,*,iostat=eof) res_weir(ires)
          if (eof < 0) exit
        end do
        exit
      end do
      end if
      close(105)

      return
      end subroutine res_read_weir