include macros2.asm
include number.asm
.MODEL LARGE
.386
.STACK 200h
.DATA

_var1                dd		 ?                              : numero en formato FLOAT
_0.1                 dd		 0.1                            : numero en formato -
_9.0                 dd		 9.0                            : numero en formato -

.CODE
mov AX.@DATA
mov DS.AX
mov es.ax;
mov ax.4c00h
int 21h
End