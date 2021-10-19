%{
#include "utilis/funciones.h"
#include "y.tab.h"




int yystopparser=0;
FILE  *yyin;
int yyparse();
int yylex();
int yyparse();
int yyerror();
char * yytext;
extern int cantReg;

void escribirTablaSimbolos();
void cargarVecTablaString(char * text);
void cargarVecTablaID(char * text);
void cargarVecTablaNumero(char * text);
void cargarVecTablaString(char * text);
int abrirTablaDeSimbolos();



%}

%start programa 
%right OP_ASIG 
%left OP_SUMA OP_RESTA
%left OP_MULT OP_DIV
%right MENOS_UNARIO

%token OP_MAY OP_MAYIGU OP_MEN OP_MENIGU OP_IGUAL OP_DIF
%token WHILE IF INTEGER FLOAT STRING ELSE THEN DECVAR ENDDECVAR AS IN AND OR NOT LONG
%token  DISPLAY DIM COMA ENDIF ENDWHILE DO GET PAR_A PAR_C COR_A COR_C

%token ID CONST_ENT CONST_REAL CONST_STR

%union {
char *str_val;
}


%%

programa:
    sentencia                       {printf("\nREGLA 1: <programa> --> <sentencia>\n");}       
    | programa sentencia            {printf("\nREGLA 2: <programa> --> <programa> <sentencia>\n");};              
    
sentencia:
     declaracion                     {printf("\nREGLA 3: <sentencia> --> <declaracion>\n");}  
    |asignacion                      {printf("\nREGLA 4: <sentencia> --> <asignacion>\n");}   
    |ciclo                           {printf("\nREGLA 5: <sentencia> --> <cilco>\n");}   
    |seleccion                       {printf("\nREGLA 6: <sentencia> --> <seleccion>\n");}   
    |salida                          {printf("\nREGLA 7: <sentencia> --> <salida>\n");}   
    |entrada                         {printf("\nREGLA 8: <sentencia> --> <entrada>\n");} 
    |longitud                        {printf("\nREGLA 9: <sentencia> --> <longitud>\n");}; 


declaracion:
    DECVAR {cantReg=0;} dec ENDDECVAR    {printf("\nREGLA 10: <declaracion> --> DECVAR DIM <dec> ENDDECVAR\n");};    

  
listavar:
    ID                              {cargarVecTablaID(yytext);printf("\nCANTIDDD DE REGISTROS >>>>>>>>>>>> %d\n", cantReg);printf("\nREGLA 11: <listavar> --> ID \n");}
    | listavar COMA ID             {cargarVecTablaID(yytext);printf("\nREGLA 12: <listavar> --> <listavar> COMA ID\n");};

listatipodato:
    tipodato                        {printf("\nREGLA 13: <listatipodato> --> <tipodato> \n");}
    | listatipodato COMA tipodato  {printf("\nREGLA 14: <listatipodato> --> <listatipodato> COMA <tipodato>\n");};

tipodato:
    INTEGER                         {printf("\nREGLA 15: <tipodato> --> INTEGER  \n");}
    | FLOAT                         {printf("\nREGLA 16: <tipodato> --> FLOAT \n");}
    | STRING                        {printf("\nREGLA 17: <tipodato> --> STRING \n");};

seleccion:
    IF condicion THEN programa ELSE programa ENDIF      {printf("\nREGLA 18: <seleccion> --> IF <condicion> THEN <programa> ELSE <programa> ENDIF\n");}
    | IF condicion THEN programa ENDIF                  {printf("\nREGLA 19: <seleccion> --> IF <condicion> THEN <programa> ENDIF \n");};

ciclo:
    WHILE ID IN COR_A lista COR_C DO programa ENDWHILE         {printf("\nREGLA 20: <ciclo> --> WHILE ID IN COR_A <lista> COR_C DO <sentencia> ENDWHILE\n");};

entrada:
    GET ID                                          {printf("\nREGLA 21: <entrada> --> GET <factor>\n");};

salida:
    DISPLAY CONST_STR                                   {cargarVecTablaString(yylval.str_val);printf("\nREGLA 22: <salida> -->  DISPLAY CONST_STR  \n");};

asignacion:
    ID OP_ASIG expresion                                {printf("\nREGLA 23: <asignacion> --> ID OP_ASIG <expresion> \n");};

condicion:
    comparacion
    | condicion AND comparacion                         {printf("\nREGLA 24: <condicion> --> <comparacion> \n");}
    | condicion OR comparacion                          {printf("\nREGLA 25: <condicion> --> <comparacion> AND <comparacion>\n");}
    | PAR_A NOT condicion PAR_C AND comparacion         {printf("\nREGLA 26: <condicion> --> PAR_A NOT <condicion> PAR_C <comparacion> \n");}
    | PAR_A  NOT condicion PAR_C OR comparacion         {printf("\nREGLA 27: <condicion> --> PAR_A NOT <condicion> PAR_C <comparacion> \n");};

comparacion:
    expresion comparador expresion                     {printf("\nREGLA 28: <comparacion> --> <expresion><comparador><expresion> \n");};

expresion:
    expresion OP_SUMA termino                           {printf("\nREGLA 29: <expresion> --> <expresion>OP_SUMA<termino> \n");}
    | expresion OP_RESTA termino                        {printf("\nREGLA 30: <expresion> --> <expresion>OP_RESTA<termino> \n");}
    | termino                                           {printf("\nREGLA 31: <expresion> --> <termino> \n");}
    |OP_RESTA expresion %prec MENOS_UNARIO               {printf("\nREGLA 32: <expresion> --> OP_RESTA <expresion> \n");}                               
    |longitud                                            {printf("\nREGLA 33: <expresion> --> <longitud> \n");};      
    
