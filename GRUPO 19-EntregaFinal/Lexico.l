%{ 


#include "y.tab.h"
#include "utilis/funciones.h"




#define COTA_INFERIOR_ENT -32768
#define COTA_SUPERIOR_ENT 32767

#define COTA_SUPERIOR_REAL 3.4028235E+38
#define COTA_INFERIOR_REAL -3.4028235E+38

//typedef struct
// {
//     char nombre[200];
//     char tipo[30];
//     char valor[200];
//     int longitud;   

// }tablaSimbolos;

// tablaSimbolos tb[2000];

FILE  *yyin;
//FILE * fpTabla;
char *yytext;
int yylex();
int yyparse();
char * yyerror();


char* validarRangoString( char *text );
char* validarRangoEntero( char *text );
char* validarRangoID( char *text );
char* validarRangoReal( char *text );

 // void cargarVecTablaString(char * text);
 // void cargarVecTablaID(char * text);
 // void cargarVecTablaNumero(char * text);
 // void cargarVecTablaString(char * text);
 


%}


%option noyywrap
%option yylineno



ESPACIO                 [" "]
DIGITO		            ([0-9])
LETRA			        [a-zA-Z]
CARACTERES              @|\?|\"|\.|\,|\+|\t|\n|\/|\_|\:|\;|¿|\*|{LETRA}|{DIGITO}|{ESPACIO}|\=|\*|\>\<|\-  
                      
LONG                    "LONG"



COMA                    [,]



PAR_A	                [(]
PAR_C	                [)]

COR_A                   [[]
COR_C                   []]


DIM                     "DIM"
DISPLAY                 "DISPLAY"
GET                     "GET"
IF			            "IF"
ENDIF                   "ENDIF"
WHILE	            	"WHILE"
DECVAR		            "DECVAR"
ENDDECVAR	            "ENDDECVAR"
INTEGER	            	"INTEGER"
STRING                  "STRING"
FLOAT		            "FLOAT"
ELSE		            "ELSE"
AND                     "AND"
OR                      "OR"
NOT                     "NOT"
AS                      "AS"
DO                      "DO"
ENDWHILE                "ENDWHILE"
IN                      "IN"
THEN                    "THEN"



CONST_REAL              {DIGITO}+"."{DIGITO}+|"."{DIGITO}|{DIGITO}+"."
CONST_STR               \".*\" 
CONST_ENT	            "-"?{DIGITO}+

COMENTARIO              \/\*.*\*\/
ID		            	{LETRA}({LETRA}|{DIGITO})*

OP_MAY		            [>]
OP_MAYIGU	            ">="
OP_MEN		            [<]
OP_MENIGU	            "<="
OP_IGUAL	            "=="
OP_DIF		            "!="
OP_DIV                  [/]
OP_SUMA                 [+]
OP_MULT		            [*]
OP_ASIG		            ":="
OP_RESTA                [-]

%%

{LONG}           {printf("\nLONG: %s\n",yytext); return LONG;}
{DECVAR}         {printf("\nDECVAR: %s\n",yytext);return DECVAR;}
{DIM}          {printf("\nDIM: %s\n",yytext);return DIM;}
{GET}           {printf("\nGET: %s\n",yytext);return GET;}
{ENDDECVAR}         {printf("\nENDDECVAR: %s\n",yytext);return ENDDECVAR;}
{DISPLAY}          {printf("\nDISPLAY: %s\n",yytext);return DISPLAY;}
{WHILE}          {printf("\nWHILE: %s\n",yytext);return WHILE;}
{IF}            {printf("\nIF: %s\n",yytext);return IF;}
{INTEGER}        {printf("\nINTEGER: %s\n",yytext);return INTEGER;}
{FLOAT}         {printf("\nFLOAT: %s\n",yytext);return FLOAT;}
{ELSE}           {printf("\nELSE: %s\n",yytext);return ELSE;}
{AS}            {printf("\nAS: %s\n",yytext);return AS;}
{DO}             {printf("\nDO: %s\n",yytext);return DO;}
{ENDWHILE}       {printf("\nENDWHILE: %s\n",yytext);return ENDWHILE;}
{IN}             {printf("\nIN: %s\n",yytext);return IN;}
{STRING}         {printf("\nSTRING: %s\n",yytext);return STRING;}   
{THEN}           {printf("\nTHEN: %s\n",yytext);return THEN;} 
{ENDIF}         {printf("\nENDIF: %s\n",yytext);return ENDIF;} 

{AND}              {printf("\nAND: %s\n",yytext);return AND;}
{OR}                {printf("\nOR: %s\n",yytext);return OR;}
{NOT}              {printf("\nNOT: %s\n",yytext);return NOT;}



