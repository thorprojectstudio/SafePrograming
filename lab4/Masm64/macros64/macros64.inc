; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤
;                    Pre-processor macros for ML64.EXE
;                 Copyright (c) The MASM32 SDK 1998 - 2017
; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

    flcreate MACRO filename
      invoke CreateFile,reparg(filename),GENERIC_READ or GENERIC_WRITE, \
                        0,0,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,0
      EXITM <rax>
    ENDM

    fldelete MACRO filename
      invoke DeleteFileA,reparg(filename)
      EXITM <rax>
    ENDM

    flflush MACRO hfile
      invoke FlushFileBuffers,hfile
    ENDM

    flopen MACRO filename
      invoke CreateFile,reparg(filename),GENERIC_READ or GENERIC_WRITE, \
                        0,0,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0
      EXITM <rax>       ;; return file handle
    ENDM

    flclose MACRO arg:REQ
      invoke CloseHandle,arg
    ENDM

    flread MACRO hFile,buffer,bcnt
      LOCAL var
      .data?
        var dq ?
      .code
      invoke ReadFile,hFile,buffer,bcnt,ADDR var,0
      mov rax, var
      EXITM <rax>       ;; return bytes read
    ENDM

    flwrite MACRO hFile,buffer,bcnt
      LOCAL var
      .data?
        var dq ?
      .code
      invoke WriteFile,hFile,buffer,bcnt,ADDR var,0
      mov rax, var
      EXITM <rax>       ;; return bytes written
    ENDM

  ; ------------------------------------------------------------------------
  ; multiple entry support with quoted text, text address, lf, tab and quote
  ; ------------------------------------------------------------------------
    flprint MACRO hFile:REQ,text:VARARG  ;; zero terminated text
      LOCAL wrtn
      .data?
        wrtn dq ?
      .code
      FOR var,<text>
        IFIDN <var>,<lf>
          invoke WriteFile,hFile,chr$(13,10),2,ADDR wrtn,NULL
        ELSEIFIDN <var>,<tab>
          invoke WriteFile,hFile,chr$(9),1,ADDR wrtn,NULL
        ELSEIFIDN <var>,<qt>
          invoke WriteFile,hFile,chr$(34),1,ADDR wrtn,NULL
        ELSE
          invoke WriteFile,hFile,reparg(var),len(var),ADDR wrtn,NULL
        ENDIF
      ENDM
    ENDM

    flseek MACRO hFile,distance,location
      IFIDN <location>,<BEGIN>
        var equ <FILE_BEGIN>
      ELSEIFIDN <location>,<CURRENT>
        var equ <FILE_CURRENT>
      ELSEIFIDN <location>,<END>
        var equ <FILE_END>
      ELSE
        var equ <location>
      ENDIF
      invoke SetFilePointer,hFile,distance,0,var
      EXITM <rax>               ;; return current file offset
    ENDM

    flseteof MACRO hFile
      invoke SetEndOfFile,hFile
    ENDM

    flsize MACRO hFile
      invoke GetFileSize,hFile,0
      EXITM <rax>
    ENDM


    uval MACRO pstr
      invoke vc__atoi64,pstr
      EXITM <rax>
    ENDM



  ; ----------------
  ; character macros
  ; ----------------
    str$ MACRO value
      LOCAL buffer,pbuf
      .data?
        buffer db 32 dup (?)
      .data
        pbuf dq buffer
      .code
      invoke vc__i64toa,value,pbuf,10
      EXITM <pbuf>
    ENDM

    hex$ MACRO value
      LOCAL buffer,pbuf
      .data?
        buffer db 32 dup (?)
      .data
        pbuf dq buffer
      .code
      invoke vc__i64toa,value,pbuf,16
      invoke szUpper,pbuf
      EXITM <pbuf>
    ENDM

    chr$ MACRO dbdata:VARARG
      LOCAL tname,ptxt
      .data
        tname db dbdata,0
        ptxt dq tname
      .code
      EXITM <ptxt>
    ENDM

    lcase$ MACRO ptxt
      invoke szLower,ptxt
      EXITM <rax>
    ENDM

    ucase$ MACRO ptxt
      invoke szUpper,ptxt
      EXITM <rax>
    ENDM

    mono$ MACRO pTxt
      invoke szMono,pTxt
      EXITM <rax>
    ENDM

    remove$ MACRO psrc,pdst,prem
      invoke szRemove,psrc,pdst,prem
      EXITM <rax>
    ENDM

    rep$ MACRO psrc,pdst,ptarget,preplace
      invoke szRep,psrc,pdst,ptarget,preplace
      mov rax, pdst
      EXITM <rax>
    ENDM

  ; --------------------------------------------
  ; both return an offset from the start address
  ; --------------------------------------------
    search$ MACRO src,subst,offst
      mov rax, offst
      add rax, src
      invoke StrStr,rax,subst
      sub rax, src
      EXITM <rax>
    ENDM

    searchi$ MACRO src,subst,offst
      mov rax, offst
      add rax, src
      invoke StrStrI,rax,subst
      sub rax, src
      EXITM <rax>
    ENDM

  ; -------------------------------------------------
  ; The trim macros ALL overwrite the original string
  ; removing tabs and spaces from both string ends
  ; -------------------------------------------------

    ltrim$ MACRO src
      invoke szLtrim,src,src
      EXITM <rax>
    ENDM

    rtrim$ MACRO src
      invoke szRtrim,src,src
      EXITM <rax>
    ENDM

    trim$ MACRO src
      invoke szTrim,src
      EXITM <rax>
    ENDM

  ; -------------------------------------------------

  ; --------------
  ; console output
  ; --------------
    stdout MACRO arg:REQ,extras:VARARG
      LOCAL dat,pdat
      invoke StdOut,arg
      IFNB <extras>
      .data
        dat db extras,0
        pdat dq dat
      .code
      invoke StdOut,pdat
      ENDIF
    ENDM

    errout MACRO arg:REQ,extras:VARARG
      LOCAL dat,pdat
      invoke ErrOut,reparg(arg)
      IFNB <extras>
      .data
        dat db extras,0
        pdat dq dat
      .code
      invoke ErrOut,pdat
      ENDIF
    ENDM

  ; --------------------------------------------------
  ; conout supports a variable number of entries
  ; including quoted text, lf tab and quote characters
  ; --------------------------------------------------
    conout MACRO args:VARARG
      FOR var,<args>
        IFIDN <var>,<lf>        ;; line feed
          stdout chr$(13,10)
        ELSEIFIDN <var>,<tab>   ;; tab
          stdout chr$(9)
        ELSEIFIDN <var>,<qt>    ;; double quote "
          stdout chr$(34)
        ELSE
          stdout reparg(var)    ;; quoted text or normal text address
        ENDIF
      ENDM
    ENDM

    ccout MACRO quoted:REQ
      fn StdOut,cfm$(quoted)
    ENDM

  ; -------------
  ; memory macros
  ; -------------
    alloc MACRO bsize
      invoke GlobalAlloc,GMEM_FIXED or GMEM_ZEROINIT,bsize
      EXITM <rax>
    ENDM

    realloc MACRO pmem, newsize
      invoke re_alloc,pmem,newsize
      EXITM <rax>
    ENDM

    msize MACRO hndl
      invoke GlobalSize,hndl
      EXITM <rax>
    ENDM

    mfree MACRO hndl
      invoke GlobalFree,hndl
    ENDM

  ; *******************
  ; HeapAlloc functions
  ; *******************
  ; --------------------------------------------------------------
  ; NOTE : To use the following HeapAlloc() macros you must first
  ;        run the "heapinit" macro to get the process heap handle
  ;        and store it as a GLOBAL so that the following macros
  ;        have the process heap pointer available.
  ; --------------------------------------------------------------
    heapinit MACRO
      IFNDEF pHeap
        .data?
          align 8
          pHeap dq ?
        .code
      ENDIF
        mov pHeap, rv(GetProcessHeap)
    ENDM

    halloc MACRO bcnt:REQ
      invoke HeapAlloc,pHeap,HEAP_ZERO_MEMORY,bcnt
      EXITM <rax>
    ENDM

    hsize MACRO mhandle:REQ
      invoke HeapSize,pHeap,0,mhandle
      EXITM <rax>
    ENDM

    hrealloc MACRO mhandle:REQ,bcnt:REQ
      invoke HeapReAlloc,pHeap,HEAP_ZERO_MEMORY,mhandle,bcnt
      EXITM <rax>
    ENDM

    hfree MACRO mhandle:REQ
      invoke HeapFree,pHeap,0,mhandle
      EXITM <rax>
    ENDM

  ; --------------------------------------------------------
  ; alignment must be an immediate operand and a power of 2
  ; when no longer required the original address must be
  ; freed with either GlobalFree() or the macro "mfree".
  ; --------------------------------------------------------
    aalloc MACRO pmem:REQ,bcnt:REQ,alignment:REQ
      mov rdx, bcnt
      add rdx, alignment
      mov rcx, GMEM_FIXED or GMEM_ZEROINIT
      call GlobalAlloc
      mov pmem, rax
      add rax, alignment - 1
      and rax, -alignment
      EXITM <rax>
    ENDM

  ; ------------------------------------------------------------
  ; the long version will take a register, memory operand or
  ; an immediate for the "alignment" parameter which must
  ; be a power of 2. When the memory is no longer required,
  ; it should be released with GlobalFree() or the macro "mfree"
  ; ------------------------------------------------------------
    aligned_alloc MACRO pmem:REQ,bcnt:REQ,alignment:REQ
    LOCAL adata
    .data?
      align 16
      adata dq ?
    .code
      mov rax, alignment        ;; transfer alignment to memory
      mov adata, rax            ;; store alignment in memory
      mov rdx, bcnt             ;; load RDX with the byte count
      add rdx, adata            ;; add alignment to RDX
      mov rcx, GMEM_FIXED or GMEM_ZEROINIT
      call GlobalAlloc          ;; allocate request + alignment
      mov pmem, rax             ;; store the address in RAX
      mov rcx, adata            ;; load alignment into RCX
      sub rcx, 1                ;; sub 1 from it
      add rax, rcx              ;; add alignment - 1 to allocated memory address
      mov rcx, adata            ;; reload alignment into RCX
      neg rcx                   ;; invert sign
      and rax, rcx              ;; AND -alignment to allocated memory address
      EXITM <rax>               ;; return aligned OFFSET in RAX
    ENDM

  ; -------------

    memalign MACRO reg, number
      add reg, number - 1
      and reg, -number
    ENDM

    aligndn MACRO reg, number
      add reg, number - 1
      and reg, -number
      sub reg, number
    ENDM

    alignup MACRO reg, number
      add reg, number - 1
      and reg, -number
    ENDM

  ; -------------

    mrm MACRO target,source
      mov rax, reparg(source)
      mov target, rax
    ENDM

    mrmq MACRO target,source
      mov rax, source
      mov target, rax
    ENDM

    mrmd MACRO target,source
      mov eax, source
      mov target, eax
    ENDM

    mrmw MACRO target,source
      mov ax, source
      mov target, ax
    ENDM

    mrmb MACRO target,source
      mov al, source
      mov target, al
    ENDM

    ladd MACRO target, source
      lea rax, source
      mov target, rax
    ENDM

  ; ---------------------------------
  ; uninitialised data section macros
  ; ---------------------------------
    LOCAL64 MACRO arg1
      LOCAL var, pvar
      .data?
        align 16
        var QWORD ?
      .data
        pvar QWORD var
      .code
      arg1 = pvar
    ENDM

    STRUCT64 MACRO sname,stype
      LOCAL lname
      .data?
        align 16
        lname stype <?>
      .code
      sname = lname
    ENDM

    ptr$ MACRO mem
      lea rax, mem
      EXITM <rax>
    ENDM

    waitkey MACRO text
      LOCAL over
      IFIDN <text>,<>
        stdout "Press any key to continue...",13,10
        goto over
      ENDIF
      stdout text,13,10
    :over
      call wait_key
    ENDM

    len MACRO pstr
      invoke szLen,pstr
      EXITM <rax>
    ENDM

    loadfile MACRO pfile
      invoke load_file,reparg(pfile)
      EXITM <rax>                       ;; file length returned in rcx
    ENDM

    savefile MACRO fname,mem,len
      invoke save_file,reparg(fname),mem,len
      EXITM <rax>
    ENDM

    cmdtail MACRO
      call cmd_tail
      EXITM <rax>
    ENDM

  ; ********************************************************
  ; format a C style string complete with escape characters
  ; and return the offset of the result to the calling macro
  ; ********************************************************
  ;   branchless ASCII version of cfm$ with no ELSE clauses.
  ; ********************************************************

    cfm$ MACRO txt:VARARG

      LOCAL ch1,char,nu$,tmp,flag,lbuf,rbuf,cpos,sln
      ch1 equ <>
      nu$ equ <>
      flag = 0

      ch1 SUBSTR <txt>,1,1              ;; check if 1st character is a quote
      IFDIF ch1,<">
        EXITM <txt>                     ;; exit with original "txt" if it is not
      ENDIF

      FORC char,<txt>                   ;; scan through characters in "txt"

        IFIDN <char>,<\>                ;; increment the flag if "\" escape character
          flag = flag + 1
        ENDIF

      ; -----------------------------------------------

        IF flag EQ 0                    ;; <<< if flag = 0 then normal APPEND character
          nu$ CATSTR nu$,<char>
        ENDIF

        IF flag EQ 1                    ;; <<< if flag = 1 then perform replacement
          IFIDN <char>,<n>
            nu$ CATSTR nu$,<",13,10,">  ;; \n = CRLF
            flag = 0
          ENDIF
          IFIDN <char>,<t>
            nu$ CATSTR nu$,<",9,">      ;; \t = TAB
            flag = 0
          ENDIF
          IFIDN <char>,<q>
            nu$ CATSTR nu$,<",34,">     ;; \q = quote
            flag = 0
          ENDIF
          IFIDN <char>,<0>
            nu$ CATSTR nu$,<",0,">      ;; \0 = embedded zero
            flag = 0
          ENDIF

       ;; ---------------------
       ;; masm specific escapes
       ;; ---------------------
          IFIDN <char>,<l>
            nu$ CATSTR nu$,<",60,">     ;; \l = <
            flag = 0
          ENDIF
          IFIDN <char>,<r>
            nu$ CATSTR nu$,<",62,">     ;; \r = >
            flag = 0
          ENDIF
          IFIDN <char>,<x>
            nu$ CATSTR nu$,<",33,">     ;; \x = !
            flag = 0
          ENDIF
          IFIDN <char>,<a>
            nu$ CATSTR nu$,<",40,">     ;; \a = (
            flag = 0
          ENDIF
          IFIDN <char>,<b>
            nu$ CATSTR nu$,<",41,">     ;; \b = )
            flag = 0
          ENDIF
        ENDIF

        IF flag EQ 2                    ;; <<< if flag = 2 APPEND the "\" character
          IFIDN <char>,<\>
            nu$ CATSTR nu$,<",92,">     ;; \\ = \
            flag = 0
          ENDIF
        ENDIF

      ; -----------------------------------------------

      ENDM

    ;; ---------------------------------------------
    ;; strip any embedded <"",> characters sequences
    ;; ---------------------------------------------
        nu$ CATSTR nu$,<,0,0,0>                 ;; append trailing zeros

        cpos INSTR nu$,<"",>                    ;; test for leading junk
        IF cpos EQ 1
          nu$ SUBSTR nu$,4                      ;; chomp off any leading junk
        ENDIF

        cpos INSTR nu$,<"",>

        WHILE cpos
          lbuf SUBSTR nu$,1,cpos-1              ;; read text before junk
          rbuf SUBSTR nu$,cpos+3                ;; read text after junk
          nu$ equ <>                            ;; clear nu$
          nu$ CATSTR lbuf,rbuf                  ;; concantenate the two
          cpos INSTR nu$,<"",>                  ;; reload cpos for next iteration
        ENDM

        sln SIZESTR nu$
        nu$ SUBSTR nu$,1,sln-6                  ;; trim off tail padding

        .data
          tmp db nu$,0
          ptmp dq tmp
          align 8
        .code
        EXITM <ptmp>                            ;; return pointer to data

    ENDM

  ; ******************************************
  ; DOS style directory manipulation macros  *
  ; The parameters passed to these directory *
  ; macros should be zero terminated string  *
  ; addresses.                               *
  ; ******************************************
    chdir MACRO pathname
      invoke SetCurrentDirectory,reparg(pathname)
    ENDM
    CHDIR equ <chdir>

    mkdir MACRO dirname
      invoke CreateDirectory,reparg(dirname),NULL
    ENDM
    MKDIR equ <mkdir>

    rndir MACRO oldname,newname
      invoke MoveFile,reparg(oldname),reparg(newname)
    ENDM
    RNDIR equ <rndir>

    rmdir MACRO dirname
      invoke RemoveDirectory,reparg(dirname)
    ENDM
    RMDIR equ <rmdir>

  ; -------------------------
  ; determine an operand type
  ; -------------------------
    op_type MACRO arg:REQ
      LOCAL result
      result = opattr(arg)
        IF result eq 37         ;; label, either local or global
          EXITM %1
        ELSEIF result eq 42     ;; GLOBAL var
          EXITM %2
        ELSEIF result eq 98     ;; LOCAL  var
          EXITM %3
        ELSEIF result eq 36     ;; immediate operand or constant
          EXITM %4
        ELSEIF result eq 48     ;; register
          EXITM %5
        ELSEIF result eq 805    ;; local procedure in code
          EXITM %6
        ELSEIF result eq 933    ;; external procedure or API call
          EXITM %7
        ENDIF
      EXITM %0                  ;; anything else
    ENDM

  ;; ------------------------------
  ;; support for quoted string data
  ;; ------------------------------
    reparg MACRO arg
      LOCAL nustr,pnu
      LOCAL quot
        quot SUBSTR <arg>,1,1
      IFIDN quot,<">                ;; if 1st char = "
        .data
          align 16
          nustr db arg,0            ;; write arg to .DATA section
          pnu dq nustr              ;; get pointer to it
        .code
        EXITM <pnu>                 ;; return the pointer
      ELSE
        EXITM <arg>                 ;; else return arg unmodified
      ENDIF
    ENDM

  ;; -------------------------------------
  ;; variation returns address in register
  ;; so it can be assigned to a variable.
  ;; -------------------------------------
    repargv MACRO arg
      LOCAL nustr
        quot SUBSTR <arg>,1,1
      IFIDN quot,<">                ;; if 1st char = "
        .data
          align 16
          nustr db arg,0            ;; write arg to .DATA section
        .code
        mov rax, OFFSET nustr
        EXITM <rax>                 ;; return data section offset in rax
      ELSE
        mov rax, arg
        EXITM <rax>                 ;; else return arg
      ENDIF
    ENDM

  ;; -------------------------------------------------------
  ;; This is a parameter checking macro. It is used to test
  ;; if a parameter in a macro is a quoted string when a
  ;; quoted string should not be used as a parameter. If it
  ;; is a user defined error message is displayed at
  ;; assembly time so that the error can be fixed.
  ;; -------------------------------------------------------
    tstarg MACRO arg
      quot SUBSTR <arg>,1,1
      IFIDN quot,<">            ;; if 1st char = "
        % echo *****************
        % echo QUOTED TEXT ERROR
        % echo *****************
        % echo argument = arg
        % echo valid memory buffer address required
        % echo *****************
        .ERR
        EXITM <arg>
      ELSE
        EXITM <arg>             ;; else return arg
      ENDIF
    ENDM

  ;; ******************************************************
  ;; num2str feeds a numeric macro value through a seperate
  ;; macro to force a text return value. It is useful for
  ;; displaying loop based debugging info and for display
  ;; purposes with error reporting.
  ;; NOTE: prefix the "echo" to display this result with "%"
  ;;
  ;; EXAMPLE: % echo num2str(arg)
  ;;
  ;; ******************************************************
    num2str MACRO arg
      EXITM % arg
    ENDM

    argcount MACRO args:VARARG
      LOCAL cnt
      cnt = 0
      FOR item, <args>
        cnt = cnt + 1
      ENDM
      EXITM %cnt                ;; return as a number
    ENDM

    argrev MACRO args:VARARG
      LOCAL acnt,buff
      buff equ <>
      acnt = argcount(args)
      WHILE acnt GT 0
        buff CATSTR buff,<,>,getarg(acnt,args)
        acnt = acnt - 1
      ENDM
      buff SUBSTR buff, 2       ;; trim off the leading ","
      EXITM <buff>
    ENDM

  ; ---------------------------------------------------
  ; return an arguments specified in "num" from a macro
  ; argument list or "-1" if the number is out of range
  ; ---------------------------------------------------
    getarg MACRO num:REQ,args:VARARG
      LOCAL cnt, txt
      cnt = 0
      FOR arg, <args>
        cnt = cnt + 1
        IF cnt EQ num
          txt TEXTEQU <arg>     ;; set "txt" to content of arg num
          EXITM
        ENDIF
      ENDM
      IFNDEF txt
        txt TEXTEQU <-1>        ;; return -1 if num out of range
      ENDIF
      EXITM txt
    ENDM

  ; ----------------------------------------------------------------------
  ; A macro that encapsulates GetLastError() and FormatMessage() to return
  ; the system based error string for debugging API functions that return
  ; error information with the GetLastError() API call.
  ; ----------------------------------------------------------------------
    LastError$ MACRO
      LOCAL lerr,regr15
        .data?
          lerr db 1024 dup (?)
          regr15 dq ?
        .code
      mov regr15, r15
      invoke GetLastError
      mov r15,rax
      invoke FormatMessage,FORMAT_MESSAGE_FROM_SYSTEM, \
                           NULL,r15,0,ADDR lerr,1024,NULL
      mov r15, regr15
      lea rax, lerr
      EXITM <rax>
    ENDM

    errorcon MACRO
      conout "Last error = ",LastError$(),lf
    ENDM

    errorui MACRO
      fn MessageBox,0,LastError$(),"Last Error",MB_OK
    ENDM

  ; -----------------------------------
  ; create a font and return its handle
  ; -----------------------------------
    GetFontHandle MACRO fnam:REQ,fsiz:REQ,fwgt:REQ
      invoke font_handle,reparg(fnam),fsiz,fwgt
      EXITM <rax>
    ENDM

    ; **********************************
    ; control flow macro by Greg Falen *
    ; **********************************
    ; ----------------------
    ; Switch/Case emulation
    ; ----------------------
    $casflg equ <>
    $casvar equ <>
    $casstk equ <>

  ; ====================================================
  ; ====================================================

    .switch MACRO arg
    ;; ---------------------------------
    ;; checks the size and type of "arg"
    ;; ---------------------------------
      IF getattr(arg) eq LAB or getattr(arg) eq IMM
        % echo **************************************
        % echo Only a memory operand or a register is
        % echo allowed as the source in .switch macro
        % echo **************************************
        .err <parameter error>
        goto byebye
      ELSEIF getattr(arg) eq LOC or getattr(arg) eq GLO
        goto isvar
      ELSEIF getattr(arg) eq REG
        goto isreg
      ENDIF

    :isvar
      IF varsize(arg) eq 8
        .switch_macro arg,rax
      ELSEIF varsize(arg) eq 4
        .switch_macro arg,eax
      ELSEIF varsize(arg) eq 2
        .switch_macro arg,ax
      ELSE
        % echo Unknown arg
        .err
      ENDIF
      goto byebye

    :isreg
      IF regsize(arg) eq 8
        .switch_macro arg,rax
      ELSEIF regsize(arg) eq 4
        .switch_macro arg,eax
      ELSEIF regsize(arg) eq 2
        .switch_macro arg,ax
      ELSE
        % echo Unknown arg
        .err
      ENDIF

    :byebye
    ENDM

  ; ====================================================

    .switch_macro MACRO _var:req, _reg:=<rax>
        mov _reg, _var
        $casstk CATSTR <_reg>, <#>, $casflg, <#>, $casstk
        $casvar equ _reg
        $casflg equ <0>                                 ;; 0 = emit an .if, 1 an .elseif
    ENDM

  ; ====================================================

    .case MACRO _args:vararg                            ;; like Pascal: case id1. id4 .. id8, lparam, ...
                                                        ;; does an or (case1 || case2 || case3...)
      $cas textequ <>
      FOR $v, <_args>                                   ;; for each case
        t@ INSTR <$v>, <..>                             ;; range ?
        IF t@                                           ;; yes
          $LB SUBSTR <$v>, 1, t@-1                      ;; lbound = left portion
          $LB CATSTR <(>, $casvar, <!>=>, $LB, <)>      ;; ($casvar >= lbound)
          $UB SUBSTR <$v>, t@+2                         ;; ubound = right portion
          $UB CATSTR <(>, $casvar, <!<=>, $UB, <)>      ;; ($casvar <= ubound)
          $t CATSTR <(>, $LB, <&&> , $UB,<)>            ;; (($casvar >= $lb) && ($casvar <= $ub))
        ELSE                                            ;; no, it's a value (var/const)
          $t CATSTR <(>, $casvar, <==>, <$v>, <)>       ;; ($casvar == value)
        ENDIF
        $cas CATSTR <|| >, $t, $cas                     ;; or this case w/ others
      ENDM
      $cas SUBSTR $cas, 3                               ;; lose the extra "|| " in front
        IFIDN $casflg, <0>                              ;; 0 = 1'st case
          % .if $cas                                    ;; emit ".if"
        ELSE                                            ;; all others
          % .elseif $cas                                ;; emit ".elseif"
        ENDIF
        $casflg equ <1>                                 ;; NOT 1'st
    ENDM

  ; ====================================================

    .default MACRO _default:vararg
        .else
        _default
    ENDM

  ; ====================================================

    .endsw MACRO _cmd:vararg
        IFIDN $casstk, <>
            .err <endsw w/o switch>
        ELSE
            t@ INSTR $casstk, <#>
            $casvar SUBSTR $casstk, 1, t@-1
            $casstk SUBSTR $casstk, t@+1
            t@ INSTR $casstk, <#>
            $casflg SUBSTR $casstk, 1, t@-1
            IFIDN $casstk, <#>
                $casstk equ <>
            ELSE
                $casstk SUBSTR $casstk, t@+1
            ENDIF
            .endif
        endif
    ENDM

  ; ====================================================
  ; ====================================================

    cat$ MACRO mem:REQ, args:VARARG
      LOCAL cloc,locat
        .data?
          locat dq ?
        .data
          cloc dq locat
        .code
        mov cloc, 0
        FOR arg,<args>
          IFIDN <arg>,<lf>
            mov cloc, function(szappend,mem,chr$(13,10),cloc)
          ELSEIFIDN <arg>,<tab>
            mov cloc, function(szappend,mem,chr$(9),cloc)
          ELSEIFIDN <arg>,<qt>
            mov cloc, function(szappend,mem,chr$(34),cloc)
          ELSE
            mov cloc, function(szappend,mem,reparg(arg),cloc)
          ENDIF
        ENDM
        mov rax, cloc
        EXITM <rax>
    ENDM

    CurDir$ MACRO
      IFNDEF cdir__equate__flag
      .data?
          cdir__260_CHAR__buffer db MAX_PATH dup (?)
      .code
      cdir__equate__flag equ <1>
      ENDIF
      invoke GetCurrentDirectory,MAX_PATH,ADDR cdir__260_CHAR__buffer
      lea rax, cdir__260_CHAR__buffer
      EXITM <rax>
    ENDM

    DropFileName MACRO wordparam
      IFNDEF df@@name
        .data?
          dfname db MAX_PATH dup (?)
        .code
      df@@name equ 1
      ENDIF
      invoke DragQueryFile,wordparam,0,ADDR dfname,SIZEOF dfname
      lea rax, dfname
      EXITM <rax>
    ENDM

  ; *************************************************************************
  ; *************************************************************************
  ;
  ; The following stackframe MACRO has been future proofed by the addition of
  ; a stack alignment equate so that the stack can be aligned by any interval
  ; of 16 bytes. The default stack alignment for Win 64 is 16 bytes but to be
  ; able to use YMM sized data locals the stack must be aligned by 32 bytes.
  ;
  ; Future data sizes for AVX2 and later will be larger again and this can be
  ; routinely catered for by making a calling MACRO that simply specifies the
  ; required alignment.
  ;
  ; *************************************************************************
  ; *************************************************************************

    stackframe_dbgdata equ <0>      ; set to non zero for debug info
    stackframe_default equ <64>     ; set default stack
    stackframe_dynamic equ <128>    ; set byte count for ENTER mnemonic
    stackframe_align   equ <16>     ; align the stack by an interval of 16. 16 is default

    UseStackFrame MACRO procname, flag, argbytes, localbytes, reglist, userparms:VARARG
      LOCAL num, var, alt, argb, algn

      argb = argbytes
      argb = (argb / 8) - 1

    ;; -------------------------------------------------------
    ;; this debug display is only useful with 64 bit arguments.
    ;; -------------------------------------------------------
      IF stackframe_dbgdata NE 0
        % echo .  ****************************
        % echo .  PROLOGUE procname
        % echo .  arg count   = num2str(argb)
        % echo .  local bytes = num2str(localbytes)
        % echo .  ****************************
      ENDIF
    ;; -------------------------------------------------------

      num = stackframe_default  ;; default stack, must be an interval of 16
      enter stackframe_dynamic, 0

      IF localbytes EQ 0        ;; if no local bytes, bypass stack alignment
        goto over               ;; branch to label
      ENDIF

      var = localbytes          ;; copy local bytes to var

      algn = stackframe_align
    ;; ------------------------------------
    ;; align "var" to next user defined
    ;; algn specified byte boundary
    ;; ------------------------------------
      var = var + algn - 1      ;; add algn - 1
      var = var AND -algn       ;; and -algn to align to algn bytecount
    ;; ------------------------------------
      var = var + num           ;; add some padding to it
      sub rsp, var              ;; sub from stack pointer at algn byte alignment

      IF argb GT 0              ;; write up to the first 4 registers to their stack locations
        mov [rbp+16], rcx
      ENDIF
      IF argb GT 1
        mov [rbp+24], rdx
      ENDIF
      IF argb GT 2
        mov [rbp+32], r8
      ENDIF
      IF argb GT 3
        mov [rbp+40], r9
      ENDIF

      EXITM <var>

    :over
      sub rsp, num              ;; sub from stack pointer at 16 byte alignment

      IF argb GT 0              ;; write up to the first 4 registers to their stack locations
        mov [rbp+16], rcx
      ENDIF
      IF argb GT 1
        mov [rbp+24], rdx
      ENDIF
      IF argb GT 2
        mov [rbp+32], r8
      ENDIF
      IF argb GT 3
        mov [rbp+40], r9
      ENDIF

      EXITM <num>
    ENDM

  ; *************************************************************************
  ; *************************************************************************

    EndStackFrame MACRO procname, flag, argbytes, localbytes, reglist, userparms:VARARG
      leave                             ;; exit stack frame
      ret                               ;; return to caller
    ENDM

  ; -----------------------------------------------------------