termino:
    termino OP_MULT factor                              {printf("\nREGLA 35: <termino> --> <termino>OP_MULT<factor> \n");}
    | termino OP_DIV factor                             {printf("\nREGLA 36: <termino> --> <termino>OP_DIV<factor> \n");}
    | factor                                            {printf("\nREGLA 37: <termino> --> <factor> \n");};

longitud:
    LONG PAR_A lista PAR_C                    {printf("\nREGLA 38: <longitud> --> <ID>OP_ASIF<LONG>PAR_A<lista>PAR_C\n");};

lista:
    factor                                              {printf("\nREGLA 39: <lista> --> <factor> \n");}
    | lista COMA factor                                 {printf("\nREGLA 40: <lista> --> <lista>COMA<factor> \n");};

factor:
    PAR_A expresion PAR_C       {printf("\nREGLA 41: <factor> --> PAR_A <expresion> PAR_C\n");} 
    | CONST_REAL                {printf("\nREGLA 42: <factor> --> CONST_REAL\n");} 
    | ID                        {printf("\nREGLA 43: <factor> --> ID\n");} 
    | CONST_ENT                 {printf("\nREGLA 44: <factor> --> CONST_ENT\n");};

comparador:
    OP_MAY          {printf("\nREGLA 45: <comparador> --> OP_MAY\n");} 
    | OP_MEN        {printf("\nREGLA 46: <comparador> --> OP_MEN\n");} 
    | OP_MENIGU     {printf("\nREGLA 47: <comparador> --> OP_MENIGU\n");} 
    | OP_MAYIGU     {printf("\nREGLA 48: <comparador> --> OP_MAYIGU\n");} 
    | OP_IGUAL      {printf("\nREGLA 49: <comparador> --> OP_IGUAL\n");} 
    | OP_DIF        {printf("\nREGLA 10: <comparador> --> OP_DIF\n");};

dec:
    dec DIM COR_A listavar COR_C AS COR_A listatipodato COR_C   {printf("\nREGLA 49: <dec> --> <dec> COR_A listavar COR_C AS COR_A listatipodato COR_C\n");} 
    | DIM COR_A listavar COR_C AS COR_A listatipodato COR_C      {printf("\nREGLA 50: <dec> --> <dec> COR_A listavar COR_C AS COR_A listatipodato COR_C\n");};

%%





void cargarVecTablaNumero(char * text)
{
   int duplicados = 0,j;
    for ( j=0 ;j< cantReg; j++)
    {
        if(strcmp(text,(tb[j].nombre)+1)==0)
            duplicados = 1;      
    }

    if(!duplicados){
        int tamanio=strlen(text),i;
        char aux[tamanio+2];
        aux[0]='_';
        for (i=1; i<= tamanio ; i++ )
        {
            aux[i]=*(text+i-1);

        }
        aux[i]='\0';
        strcpy(tb[cantReg].nombre,aux);
        strcpy(tb[cantReg].valor,text);
        tb[cantReg].tipo[0] ='-';
        tb[cantReg].tipo[1] ='\0'; 
        tb[cantReg].longitud = 0;
        //printf("\nNombre : %s   -   Valor : %s -   longitud :    %d\n",tb[cantReg].nombre , tb[cantReg].valor,tb[cantReg].longitud);

        cantReg++;
    }



}

void cargarVecTablaID(char * text)
{
    
    int duplicados = 0,j;
    for ( j=0 ;j< cantReg; j++)
    {
        if(strcmp(text,(tb[j].nombre)+1)==0)
            duplicados = 1;      
    }
    if(!duplicados)
    {
        int tamanio=strlen(text),i;
        char aux[tamanio+2];
        aux[0]='_';
        for (i=1; i<= tamanio ; i++ )
        {
            aux[i]=*(text+i-1);
        }
        aux[tamanio+1]='\0';
        strcpy(tb[cantReg].nombre,aux);
        strcpy(tb[cantReg].valor,"-\0");
        tb[cantReg].tipo[0] ='-';
        tb[cantReg].tipo[1] ='\0'; 
        tb[cantReg].longitud = 0;
        //printf("\nNombre : %s   -   Valor : %s -   longitud :    %d\n",tb[cantReg].nombre,tb[cantReg].valor,tb[cantReg].longitud);
        cantReg++;
    }
  
}


void cargarVecTablaString(char * text)
{  

        int duplicados = 0,j;
        int i=0 ;
        char aux [strlen(text)+1];
        strcpy(aux,text);
        aux[0] = '_';
        for (i=0; i<= strlen(text) ; i++ )
        {
            if(aux[i] == ' ')
                aux[i]= '_';
        }
        aux[i-2]='\0';
        for ( j=0 ;j < cantReg; j++)
        {
            if(strcmp(aux,tb[j].nombre)==0)
            duplicados = 1;      
        }
        if(!duplicados){
            strcpy(tb[cantReg].nombre,aux);
            strcpy(tb[cantReg].valor,text);
            tb[cantReg].tipo[0] ='-';
            tb[cantReg].tipo[1] ='\0';
            tb[cantReg].longitud = strlen(text)-2;
            cantReg++;
        //printf("\nNombre : %s   -   Valor : %s -   longitud :    %d\n",tb[cantReg-1].nombre , tb[cantReg-1].valor,tb[cantReg-1].longitud);
        }

    
}

