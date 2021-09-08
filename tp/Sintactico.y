%{
#include <stdio.h>
#include <stdlib.h>

#include "y.tab.h"
int yystopparser=0;
FILE  *yyin;
int yylex();
int yyparse();
int yyerror();
%}

%token ID
%token OP_SUMA COMA PUNTOYCOMA OP_MAY OP_MAYIGU OP_MEN OP_MENIGU OP_IGUAL OP_DIF OP_DIV OP_MULT OP_ASIG
%token CONST_ENT CONST_REAL CONST_STR COMENTARIO AND OR NOT ENDIF
%token DECVAR DIM GET ENDDEC DISPLAY WHILE INTEGER FLOAT ELSE PAR_A PAR_C LLAV_A LLAV_C COR_A COR_C



%%

expresion: CONST_ENT OP_SUMA CONST_ENT                  {printf("Suma");}

%%

