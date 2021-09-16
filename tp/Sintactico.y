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
%token WHILE IF INTEGER FLOAT STRING ELSE THEN DECVAR ENDECVAR AS IN AND OR NOT LONG
%token  DISPLAY DIM COMA ENDIF ENDWHILE DO GET PAR_A PAR_C COR_A COR_C

%token ID CONST_ENT CONST_REAL CONST_STR
%token COMENTARIO

%%


programa:
    sentencia
    | programa sentencia ;
    
sentencia:
     declaracion
    |asignacion
    |ciclo
    |seleccion
    |salida
    |entrada ;

declaracion:
    DECVAR DIM COR_A listavar COR_C AS COR_A listatipodato COR_C ENDECVAR;

listavar:
    ID
    | listavar COMA ID;

listatipodato:
    tipodato
    | listatipodato COMA tipodato;

tipodato:
    INTEGER
    | FLOAT
    | STRING;

seleccion:
    IF condicion THEN programa ELSE programa ENDIF
    | IF condicion THEN programa ENDIF;

ciclo:
    WHILE ID IN COR_A lista COR_C DO sentencia ENDWHILE;

entrada:
    GET factor;

salida:
    DISPLAY CONST_STR;

asignacion:
    ID OP_ASIG expresion;

condicion:
    comparacion
    | condicion AND comparacion
    | condicion OR comparacion
    | NOT condicion AND comparacion
    | NOT condicion OR comparacion;

comparacion:
    expresion comparador expresion;

expresion:
    expresion OP_SUMA termino
    | expresion OP_RESTA termino
    | termino;

termino:
    termino OP_MULT factor
    | termino OP_DIV factor
    | factor;

longitud:
    LONG PAR_A lista PAR_C;

lista:
    factor
    | lista COMA factor;

factor:
    expresion
    | CONST_REAL
    | ID
    | CONST_ENT;

comparador:
    OP_MAY 
    | OP_MEN
    | OP_MENIGU
    | OP_MAYIGU
    | OP_IGUAL
    | OP_DIF;



%%

