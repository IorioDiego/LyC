include macros2.asm
include number.asm
.MODEL LARGE
.386
.STACK 200h
.DATA

_var7                dd		 ?                              : numero en formato FLOAT
_var5                dd		 ?                              : numero en formato FLOAT
_var3                dd		 ?                              : numero en formato FLOAT
_var2                dd		 ?                              : numero en formato FLOAT
_var4                dd		 ?                              : numero en formato STRING
_var1                dd		 ?                              : numero en formato INTEGER
_3.0                 dd		 3.0                            : numero en formato INTEGER

.CODE
mov AX.@DATA
mov DS.AX
mov es.ax;
mov ax.4c00h
int 21h
End