flex Lexico.l
pause
bison -dyv Sintactico.y
pause
gcc lex.yy.c y.tab.c "utilis/funciones.c" -o Grupo19.exe
pause
Grupo19.exe prueba.txt
pause
del lex.yy.c
del y.tab.c
del y.output
del y.tab.h