comment # *****************************************************************
          *****************************************************************

    Stack alignment determines what sized LOCAL variables you can specify
    when writing a procedure that uses a stack frame. You match the stack
    frame size in bytes to the size of the largest data type your procedure
    will use and to maintain stack alignment, LOCAL variables must be
    ordered from the largest variables first and placed in descending order
    so that all variable larger than BYTE are correctly aligned.

    EXAMPLE

    LOCAL ymw1  :YMMWORD        ; 256 bit
    LOCAL ymw2  :YMMWORD
    LOCAL ymw3  :YMMWORD

    LOCAL var1  :XMMWORD        ; 128 bit
    LOCAL var2  :XMMWORD
    LOCAL var3  :XMMWORD

    LOCAL qwrd1 :QWORD          ; 64 bit
    LOCAL qwrd2 :QWORD
    LOCAL qwrd3 :QWORD

    LOCAL dwrd1 :DWORD          ; 32 bit
    LOCAL dwrd2 :DWORD
    LOCAL dwrd3 :DWORD

    LOCAL wrd1 :DWORD           ; 16 bit
    LOCAL wrd2 :DWORD
    LOCAL wrd3 :DWORD

    ------------------------------------------------------
    With the stack aligned to 256 bit, all LOCAL variables
    placed in descending order are correctly aligned
    ------------------------------------------------------

          *****************************************************************
          *************************************************************** #

  ; ---------------------------
  ; 16 byte aligned stack frame
  ; this is the minimum default
  ; ---------------------------
    STACKFRAME MACRO dflt:=<96>,dynm:=<128>,algn:=<16>
      stackframe_default equ <dflt>     ;; set default stack
      stackframe_dynamic equ <dynm>     ;; set byte count for ENTER mnemonic
      stackframe_align   equ <algn>     ;; align the stack by an interval of 16
      OPTION PROLOGUE:UseStackFrame
      OPTION EPILOGUE:EndStackFrame
    ENDM

  ; ---------------------------
  ; 32 byte aligned stack frame
  ; aligned for YMM sized data
  ; ---------------------------
    YMMSTACK MACRO dflt:=<96>,dynm:=<128>,algn:=<32>
      stackframe_default equ <dflt>     ;; set default stack
      stackframe_dynamic equ <dynm>     ;; set byte count for ENTER mnemonic
      stackframe_align   equ <algn>     ;; align the stack by an interval of 16
      OPTION PROLOGUE:UseStackFrame
      OPTION EPILOGUE:EndStackFrame
    ENDM

  ; ---------------------------
  ; 64 byte aligned stack frame
  ; aligned for ZMM sized data
  ; ---------------------------
    ZMMSTACK MACRO dflt:=<96>,dynm:=<128>,algn:=<64>
      stackframe_default equ <dflt>     ;; set default stack
      stackframe_dynamic equ <dynm>     ;; set byte count for ENTER mnemonic
      stackframe_align   equ <algn>     ;; align the stack by an interval of 16
      OPTION PROLOGUE:UseStackFrame
      OPTION EPILOGUE:EndStackFrame
    ENDM

  ; ----------------------------------
  ; User defined stack frame alignment
  ; This is mainly for clear coding of
  ; unusual requirements. All 3 args
  ; can be user defined, the last arg
  ; is for the stack alignment.
  ; ----------------------------------
    CUSTOMSTACK MACRO dflt:=<128>,dynm:=<128>,algn:=<128>
      stackframe_default equ <dflt>     ;; set default stack
      stackframe_dynamic equ <dynm>     ;; set byte count for ENTER mnemonic
      stackframe_align   equ <algn>     ;; align the stack by an interval of 16
      OPTION PROLOGUE:UseStackFrame
      OPTION EPILOGUE:EndStackFrame
    ENDM

  ; ------------------------
  ; turn the stack frame off
  ; ------------------------
    NOSTACKFRAME MACRO
      OPTION PROLOGUE:NONE
      OPTION EPILOGUE:NONE
    ENDM

  ; -----------------------------------------------------------

    lf  textequ chr$(13,10) ; CRLF
    nl  textequ chr$(13,10) ; CRLF
    tab textequ chr$(9)     ; tab
    qt  textequ chr$(34)    ; double quote
    lab textequ chr$(60)    ; <
    rab textequ chr$(62)    ; >
    xcl textequ chr$(33)    ; !
    lbr textequ chr$(40)    ; (
    rbr textequ chr$(41)    ; )

    mcat MACRO pbuff:REQ,args:VARARG
      LOCAL acnt
      acnt = argcount(args)
      invoke szmulticat,pbuff,acnt,args
    ENDM

    print MACRO pmem:REQ,args:VARARG
      mcat pmem, args
      invoke StdOut,pmem
    ENDM

  ; -------------------------------------------------------------
  ; returns the byte size of named memory variables, both LOCAL
  ; and GLOBAL. Do not pass addresses in the form of [reg+reg*8]
  ; -------------------------------------------------------------
    varsize MACRO var:REQ

      IF SIZE var EQ 1          ;; else get variable size
        EXITM <1>
      ELSEIF SIZE var EQ 2
        EXITM <2>
      ELSEIF SIZE var EQ 4
        EXITM <4>
      ELSEIF SIZE var EQ 8
        EXITM <8>
      ELSEIF SIZE var EQ 10
        EXITM <10>
      ELSEIF SIZE var EQ 16
        EXITM <16>
      ELSE
        EXITM <0>
      ENDIF
    ENDM

    testsize MACRO args:VARARG
      FOR arg,<args>
        % echo Byte count of arg = varsize(arg)
      ENDM
    ENDM

  ; -----------------------------------------------

    regsize MACRO reg
      LOCAL rval

      rval = 0

        FOR arg,<al,bl,cl,dl,sil,dil,bpl,spl,r8b,r9b,r10b,r11b,r12b,r13b,r14b,r15b>
          IFIDNI <arg>,<reg>
            rval = 1
          ENDIF
        ENDM
        IF rval NE 1
          goto WRD
        ELSE
          EXITM %rval
        ENDIF

     :WRD
        FOR arg,<ax,bx,cx,dx,si,di,bp,sp,r8w,r9w,r10w,r11w,r12w,r13w,r14w,r15w>
          IFIDNI <arg>,<reg>
            rval = 2
          ENDIF
        ENDM
        IF rval NE 2
          goto DWD
        ELSE
          EXITM %rval
        ENDIF

      :DWD
        FOR arg,<eax,ebx,ecx,edx,esi,edi,ebp,esp,r8d,r9d,r10d,r11d,r12d,r13d,r14d,r15d>
          IFIDNI <arg>,<reg>
            rval = 4
          ENDIF
        ENDM
        IF rval NE 4
          goto QWD
        ELSE
          EXITM %rval
        ENDIF

      :QWD
        FOR arg,<rax,rbx,rcx,rdx,rsi,rdi,rbp,rsp,r8,r9,r10,r11,r12,r13,r14,r15,mm0,mm1,mm2,mm3,mm4,mm5,mm6,mm7>
          IFIDNI <arg>,<reg>
            rval = 8
          ENDIF
        ENDM
        IF rval NE 8
          goto FP
        ELSE
          EXITM %rval
        ENDIF

      :FP
        FOR arg,<st(0),st(1),st(2),st(3),st(4),st(5),st(6),st(7)>
          IFIDNI <arg>,<reg>
            rval = 10
          ENDIF
        ENDM
        IF rval NE 10
          goto XMMW
        ELSE
          EXITM %rval
        ENDIF

      :XMMW
        FOR arg,<xmm0,xmm1,xmm2,xmm3,xmm4,xmm5,xmm6,xmm7,xmm8,xmm9,xmm10,xmm11,xmm12,xmm13,xmm14,xmm15>
          IFIDNI <arg>,<reg>
            rval = 16
          ENDIF
        ENDM
        IF rval NE 16
          goto YMMW
        ELSE
          EXITM %rval
        ENDIF

      :YMMW
        FOR arg,<ymm0,ymm1,ymm2,ymm3,ymm4,ymm5,ymm6,ymm7,ymm8,ymm9,ymm10,ymm11,ymm12,ymm13,ymm14,ymm15>
          IFIDNI <arg>,<reg>
            rval = 32
          ENDIF
        ENDM
        IF rval NE 32
          goto UNKNOWN
        ELSE
          EXITM %rval
        ENDIF

      :UNKNOWN
        rval = -1
        EXITM %rval
    ENDM

    testregs MACRO args:VARARG
      FOR arg,<args>
      % echo Reg size of arg = regsize(arg)
      ENDM
    ENDM

  ; -----------------------------------------------

  ; **********************************************************************

    getattr MACRO arg
      EXITM % opattr(arg)
    ENDM

  ; **********************************************************************

;; ¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤

    IMM equ <36>    ;;  36 = IMMEDIATE or CONSTANT
    LAB equ <37>    ;;  37 = LABEL, either local or global
    GLO equ <42>    ;;  42 = GLOBAL
    REG equ <48>    ;;  48 = REGISTER
    LOC equ <98>    ;;  98 = LOCAL

;; *************************************************************************************************
;; -------------------------------------------------------------------------------------------------

    procedure_call MACRO fname:REQ,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10, \
                                   a11,a12,a13,a14,a15,a16,a17,a18, \
                                   a19,a20,a21,a22,a23,a24,a25

    LOCAL lead,wrd2,ssize,sreg,svar

    ;; ********************
    ;; argument count limit
    ;; ********************
      IFNB <a25>
        % echo     ************************************
        % echo     argument limit exceeded in procedure -> fname
        % echo     argument count limit of 24 arguments
        % echo     ************************************
        .err
        goto function_call
      ENDIF

    ;; **************************
    ;; first 4 register arguments
    ;; **************************
      IFNB <a1>
        REGISTER a1,cl,cx,ecx,rcx
      ENDIF

      IFNB <a2>
        REGISTER a2,dl,dx,edx,rdx
      ENDIF

      IFNB <a3>
        REGISTER a3,r8b,r8w,r8d,r8
      ENDIF

      IFNB <a4>
        REGISTER a4,r9b,r9w,r9d,r9
      ENDIF
    ;; **************************
    ;; following stack arguments
    ;; **************************
      IFNB <a5>
        STACKARG a5,32
      ENDIF

      IFNB <a6>
        STACKARG a6,40
      ENDIF

      IFNB <a7>
        STACKARG a7,48
      ENDIF

      IFNB <a8>
        STACKARG a8,56
      ENDIF

      IFNB <a9>
        STACKARG a9,64
      ENDIF

      IFNB <a10>
        STACKARG a10,72
      ENDIF

      IFNB <a11>
        STACKARG a11,80
      ENDIF

      IFNB <a12>
        STACKARG a12,88
      ENDIF

      IFNB <a13>
        STACKARG a13,96
      ENDIF

      IFNB <a14>
        STACKARG a14,104
      ENDIF

      IFNB <a15>
        STACKARG a15,112
      ENDIF

      IFNB <a16>
        STACKARG a16,120
      ENDIF

      IFNB <a17>
        STACKARG a17,128
      ENDIF

      IFNB <a18>
        STACKARG a18,136
      ENDIF

      IFNB <a19>
        STACKARG a19,144
      ENDIF

      IFNB <a20>
        STACKARG a20,152
      ENDIF

      IFNB <a21>
        STACKARG a21,160
      ENDIF

      IFNB <a22>
        STACKARG a22,168
      ENDIF

      IFNB <a23>
        STACKARG a23,176
      ENDIF

      IFNB <a24>
        STACKARG a24,184
      ENDIF

    :function_call
    call fname

    ENDM

