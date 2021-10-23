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

 void escribirTablaSimbolos();
 // void cargarVecTablaString(char * text);
 // void cargarVecTablaID(char * text);
 // void cargarVecTablaNumero(char * text);
 // void cargarVecTablaString(char * text);
 int abrirTablaDeSimbolos();

void escribirTercetosEnIntermedia();

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
  //  printf("HOLAAAAAAAAAAAAA");
    cantReg = 0;
  crearPila(&pTipoDato);
  crearPila(&pVariable);

    crearCola(&colaTercetos);

    abrirTablaDeSimbolos();//si abre mal no derbai abrir el resto
    abrirIntermedia();
    
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
    printf("\nTABLA DE SIMBOLOS:\n");
    escribirTablaSimbolos();
    escribirTercetosEnIntermedia();
    fclose(fpTabla);
    fclose(fpIntermedia);
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

int abrirTablaDeSimbolos()
{
    fpTabla = fopen(TABLA_SIMBOLOS_TXT,"wt");
    if(!fpTabla)
    {
        printf("Error de apertura del archivo de la tabla de simbolos");
        return 0;
    }
    return 1;
}

//podriaSer la misma funcion q harab los archivos
int abrirIntermedia(){
    fpIntermedia = fopen(INTERMEDIA_TXT,"wt");
    if(!fpIntermedia)
    {
        printf("Error de apertura del archivo de la tabla de simbolos");
        return 0;
    }
    return 1;
}

void escribirTercetosEnIntermedia()
{
    while(!colaVacia(&colaTercetos)){
      
        t_Terceto t;
        sacarDeCola(&colaTercetos,&t,100);
        printf("DATPS: %s ", t.posUno); 
        fprintf(fpIntermedia,"[%d] ( %s ; %s ; %s ) \n",t.numTerceto,t.posUno,t.posDos,t.posTres);
    }
}

void escribirTablaSimbolos()
{ 
    int i;
    fprintf(fpTabla, "%-30s\t\t\t%-30s\t\t\t%-30s\t\t\t%s\n", "NOMBRE", "TIPO", "VALOR", "LONGITUD");
    
    for(i = 0 ; i < (cantReg); i++)
    {
        fprintf(fpTabla,"%-30s\t\t\t%-30s\t\t\t%-30s\t\t\t%-d\n",tb[i].nombre ,tb[i].tipo ,tb[i].valor,tb[i].longitud);
    }
}

// void cargarVecTablaNumero(char * text)
// {
//    int duplicados = 0,j;
//     for ( j=0 ;j< cantReg; j++)
//     {
//         if(strcmp(text,(tb[j].nombre)+1)==0)
//             duplicados = 1;      
//     }

//     if(!duplicados){
//         int tamanio=strlen(text),i;
//         char aux[tamanio+2];
//         aux[0]='_';
//         for (i=1; i<= tamanio ; i++ )
//         {
//             aux[i]=*(text+i-1);

//         }
//         aux[i]='\0';
//         strcpy(tb[cantReg].nombre,aux);
//         strcpy(tb[cantReg].valor,text);
//         tb[cantReg].tipo[0] ='-';
//         tb[cantReg].tipo[1] ='\0'; 
//         tb[cantReg].longitud = 0;
//         //printf("\nNombre : %s   -   Valor : %s -   longitud :    %d\n",tb[cantReg].nombre , tb[cantReg].valor,tb[cantReg].longitud);

//         cantReg++;
//     }



// }

// void cargarVecTablaID(char * text)
// {
    
//     int duplicados = 0,j;
//     for ( j=0 ;j< cantReg; j++)
//     {
//         if(strcmp(text,(tb[j].nombre)+1)==0)
//             duplicados = 1;      
//     }
//     if(!duplicados)
//     {
//         int tamanio=strlen(text),i;
//         char aux[tamanio+2];
//         aux[0]='_';
//         for (i=1; i<= tamanio ; i++ )
//         {
//             aux[i]=*(text+i-1);
//         }
//         aux[tamanio+1]='\0';
//         strcpy(tb[cantReg].nombre,aux);
//         strcpy(tb[cantReg].valor,"-\0");
//         tb[cantReg].tipo[0] ='-';
//         tb[cantReg].tipo[1] ='\0'; 
//         tb[cantReg].longitud = 0;
//         //printf("\nNombre : %s   -   Valor : %s -   longitud :    %d\n",tb[cantReg].nombre,tb[cantReg].valor,tb[cantReg].longitud);
//         cantReg++;
//     }
  
// }


// void cargarVecTablaString(char * text)
// {  

//         int duplicados = 0,j;
//         int i=0 ;
//         char aux [strlen(text)+1];
//         strcpy(aux,text);
//         aux[0] = '_';
//         for (i=0; i<= strlen(text) ; i++ )
//         {
//             if(aux[i] == ' ')
//                 aux[i]= '_';
//         }
//         aux[i-2]='\0';
//         for ( j=0 ;j < cantReg; j++)
//         {
//             if(strcmp(aux,tb[j].nombre)==0)
//             duplicados = 1;      
//         }
//         if(!duplicados){
//             strcpy(tb[cantReg].nombre,aux);
//             strcpy(tb[cantReg].valor,text);
//             tb[cantReg].tipo[0] ='-';
//             tb[cantReg].tipo[1] ='\0';
//             tb[cantReg].longitud = strlen(text)-2;
//             cantReg++;
//         //printf("\nNombre : %s   -   Valor : %s -   longitud :    %d\n",tb[cantReg-1].nombre , tb[cantReg-1].valor,tb[cantReg-1].longitud);
//         }

    
// }