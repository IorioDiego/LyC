include macros2.asm
include numbers.asm
include macros.asm
.MODEL LARGE
.386
.STACK 200h
.DATA

_d                   dd      ?                             
_c                   dd      ?                             
_a                   dd      ?                             
_var1                dd      ?                             
_var2                dd      ?                             
@cte0                dd      3.0                           
@real0               dd      4.4                           
@cte1                dd      3.0                           
_HOLA_MUNDOOOOO      db      "HOLA MUNDOOOOO"              , '$', 14 dup (?)

.CODE
MOV EAX,@DATA
MOV DS,EAX
MOV ES,EAX;

FLD @cte0
FLD _var2
FXCH
FADD
FLD @real0
FLD _var1
FXCH
FADD
FLD @cte1
FLD _d
FXCH
FADD
FSTP _c
displayString _HOLA_MUNDOOOOO
displayFloat var1,2

mov ax,4c00h
int 21h
End