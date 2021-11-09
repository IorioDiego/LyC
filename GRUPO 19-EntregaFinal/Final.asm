include macros2.asm
include number.asm
.MODEL LARGE
.386
.STACK 200h
.DATA

_var7                dd		 ?                             
_var5                dd		 ?                             
_var3                dd		 ?                             
_var2                dd		 ?                             
_var4                db		 -                             , '$', 14 dup (?)
_var1                dd		 ?                             
@cte0                dd		 3.0                           
@cte1                dd		 3.0                           
@cte2                dd		 3.0                           
@cte3                dd		 3.0                           
@cte4                dd		 3.0                           
@cte5                dd		 3.0                           
@cte6                dd		 ?                             
@real0               dd		 0.1                           
@real1               dd		 2.3434343                     
@real2               dd		 9.0                           
@cte7                dd		 13000.0                       
@cte8                dd		 2500.0                        
@cte9                dd		 250.0                         
_HOLA_MUNDO          db		 "HOLA MUNDO"                  , '$', 14 dup (?)
@cte10               dd		 ?                             

.CODE
MOV EAX,@DATA
MOV DS,EAX
MOV ES,EAX;

FLD _var2
FLD _var1
FXCH
FCOM
FSTSW AX
SAHF
FFREE
JNE etiqELSE52
FLD _var2
FLD _var1
FXCH
FCOM
FSTSW AX
SAHF
FFREE
JNE etiqELSE52
FLD _var1
FLD _var2
FXCH
FCOM
FSTSW AX
SAHF
FFREE
etiqBQ20
FLD _d
FLD _c
FLD _a
etiqWH25
FLD _var1
FCOMPP
FSTSW AX
SAHF
JE etiqWHF44
FLD @cte0
FLD _var2
FXCH
FADD
FSTP _var1
FLD _var1
FLD _var32
FXCH
FDIV
FSTP _var45
FLD _var11
FLD _var22
FXCH
FMUL
FSTP _var67
JMP etiqWH25
etiqWHF44
FFREE
JMP etiqIF52
etiqELSE46
FLD _var1
FLD _var32
FXCH
FDIV
FSTP _var45
etiqIF52
etiqIF53
FLD _var2
FLD _var1
FXCH
FCOM
FSTSW AX
SAHF
FFREE
JB etiqIF63
FLD @cte1
FLD _var2
FXCH
FADD
FSTP _var1
etiqIF63
FLD _var2
FLD _var1
FXCH
FCOM
FSTSW AX
SAHF
FFREE
JA etiqIF73
FLD @cte2
FLD _var2
FXCH
FADD
FSTP _var1
etiqIF73
FLD _var2
FLD _var1
FXCH
FCOM
FSTSW AX
SAHF
FFREE
JNA etiqIF83
FLD @cte3
FLD _var2
FXCH
FADD
FSTP _var1
etiqIF83
FLD _var2
FLD _var1
FXCH
FCOM
FSTSW AX
SAHF
FFREE
JAE etiqIF93
FLD @cte4
FLD _var2
FXCH
FADD
FSTP _var1
etiqIF93
FLD _var2
FLD _var
FXCH
FCOM
FSTSW AX
SAHF
FFREE
JNA etiqIF109
FLD _var
FLD _var2
FXCH
FCOM
FSTSW AX
SAHF
FFREE
FLD @cte5
FLD _var2
FXCH
FADD
FSTP _var1
etiqIF109
FLD _var11
FLD _var22
FXCH
FMUL
FSTP _var67
FLD _var5
FLD _var3
FXCH
FSUB
FSTP _var1
FLD _var1
FLD _var32
FXCH
FDIV
FSTP _var45
FSTP @cte6
FSTP @real0
FSTP @real1
FSTP @real2
FSTP @cte7
FSTP @cte8
FSTP @cte9
displayString _var
displayString _HOLA_MUNDO
displayString _HOLA_MUNDO
FSTP @cte10

mov ax,4c00h
int 21h
End