%{ 
#include <stdio.h>
#include <stdlib.h>


FILE  *yyin;
int yylval;
int yylex();
int yyparse();
int yyerror();
%}





%option noyywrap
%option yylineno




DIGITO		            ([0-9])
LETRA			        [a-zA-Z]


CONST_REAL              {DIGITO}+"."{DIGITO}+|"."{DIGITO}|{DIGITO}+"."
CONST_STR               \".*\" 
CONST_ENT	            {DIGITO}+
COMENTARIO              \/\*.\*\/
ID		            	({LETRA}|{DIGITO})+                    

COMA                    [,]
PUNTOYCOMA              [;]
OP_MAY		            [>]
OP_MAYIGU	            ">="
OP_MEN		            [<]
OP_MENIGU	            "<="
OP_IGUAL	            "=="
OP_DIF		            "!="
OP_DIV                  [/]
OP_SUMA                 [+]
OP_MULT		            [*]
OP_ASIG		            [:=]




PAR_A	                [(]
PAR_C	                [)]
LLAV_A	                [{]
LLAV_C              	[}]
COR_A                   [[]
COR_C                   []]


DIM                     "DIM"
DISPLAY                 "DISPLAY"
GET                     "GET"
IF			            "if"
ENDIF                   "ENDIF"
WHILE	            	"while"
DECVAR		            "DECVAR"
ENDDEC	            	"ENDDEC"
INTEGER	            	"Integer"
FLOAT		            "Float"
ELSE		            "else"
AND                     "AND"
OR                      "OR"
NOT                     "NOT"
AS                      "AS"
  
%%



{COMA}             printf("\nComa: %s\n",yytext);
{PUNTOYCOMA}     printf("\nPunto y Coma: %s\n",yytext);
{OP_MAY}		   printf("\nOperador Mayor: %s\n",yytext);
{OP_MAYIGU}        printf("\nOperador Mayor o igual: %s\n",yytext);
{OP_MEN}            printf("\nOperador Menor: %s\n",yytext);
{OP_MENIGU}        printf("\nOperador Menor o Igual: %s\n",yytext);
{OP_IGUAL}         printf("\nOperador Igual: %s\n",yytext);
{OP_DIF}            printf("\nOperador Distinto : %s\n",yytext);
{OP_DIV}            printf("\nOperador Divison: %s\n",yytext);
{OP_SUMA}           printf("\nOperador Suma: %s\n",yytext);
{OP_MULT}            printf("\nOperador Multiplicacion: %s\n",yytext); 
{OP_ASIG}            printf("\nOperador Asignacion: %s\n",yytext); 
{AND}              printf("\nAND: %s\n",yytext);
{OR}                printf("\nOR: %s\n",yytext);
{NOT}              printf("\nNOT: %s\n",yytext);

{DECVAR}         printf("\nDECVAR: %s\n",yytext);
{DIM}           printf("\nDIM: %s\n",yytext);
{GET}            printf("\nGET: %s\n",yytext);
{ENDDEC}         printf("\nnCENDDEC: %s\n",yytext);
{DISPLAY}          printf("\nDISPLAY: %s\n",yytext);
{WHILE}          printf("\nWHILE: %s\n",yytext);
{IF}            printf("\nIF: %s\n",yytext);
{INTEGER}        printf("\nINTEGER: %s\n",yytext);
{FLOAT}         printf("\nFLOAT: %s\n",yytext);
{ELSE}           printf("\nELSE: %s\n",yytext);
{OP_ASIG}	    printf("\nOperador Asignacion: %s\n",yytext);
{PAR_A}	        printf("\nParentesis Abre: %s\n",yytext);
{PAR_C}	         printf("\nParentesis Cerrado: %s\n",yytext);
{LLAV_A}         printf("\nLLave Abre: %s\n",yytext);
{LLAV_C}	        printf("\nLLave Cierra: %s\n",yytext);
{COR_A}           printf("\nCorchete Abre: %s\n",yytext);
{COR_C}            printf("\nCorechete Cierra: %s\n",yytext);

{CONST_ENT}     printf("\nConstante Entero: %s\n",yytext);
{CONST_STR}     printf("\nConstante String: %s\n",yytext);
{CONST_REAL}    printf("\nConstante Real: %s\n",yytext);  
"\n"
"\t"
"\n\t"
" "
.               yyerror();

%%


int main(int argc,char *argv[])
{
    
if ((yyin = fopen(argv[1], "rt")) == NULL)
    {
        printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
    }
else
    {
        yylex();
    }
    fclose(yyin);
    return 1;
}



int yyerror(void){
    printf("Error Lexico : Caracter invalido: %s\n",yytext);
    exit(1);

}