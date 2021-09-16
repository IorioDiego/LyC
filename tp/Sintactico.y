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

%start programa 
%right OP_ASIG 
%left OP_SUMA OP_RESTA
%left OP_MULT OP_DIV

%token OP_MAY OP_MAYIGU OP_MEN OP_MENIGU OP_IGUAL OP_DIF
%token WHILE IF INTEGER FLOAT STRING ELSE THEN GET DIM DECVAR ENDECVAR AS IN AND OR NOT 
%token  DISPLAY DIM COMA ENDIF ENDWHILE DO GET DISPLAY DIM PAR_A PAR_C

%token CONST_ENT CONST_REAL CONST_STR 
%token COMENTARIO







%%

program: 
    programa ;

programa:
    programa sentencia ;
    
sentencia:
     declaracion
    |asignacion
    |ciclo
    |seleccion
    |salida
    |entrada ;

declaracion:
    DECVAR DIM COR_A listavar COR_C AS COR_A tipodato COR_C
    | 


%%