;; *************************************************************************************************
;; -----------------------------
;; Process the first 4 registers
;; -----------------------------
    REGISTER MACRO anum,breg,wreg,dreg,qreg
      LOCAL elbl

      ssize SIZESTR <anum>

    ;; ++++++++++++++++++++++
    ;; text avaluations first
    ;; ++++++++++++++++++++++
      IF ssize GT 4                             ;; handle ADDR notation
        lead SUBSTR <anum>,1,4
        IFIDNI lead,<ADDR>
          wrd2 SUBSTR <anum>,6
          lea qreg, wrd2
          goto elbl
        ENDIF
      ENDIF

      IF ssize GT 1                             ;; handle quoted text
        lead SUBSTR <anum>,1,1
        IFIDNI lead,<">
          mov qreg, reparg(anum)
          goto elbl
        ENDIF
      ENDIF

      IF ssize GT 8                             ;; handle BYTE PTR
        lead SUBSTR <anum>,1,8
        IFIDNI lead,<BYTE PTR>
          mov breg, anum
          goto elbl
        ENDIF
      ENDIF

      IF ssize GT 8                             ;; handle WORD PTR
        lead SUBSTR <anum>,1,8
        IFIDNI lead,<WORD PTR>
          mov wreg, anum
          goto elbl
        ENDIF
      ENDIF

      IF ssize GT 9                             ;; handle DWORD PTR
        lead SUBSTR <anum>,1,9
        IFIDNI lead,<DWORD PTR>
          mov dreg, anum
          goto elbl
        ENDIF
      ENDIF

      IF ssize GT 9                             ;; handle QWORD PTR
        lead SUBSTR <anum>,1,9
        IFIDNI lead,<QWORD PTR>
          mov qreg, anum
          goto elbl
        ENDIF
      ENDIF

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;; ++++++++++++++++++++++++++
    ;; data type evaluations next
    ;; ++++++++++++++++++++++++++

      IF getattr(anum) EQ IMM                           ;; IMMEDIATE
        mov qreg, anum
        goto elbl
      ENDIF

      IF getattr(anum) EQ REG                           ;; REGISTER
        sreg = regsize(anum)
        IF sreg EQ 0
          .err
        ELSEIF sreg EQ 1
          mov breg, anum
          goto elbl
        ELSEIF sreg EQ 2
          mov wreg, anum
          goto elbl
        ELSEIF sreg EQ 4
          mov dreg, anum
          goto elbl
        ELSEIF sreg EQ 8
          mov qreg, anum
          goto elbl
        ENDIF
      ENDIF

      IF getattr(anum) EQ GLO or getattr(anum) EQ LOC   ;; MEMORY OPERAND
        svar = varsize(anum)
        IF svar EQ 0
          .err
        ELSEIF svar EQ 1
          mov breg, anum
          goto elbl
        ELSEIF svar EQ 2
          mov wreg, anum
          goto elbl
        ELSEIF svar EQ 4
          mov dreg, anum
          goto elbl
        ELSEIF svar EQ 8
          mov qreg, anum
          goto elbl
        ENDIF
      ENDIF

    ;; +++++++++++++++++++++++
    ;; Unknown data type error
    ;; +++++++++++++++++++++++
      % echo     ***************************
      % echo     ERROR Unknown argument type -> anum        ;; ERROR UNKNOWN DATA TYPE
      % echo     ***************************
      .err

    :elbl
    ENDM

