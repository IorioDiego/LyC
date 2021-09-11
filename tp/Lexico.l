%{ 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define STR_LIMITE 100
#define ID_LIMITE 30
#define ENT_LIMITE 5


#define COTA_INFERIOR_ENT -32768
#define COTA_SUPERIOR_ENT 32767

#define COTA_SUPERIOR_REAL 3.4028235E+38
#define COTA_INFERIOR_REAL -3.4028235E+38



typedef struct
{
    char nombre[200];
    char tipo[30];
    char valor[200];
    int longitud;   

}tablaSimbolos;

tablaSimbolos tb[2000];
int cantReg=0;
FILE  *yyin;
FILE * fpTabla;
int yylval;
int yylex();
int yyparse();
char* yyerror();


char* validarRangoString( char *text );
char* validarRangoEntero( char *text );
char* validarRangoID( char *text );
char* validarRangoReal( char *text );
void escribirTablaSimbolos();
void cargarVecTablaString(char * text);
void cargarVecTablaID(char * text);
void cargarVecTablaNumero(char * text);
void cargarVecTablaString(char * text);
int abrirTablaDeSimbolos();


%}


%option noyywrap
%option yylineno




DIGITO		            ([0-9])
LETRA			        [a-zA-Z]

ID		            	{LETRA}({LETRA}|{DIGITO})*

               

COMA                    [,]
PUNTOYCOMA              [;]


PAR_A	                [(]
PAR_C	                [)]
LLAV_A	                [{]
LLAV_C              	[}]
COR_A                   [[]
COR_C                   []]


DIM                     "DIM"
DISPLAY                 "DISPLAY"
GET                     "GET"
IF			            "IF"
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
DO                      "DO"
ENDWHILE                "ENDWHILE"
  
CONST_REAL              {DIGITO}+"."{DIGITO}+|"."{DIGITO}|{DIGITO}+"."
CONST_STR               \".*\" 
CONST_ENT	            "-"?{DIGITO}+
COMENTARIO              \/\*.*\*\/

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

{DECVAR}         printf("\nDECVAR: %s\n",yytext);
{DIM}           printf("\nDIM: %s\n",yytext);
{GET}            printf("\nGET: %s\n",yytext);
{ENDDEC}         printf("\nENDDEC: %s\n",yytext);
{DISPLAY}          printf("\nDISPLAY: %s\n",yytext);
{WHILE}          printf("\nWHILE: %s\n",yytext);
{IF}            printf("\nIF: %s\n",yytext);
{INTEGER}        printf("\nINTEGER: %s\n",yytext);
{FLOAT}         printf("\nFLOAT: %s\n",yytext);
{ELSE}           printf("\nELSE: %s\n",yytext);
{AS}            printf("\nAS: %s\n",yytext);
{DO}             printf("\nDO: %s\n",yytext);
{ENDWHILE}       printf("\nENDWHILE: %s\n",yytext);

{AND}              printf("\nAND: %s\n",yytext);
{OR}                printf("\nOR: %s\n",yytext);
{NOT}              printf("\nNOT: %s\n",yytext);


{CONST_ENT}     printf("\nConstante Entero: %s\n",validarRangoEntero(yytext));
{CONST_STR}     printf("\nConstante String: %s\n",validarRangoString(yytext));
{CONST_REAL}    printf("\nConstante Real: %s\n",validarRangoReal(yytext)); 

{ID}                 printf("\nID Variable: %s\n",validarRangoID(yytext));
{COMA}             printf("\nComa: %s\n",yytext);
{PUNTOYCOMA}     printf("\nPunto y Coma: %s\n",yytext);
{COMENTARIO}    printf("\nComentario: %s\n",yytext);  


 

{PAR_A}	        printf("\nParentesis Abre: %s\n",yytext);
{PAR_C}	         printf("\nParentesis Cerrado: %s\n",yytext);
{LLAV_A}         printf("\nLLave Abre: %s\n",yytext);
{LLAV_C}	        printf("\nLLave Cierra: %s\n",yytext);
{COR_A}           printf("\nCorchete Abre: %s\n",yytext);
{COR_C}            printf("\nCorechete Cierra: %s\n",yytext);

{OP_ASIG}	    printf("\nOperador Asignacion: %s\n",yytext);
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
{OP_RESTA}           printf("\nOperador Resta: %s\n",yytext);   

"\n"
"\t"
"\n\t"
"\r\n"
" "
.               yyerror();

%%


int main(int argc,char *argv[])
{
    
    abrirTablaDeSimbolos();
    
if ((yyin = fopen(argv[1], "rt")) == NULL)
    {
        printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
    }
else
    {
        yylex();
    }
    escribirTablaSimbolos();
    fclose(fpTabla);
    fclose(yyin);
    return 1;
}



char* yyerror(void){
    return (char*)printf("Error Lexico en linea %d",yylineno) ;
}

char* validarRangoString( char *text ){
    if(strlen(text)>STR_LIMITE)
        {
            printf("Eror String: %s - ",text);
            return yyerror();
        }
        else{
            cargarVecTablaString(text);
          return text;
        }
}


char* validarRangoID( char *text ){
    if(strlen(text)>ID_LIMITE)
        {
            printf("Eror ID: %s - ",text);
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
           printf("Eror constante entera fuera del limite: %s - ",text);
            return yyerror();
        }


    }else
    {
        if( strlen( text ) > ENT_LIMITE || atoi(text)> COTA_SUPERIOR_ENT )
        {
             printf("Eror constante entera fuera del limite: %s - ",text);
            return yyerror();
        }
   
    }
 return text;
}


char* validarRangoReal( char *text ){
    if(atof(text) > COTA_SUPERIOR_REAL|| atof(text) <  COTA_INFERIOR_REAL) 
        {
            printf("Eror Real: %s - ",text);
            return yyerror();
        }
        else{
          return text;
        }
   
}

int abrirTablaDeSimbolos()
{
    fpTabla = fopen("tablaDeSimbolos.txt","wt");
    if(!fpTabla)
    {
        printf("Error de apertura del archivo de la tabla de simbolos");
        return 0;
    }
    return 1;
}

void escribirTablaSimbolos()
{ 
    int i;
    for(i = 0 ; i < cantReg; i++)
    {
        fwrite(&tb[i],sizeof(tablaSimbolos),1,fpTabla); 

    }
   
}

void cargarVecTablaNumero(char * text)
{
    
}

void cargarVecTablaID(char * text)
{
    
}


void cargarVecTablaString(char * text)
{   
    int i=0 ;
    char aux [strlen(text)+1];
    
    strcpy(aux,text);
    aux[0] = '_';
    for (i=0; i<= strlen(text) ; i++ )
    {
        if(aux[i] == ' ')
            aux[i]= '_';
    }
    printf("I : %c\n",aux[i-2]);
    aux[i-2]='\0';
    
    strcpy(tb[cantReg].nombre,aux);
    strcpy(tb[cantReg].valor,text);
    tb[cantReg].longitud = strlen(text)-2;

    printf("\nNombre : %s   -   Valor : %s -   longitud :    %d\n",tb[cantReg].nombre , tb[cantReg].valor,tb[cantReg].longitud  );

    cantReg++;
    
}