{CONST_ENT}     {printf("\nConstante Entero: %s\n",validarRangoEntero(yytext));return CONST_ENT;}
{CONST_STR}     {printf("\nConstante String: %s\n",validarRangoString(yytext));return CONST_STR;}
{CONST_REAL}    {printf("\nConstante Real: %s\n",validarRangoReal(yytext));return CONST_REAL;} 

{ID}                 {printf("\nID Variable: %s\n",validarRangoID(yytext));return ID;}
{COMA}             {printf("\nComa: %s\n",yytext);return COMA;}

{COMENTARIO}   


 

{PAR_A}	        {printf("\nParentesis Abre: %s\n",yytext);return PAR_A;}
{PAR_C}	         {printf("\nParentesis Cerrado: %s\n",yytext);return PAR_C;}

{COR_A}           {printf("\nCorchete Abre: %s\n",yytext);return COR_A;}
{COR_C}            {printf("\nCorechete Cierra: %s\n",yytext);return COR_C;}

{OP_ASIG}	   {printf("\nOperador Asignacion: %s\n",yytext);return OP_ASIG;}
{OP_MAY}		   {printf("\nOperador Mayor: %s\n",yytext);return OP_MAY;}
{OP_MAYIGU}        {printf("\nOperador Mayor o igual: %s\n",yytext);return OP_MAYIGU;}
{OP_MEN}            {printf("\nOperador Menor: %s\n",yytext);return OP_MEN;}
{OP_MENIGU}        {printf("\nOperador Menor o Igual: %s\n",yytext);return OP_MENIGU;}
{OP_IGUAL}         {printf("\nOperador Igual: %s\n",yytext);return OP_IGUAL;}
{OP_DIF}            {printf("\nOperador Distinto : %s\n",yytext);return OP_DIF;}
{OP_DIV}            {printf("\nOperador Divison: %s\n",yytext);return OP_DIV;}
{OP_SUMA}           {printf("\nOperador Suma: %s\n",yytext);return OP_SUMA;}
{OP_MULT}            {printf("\nOperador Multiplicacion: %s\n",yytext);return OP_MULT;} 
{OP_ASIG}            {printf("\nOperador Asignacion: %s\n",yytext);return OP_ASIG;} 
{OP_RESTA}           {printf("\nOperador Resta: %s\n",yytext);return OP_RESTA;}


"\n"  
"\t"
"\r" 
"\n\t" 
"\r\n"               
" "                 
.                yyerror(yytext);

%%


int main(int argc,char *argv[])
{

    cantReg = 0;
    crearPila(&pTipoDato);
    crearPila(&pVariable);

    crearPila(&pilaNroTerceto);
    crearPila(&pilaLista);
    crearCola(&colaTercetos);


    crearPila(&pilaExp);
    crearPila(&pilaFact);
    crearPila(&pilaTerm);
    crearPila(&pilaComparacion);



if ((yyin = fopen(argv[1], "rt")) == NULL)
    {
        printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
        fclose(fpTabla);
        fclose(fpIntermedia);
    }
else
    {
        yyparse();
    }
  
    escribirTablaSimbolos();
    escribirTercetosEnIntermedia();

    fclose(yyin);
    return 1;
}



 char* yyerror(void){
     return (char*)printf("Error Lexico en linea %d\n",yylineno) ;
 }

char* validarRangoString( char *text ){
    if( (strlen(text) - 2) >STR_LIMITE)
    {
            printf("Error String , cadena fuera del limite: %s - ",text);
            return yyerror();
    }
else{
        
          return text;
}
}


char* validarRangoID( char *text ){
    if(strlen(text)>ID_LIMITE)
{
        printf("Error ID: %s - ",text);
        return yyerror();
}
else{

  
          return text;
    } 
}


char* validarRangoEntero( char *text ){
printf("Valor del entero : %s\n",text+1 );
    if(*text == '-') 
    {
        if( strlen( text+1 ) > ENT_LIMITE || atoi(text) < COTA_INFERIOR_ENT )
        {
           printf("Error constante entera fuera del limite: %s - ",text);
            return yyerror();
        }


    }else
    {
        if( strlen( text ) > ENT_LIMITE || atoi(text)> COTA_SUPERIOR_ENT )
        {
             printf("Error constante entera fuera del limite: %s - ",text);
            return yyerror();
        }
   
    }

 return text;
}


char* validarRangoReal( char *text ){
    if(atof(text) > COTA_SUPERIOR_REAL|| atof(text) <  COTA_INFERIOR_REAL) 
        {
            printf("Error Real fuera de limite : %s - ",text);
            return yyerror();
        }
        else{

          return text;
        }
   
}