;; *************************************************************************************************
;; -------------------------------------------------------------
;; Process all following stack arguments up to 24 argument limit.
;; -------------------------------------------------------------
    STACKARG MACRO anum,disp
      LOCAL elbl

      ssize SIZESTR <anum>

    ;; ++++++++++++++++++++++
    ;; text avaluations first
    ;; ++++++++++++++++++++++
      IF ssize GT 4                             ;; handle ADDR notation
        lead SUBSTR <anum>,1,4
        IFIDNI lead,<ADDR>
          wrd2 SUBSTR <anum>,6
          lea rax, wrd2
          mov QWORD PTR [rsp+disp], rax
          goto elbl
        ENDIF
      ENDIF

      IF ssize GT 1                             ;; handle quoted text
        lead SUBSTR <anum>,1,1
        IFIDNI lead,<">
          mov rax, reparg(anum)
          mov QWORD PTR [rsp+disp], rax
          goto elbl
        ENDIF
      ENDIF

      IF ssize GT 8                             ;; handle BYTE PTR
        lead SUBSTR <anum>,1,8
        IFIDNI lead,<BYTE PTR>
          mov al, anum
          mov BYTE PTR [rsp+disp], al
          goto elbl
        ENDIF
      ENDIF

      IF ssize GT 8                             ;; handle WORD PTR
        lead SUBSTR <anum>,1,8
        IFIDNI lead,<WORD PTR>
          mov ax, anum
          mov WORD PTR [rsp+disp], ax
          goto elbl
        ENDIF
      ENDIF

      IF ssize GT 9                             ;; handle DWORD PTR
        lead SUBSTR <anum>,1,9
        IFIDNI lead,<DWORD PTR>
          mov eax, anum
          mov DWORD PTR [rsp+disp], eax
          goto elbl
        ENDIF
      ENDIF

      IF ssize GT 9                             ;; handle QWORD PTR
        lead SUBSTR <anum>,1,9
        IFIDNI lead,<QWORD PTR>
          mov rax, anum
          mov QWORD PTR [rsp+disp], rax
          goto elbl
        ENDIF
      ENDIF

    ;; ++++++++++++++++++++++++++
    ;; data type evaluations next
    ;; ++++++++++++++++++++++++++
      IF getattr(anum) EQ IMM                           ;; IMMEDIATE
        mov QWORD PTR [rsp+disp], anum
        goto elbl
      ENDIF

      IF getattr(anum) EQ REG                           ;; REGISTER
        sreg = regsize(anum)
        IF sreg EQ 0
          .err
        ENDIF
        IF sreg EQ 1
          mov BYTE PTR [rsp+disp], anum
          goto elbl
        ENDIF
        IF sreg EQ 2
          mov WORD PTR [rsp+disp], anum
          goto elbl
        ENDIF
        IF sreg EQ 4
          mov DWORD PTR [rsp+disp], anum
          goto elbl
        ENDIF
        IF sreg EQ 8
          mov QWORD PTR [rsp+disp], anum
          goto elbl
        ENDIF
      ENDIF

      IF getattr(anum) EQ GLO or getattr(anum) EQ LOC   ;; MEMORY OPERAND
        svar = varsize(anum)
        IF svar EQ 0
          .err
        ELSEIF svar EQ 1
          mov al, anum
          mov BYTE PTR [rsp+disp], al
          goto elbl
        ELSEIF svar EQ 2
          mov ax, anum
          mov WORD PTR [rsp+disp], ax
          goto elbl
        ELSEIF svar EQ 4
          mov eax, anum
          mov DWORD PTR [rsp+disp], eax
          goto elbl
        ELSEIF svar EQ 8
          mov rax, anum
          mov QWORD PTR [rsp+disp], rax
          goto elbl
        ENDIF
      ENDIF

    ;; +++++++++++++++++++++++
    ;; Unknown data type error
    ;; +++++++++++++++++++++++
      % echo     ***************************
      % echo     ERROR Unknown argument type -> anum        ;; ERROR UNKNOWN DATA TYPE
      % echo     ***************************
      .err

    :elbl
    ENDM

;; -------------------------------------------------------------------------------------------------
;; *************************************************************************************************

    invoke MACRO fname:REQ,args:VARARG
      procedure_call fname,args
    ENDM

    fn MACRO fname:REQ,args:VARARG
      procedure_call fname,args
    ENDM

    function MACRO fname:REQ,args:VARARG
      procedure_call fname,args
      EXITM <rax>
    ENDM

    rv MACRO fname:REQ,args:VARARG
      procedure_call fname,args
      EXITM <rax>
    ENDM

  ; ************************************************

  ; --------------------------------------------
  ; register call for no stack frame procedures
  ; while avoiding the HLL shadow space loading.
  ; --------------------------------------------
    register_call MACRO pname,ag1,ag2,ag3,ag4
      IFNB <ag4>
        mov r9, ag4
      ENDIF
      IFNB <ag3>
        mov r8, ag3
      ENDIF
      IFNB <ag2>
        mov rdx, ag2
      ENDIF
      IFNB <ag1>
        mov rcx, ag1
      ENDIF
      call pname
    ENDM
  ; -----------------------------------------------

  ; -----------------
  ; statement wrapper
  ; -----------------
    rcall MACRO pname,ag1,ag2,ag3,ag4
      register_call pname,ag1,ag2,ag3,ag4
    ENDM

  ; ----------------
  ; function wrapper
  ; ----------------
    rvcall MACRO pname,ag1,ag2,ag3,ag4
      register_call pname,ag1,ag2,ag3,ag4
      EXITM <rax>
    ENDM

  ; ************************************************

    run_time_comparisons MACRO
      % echo     **************************************
      % echo     variable run time comparison operators
      % echo     **************************************
      % echo     -------------
      % echo     equality test
      % echo     -------------
      % echo     eq equal
      % echo     ne not equal
      % echo    
      % echo     -----------------
      % echo     signed comparison
      % echo     -----------------
      % echo     gt signed greater than
      % echo     lt signed less than
      % echo     ge signed greater than or equal
      % echo     le signed less than or equal
      % echo    
      % echo     -------------------
      % echo     unsigned comparison
      % echo     -------------------
      % echo     ua unsigned above
      % echo     ub unsigned below
      % echo     ae unsigned above or equal
      % echo     be unsigned below or equal
      % echo     **************************************
    ENDM

  ; **********************************************
  ; ----------------------------------------------
    evaluate_conditional_branch MACRO args
      LOCAL arg1,arg2,arg3,arg4,arg5,arg6,cntr,flag

    ;; --------------------------
    ;; jump label IF var1 LT var2
    ;;
    ;; arg1 label
    ;; arg2 IF WHILE or UNTIL
    ;; arg3 variable 1
    ;; arg4 comparison operator
    ;; arg5 variable 2
    ;; --------------------------

      cntr = 1                      ;; counter determined which buffer is being written to
      flag = 0

      arg1 equ <>
      arg2 equ <>
      arg3 equ <>
      arg4 equ <>
      arg5 equ <>
      arg6 equ <>

      FORC char,<args>
        IFIDN <char>,< >            ;; test if char is a space
          IF flag eq 0
            cntr = cntr + 1         ;; only increment the counter if the flag is clear
          ENDIF
          flag = 1                  ;; set the flag so you only get 1 increment of cntr
          goto over
        ENDIF
        flag = 0                    ;; clear the flag when the next char is not a space
        IF cntr eq 1
          arg1 CATSTR arg1,<char>
        ELSEIF cntr eq 2
          arg2 CATSTR arg2,<char>
        ELSEIF cntr eq 3
          arg3 CATSTR arg3,<char>
        ELSEIF cntr eq 4
          arg4 CATSTR arg4,<char>
        ELSEIF cntr eq 5
          arg5 CATSTR arg5,<char>
        ELSEIF cntr eq 6
          arg6 CATSTR arg6,<char>
        ENDIF
      :over
      ENDM

      IFNB arg6
        .err <too many arguments - args>
        goto bye
      ENDIF

      IFDIFI arg2,<IF>
        IFDIFI arg2,<WHILE>
          IFDIFI arg2,<UNTIL>
            .err <arg2: IF WHILE or UNTIL expected - args>
            goto bye
          ENDIF
        ENDIF
      ENDIF

      IFIDNI arg4,<eq>          ;; equal
        mov rax, arg3
        cmp rax, arg5
        je arg1
      ELSEIFIDNI arg4,<ne>      ;; not equal
        mov rax, arg3
        cmp rax, arg5
        jne arg1
      ELSEIFIDNI arg4,<gt>      ;; signed greater than
        mov rax, arg3
        cmp rax, arg5
        jg arg1
      ELSEIFIDNI arg4,<lt>      ;; signed less than
        mov rax, arg3
        cmp rax, arg5
        jl arg1
      ELSEIFIDNI arg4,<ge>      ;; signed greater or equal
        mov rax, arg3
        cmp rax, arg5
        jge arg1
      ELSEIFIDNI arg4,<le>      ;; signed less than or equal
        mov rax, arg3
        cmp rax, arg5
        jle arg1
      ELSEIFIDNI arg4,<be>      ;; unsigned below or equal
        mov rax, arg3
        cmp rax, arg5
        jbe arg1
      ELSEIFIDNI arg4,<ae>      ;; unsigned above or equal
        mov rax, arg3
        cmp rax, arg5
        jae arg1
      ELSEIFIDNI arg4,<ua>      ;; unsigned above
        mov rax, arg3
        cmp rax, arg5
        ja arg1
      ELSEIFIDNI arg4,<ub>      ;; unsigned lower than
        mov rax, arg3
        cmp rax, arg5
        jb arg1
      ELSE
        .err <ERROR invalid runtime comparison operator - args>
        run_time_comparisons
        goto bye
      ENDIF

    :bye
    ENDM

  ; ||||||||||||||||||||||||||||||||||||||||||||||||||||||

    jump MACRO args
      evaluate_conditional_branch args
    ENDM

  ; ||||||||||||||||||||||||||||||||||||||||||||||||||||||

; *************************************************************************
; -------------------------------------------------------------------------

    do_macro MACRO
      LOCAL name
      lbl__@@__@@ equ <name>
      lbl__@@__@@:
    ENDM

    bottom_evaluate MACRO args
      LOCAL arg1,arg2,arg3,arg4,arg5,cntr,flag

      cntr = 1                      ;; counter determined which buffer is being written to
      flag = 0

      arg1 equ <>
      arg2 equ <>
      arg3 equ <>
      arg4 equ <>
      arg5 equ <>

      FORC char,<args>
        IFIDN <char>,< >            ;; test if char is a space
          IF flag eq 0
            cntr = cntr + 1         ;; only increment the counter if the flag is clear
          ENDIF
          flag = 1                  ;; set the flag so you only get 1 increment of cntr
          goto over
        ENDIF
        flag = 0                    ;; clear the flag when the next char is not a space
        IF cntr eq 1
          arg1 CATSTR arg1,<char>   ;; UNTIL
        ELSEIF cntr eq 2
          arg2 CATSTR arg2,<char>   ;; VAR1
        ELSEIF cntr eq 3
          arg3 CATSTR arg3,<char>   ;; EQ
        ELSEIF cntr eq 4
          arg4 CATSTR arg4,<char>   ;; VAR2
        ELSEIF cntr eq 5
          arg5 CATSTR arg5,<char>   ;; too many arguments
        ENDIF
      :over
      ENDM

      IFNB arg5
        .err <too many arguments - args>
        goto bye
      ENDIF

      IFDIFI arg1,<IF>
        IFDIFI arg1,<WHILE>
          IFDIFI arg1,<UNTIL>
            .err <arg1: IF WHILE or UNTIL expected - args>
            goto bye
          ENDIF
        ENDIF
      ENDIF

      IFIDNI arg3,<eq>          ;; equal
        mov rax, arg2
        cmp rax, arg4
        je lbl__@@__@@
      ELSEIFIDNI arg3,<ne>      ;; not equal
        mov rax, arg2
        cmp rax, arg4
        jne lbl__@@__@@
      ELSEIFIDNI arg3,<gt>      ;; signed greater than
        mov rax, arg2
        cmp rax, arg4
        jg lbl__@@__@@
      ELSEIFIDNI arg3,<lt>      ;; signed less than
        mov rax, arg2
        cmp rax, arg4
        jl lbl__@@__@@
      ELSEIFIDNI arg3,<ge>      ;; signed greater or equal
        mov rax, arg2
        cmp rax, arg4
        jge lbl__@@__@@
      ELSEIFIDNI arg3,<le>      ;; signed less than or equal
        mov rax, arg2
        cmp rax, arg4
        jle lbl__@@__@@
      ELSEIFIDNI arg3,<be>      ;; unsigned below or equal
        mov rax, arg2
        cmp rax, arg4
        jbe lbl__@@__@@
      ELSEIFIDNI arg3,<ae>      ;; unsigned above or equal
        mov rax, arg2
        cmp rax, arg4
        jae lbl__@@__@@
      ELSEIFIDNI arg3,<ua>      ;; unsigned above
        mov rax, arg2
        cmp rax, arg4
        ja lbl__@@__@@
      ELSEIFIDNI arg3,<ub>      ;; unsigned lower than
        mov rax, arg2
        cmp rax, arg4
        jb lbl__@@__@@
      ELSE
        .err <ERROR invalid runtime comparison operator - args>
        run_time_comparisons
        goto bye
      ENDIF

    :bye

    ENDM

  ; ||||||||||||||||||||||||||||||||||||||||||||||||||||||

    .do MACRO
      do_macro
    ENDM

    .loop MACRO args
      bottom_evaluate args
    ENDM

  ; ||||||||||||||||||||||||||||||||||||||||||||||||||||||

; -------------------------------------------------------------------------
; *************************************************************************

    top_evaluate MACRO args
      LOCAL anon1,anon2,arg1,arg2,arg3,arg4,arg5,cntr,flag
      topl@@__??@@ equ <anon1>
      outl_@_?_$$ equ <anon2>
      topl@@__??@@:

      cntr = 1                      ;; counter determined which buffer is being written to
      flag = 0

      arg1 equ <>
      arg2 equ <>
      arg3 equ <>
      arg4 equ <>
      arg5 equ <>

      FORC char,<args>
        IFIDN <char>,< >            ;; test if char is a space
          IF flag eq 0
            cntr = cntr + 1         ;; only increment the counter if the flag is clear
          ENDIF
          flag = 1                  ;; set the flag so you only get 1 increment of cntr
          goto over
        ENDIF
        flag = 0                    ;; clear the flag when the next char is not a space
        IF cntr eq 1
          arg1 CATSTR arg1,<char>   ;; IF WHILE or UNTIL
        ELSEIF cntr eq 2
          arg2 CATSTR arg2,<char>   ;; VAR1
        ELSEIF cntr eq 3
          arg3 CATSTR arg3,<char>   ;; EQ
        ELSEIF cntr eq 4
          arg4 CATSTR arg4,<char>   ;; VAR2
        ELSEIF cntr eq 5
          arg5 CATSTR arg5,<char>   ;; too many arguments
        ENDIF
      :over
      ENDM

      IFNB arg5
        .err <too many arguments - args>
        goto bye
      ENDIF

      IFDIFI arg1,<IF>
        IFDIFI arg1,<WHILE>
          IFDIFI arg1,<UNTIL>
            .err <arg1: IF WHILE or UNTIL expected - args>
            goto bye
          ENDIF
        ENDIF
      ENDIF

      IFIDNI arg3,<eq>          ;; equal
        mov rax, arg2
        cmp rax, arg4
        jne outl_@_?_$$
      ELSEIFIDNI arg3,<ne>      ;; not equal
        mov rax, arg2
        cmp rax, arg4
        je outl_@_?_$$
      ELSEIFIDNI arg3,<gt>      ;; signed greater than
        mov rax, arg2
        cmp rax, arg4
        jle outl_@_?_$$
      ELSEIFIDNI arg3,<lt>      ;; signed less than
        mov rax, arg2
        cmp rax, arg4
        jge outl_@_?_$$
      ELSEIFIDNI arg3,<ge>      ;; signed greater or equal
        mov rax, arg2
        cmp rax, arg4
        jl outl_@_?_$$
      ELSEIFIDNI arg3,<le>      ;; signed less than or equal
        mov rax, arg2
        cmp rax, arg4
        jg outl_@_?_$$
      ELSEIFIDNI arg3,<be>      ;; unsigned below or equal
        mov rax, arg2
        cmp rax, arg4
        ja outl_@_?_$$
      ELSEIFIDNI arg3,<ae>      ;; unsigned above or equal
        mov rax, arg2
        cmp rax, arg4
        jb outl_@_?_$$
      ELSEIFIDNI arg3,<ua>      ;; unsigned above
        mov rax, arg2
        cmp rax, arg4
        jbe outl_@_?_$$
      ELSEIFIDNI arg3,<ub>      ;; unsigned lower than
        mov rax, arg2
        cmp rax, arg4
        jae outl_@_?_$$
      ELSE
        .err <ERROR invalid runtime comparison operator - args>
        run_time_comparisons
        goto bye
      ENDIF

    :bye

    ENDM

  ; -------------------------------

    te_end MACRO
      jmp topl@@__??@@
    outl_@_?_$$:
    ENDM

  ; -------------------------------

  ; ||||||||||||||||||||||||||||||||||||||||||||||||||||||

    .rept MACRO args
      top_evaluate args
    ENDM

    .endr MACRO
      te_end
    ENDM

  ; ||||||||||||||||||||||||||||||||||||||||||||||||||||||

; -------------------------------------------------------------------------
; *************************************************************************

    .return MACRO arg
      IF arg ne 0
        mov rax, arg
        ret
      ELSE
        xor rax, rax
        ret
      ENDIF
    ENDM

    allocregs MACRO
    .data?
      .reg_rax dq ?
      .reg_rbx dq ?
      .reg_rcx dq ?
      .reg_rdx dq ?
      .reg_rsi dq ?
      .reg_rdi dq ?
      .reg_rbp dq ?
      .reg_rsp dq ?
      .reg_r8  dq ?
      .reg_r9  dq ?
      .reg_r10 dq ?
      .reg_r11 dq ?
      .reg_r12 dq ?
      .reg_r13 dq ?
      .reg_r14 dq ?
      .reg_r15 dq ?
    .code
    ENDM

    saveall MACRO
      allocregs
      mov .reg_rax, rax
      mov .reg_rbx, rbx
      mov .reg_rcx, rcx
      mov .reg_rdx, rdx
      mov .reg_rsi, rsi
      mov .reg_rdi, rdi
      mov .reg_rbp, rbp
      mov .reg_rsp, rsp
      mov .reg_r8,  r8
      mov .reg_r9,  r9
      mov .reg_r10, r10
      mov .reg_r11, r11
      mov .reg_r12, r12
      mov .reg_r13, r13
      mov .reg_r14, r14
      mov .reg_r15, r15
    ENDM
      
    restoreall MACRO
      mov rax, .reg_rax
      mov rbx, .reg_rbx
      mov rcx, .reg_rcx
      mov rdx, .reg_rdx
      mov rsi, .reg_rsi
      mov rdi, .reg_rdi
      mov rbp, .reg_rbp
      mov rsp, .reg_rsp
      mov r8,  .reg_r8
      mov r9,  .reg_r9
      mov r10, .reg_r10
      mov r11, .reg_r11
      mov r12, .reg_r12
      mov r13, .reg_r13
      mov r14, .reg_r14
      mov r15, .reg_r15
    ENDM

; *************************************************************************
; -------------------------------------------------------------------------

    .multiple_instruction MACRO delm:REQ,args:VARARG
      LOCAL arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg0
      LOCAL argA,agrB,argC,argD,argE,argF,cntr,flag

      cntr = 1                      ;; counter determined which buffer is being written to
      flag = 0                      ;; flag starts as clear

      arg1 equ <>
      arg2 equ <>
      arg3 equ <>
      arg4 equ <>
      arg5 equ <>
      arg6 equ <>
      arg7 equ <>
      arg8 equ <>
      arg9 equ <>
      arg0 equ <>
      argA equ <>
      argB equ <>
      argC equ <>
      argD equ <>
      argE equ <>
      argF equ <>

    ;; ---------------------------------
      FORC char,<args>
        IFIDN <char>,<delm>         ;; test if char is the delimiter
          IF flag eq 0
            cntr = cntr + 1         ;; only increment the counter if the flag is clear
          ENDIF
          flag = 1                  ;; set the flag so you only get 1 increment of cntr
          goto over
        ENDIF
        flag = 0                    ;; clear the flag when the next char is not a space

        IF cntr eq 1
          arg1 CATSTR arg1,<char>   ;;
        ELSEIF cntr eq 2
          arg2 CATSTR arg2,<char>   ;;
        ELSEIF cntr eq 3
          arg3 CATSTR arg3,<char>   ;;
        ELSEIF cntr eq 4
          arg4 CATSTR arg4,<char>   ;;
        ELSEIF cntr eq 5
          arg5 CATSTR arg5,<char>   ;;
        ELSEIF cntr eq 6
          arg6 CATSTR arg6,<char>   ;;
        ELSEIF cntr eq 7
          arg7 CATSTR arg7,<char>   ;;
        ELSEIF cntr eq 8
          arg8 CATSTR arg8,<char>   ;;
        ELSEIF cntr eq 9
          arg9 CATSTR arg9,<char>   ;;
        ELSEIF cntr eq 10
          arg0 CATSTR arg0,<char>   ;;
        ELSEIF cntr eq 11
          argA CATSTR argA,<char>   ;;
        ELSEIF cntr eq 12
          argB CATSTR argB,<char>   ;;
        ELSEIF cntr eq 13
          argC CATSTR argC,<char>   ;;
        ELSEIF cntr eq 14
          argD CATSTR argD,<char>   ;;
        ELSEIF cntr eq 15
          argE CATSTR argE,<char>   ;;
        ELSEIF cntr eq 16
          argF CATSTR argF,<char>   ;;
        ELSEIF cntr eq 17
          % echo *********************************************
          % echo ERROR : too many arguments, 16 argument limit
          % echo *********************************************
          .err < <<< too many arguments >>> >
          goto over
        ENDIF
      :over
      ENDM
    ;; ---------------------------------

      arg1
      arg2
      arg3
      arg4
      arg5
      arg6
      arg7
      arg8
      arg9
      arg0
      argA
      argB
      argC
      argD
      argE
      argF

    ENDM

; --------------------------------

    .mi MACRO args:VARARG           ;; multiple instructions
      .multiple_instruction :,args
    ENDM

    .ma MACRO args:VARARG           ;; multiple arguments
      .multiple_instruction #,args
    ENDM

    .mn MACRO args:VARARG           ;; alternate multiple arguments
      .multiple_instruction &,args
    ENDM

    .mx MACRO args:VARARG           ;; alternate multiple arguments
      .multiple_instruction ^,args
    ENDM

  ;; --------------------------------
  ;; These delimiters also work * $ |
  ;; --------------------------------

; -------------------------------------------------------------------------
; *************************************************************************

    .exit MACRO optvar:=<0>
      invoke ExitProcess,optvar
    ENDM

    ucode$ MACRO ansi$
    LOCAL buffer,pbuffer
      .data?
        buffer db 512 dup (?)
      .data
        pbuffer dq buffer
      .code
      invoke MultiByteToWideChar,CP_ACP,MB_PRECOMPOSED,ansi$,-1,pbuffer,256
      EXITM <pbuffer>
    Endm

    L MACRO ansi$
      EXITM <ucode$(ansi$)>
    ENDM

  ; ========================================================

    GdiPlusBegin MACRO
      .data
        gdii GdiplusStartupInput <>
        GDItoken@@@@ dq ?
      .code
      mov gdii.GdiplusVersion, 1
      mov gdii.DebugEventCallback, 0
      mov gdii.SuppressBackgroundThread, 0
      mov gdii.SuppressExternalCodecs, 0
      invoke GdiplusStartup,ADDR GDItoken@@@@,ADDR gdii,0
    ENDM

    GdiPlusEnd MACRO
      invoke GdiplusShutdown,GDItoken@@@@        ; cleanup on exit
    ENDM

  ; ========================================================

    HighPriority MACRO
      invoke SetPriorityClass,rv(GetCurrentProcess),HIGH_PRIORITY_CLASS
    ENDM

    NormalPriority MACRO
      invoke SetPriorityClass,rv(GetCurrentProcess),NORMAL_PRIORITY_CLASS
    ENDM

    ssorta MACRO parr,acnt
      rcall rawssort,parr,acnt
    ENDM

    ssortd MACRO parr,acnt
      rcall rawssort,parr,acnt
      rcall arrev,parr,acnt
    ENDM

  ; --------------------------------------------------
  ; asynchronously execute an external executable file
  ; --------------------------------------------------
    exec MACRO filename
      invoke execute,filename
    ENDM

  ; -------------------------------------------------
  ; synchronously execute an external executable file
  ; -------------------------------------------------
    shell MACRO szAppName,optvar:=<NORMAL_PRIORITY_CLASS>
      invoke winshell,szAppName,optvar
    ENDM


