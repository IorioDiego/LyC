%{
#include "utilis/funciones.h"
#include "y.tab.h"

#define LONG_TIPO_FLOAT 10
#define LONG_TIPO_INTEGER 10
#define LONG_TIPO_STR 10

#define LONG_TERCETO 30 
#define LONG_ID 30




int yystopparser=0;
FILE  *yyin;
int yyparse();
int yylex();
int yyparse();
int yyerror();
char * yytext;


/////////TERCETIS//////////
///indices
int     sentInd=0,
        prgInd=0,
        declaracionInd=0,
        asignacionInd=0,
        selecInd=0,
        cicloInd=0,
        longInd=0,
        salidaInd=0,
        entradaInd=0,
        expInd=0,
        factInd=0,
        termInd=0,
        listTipoDatoInd=0,
        decInd=0,
        listavarInd=0,
        condicionInd=0,
        comparacionInd=0,
        comparadorInd=0,
        listaInd=0,
        tipoDatoInd=0;
        

int contList;
int tercetosCreados=1;
char comparador[4];

int crearTerceto(char* c1,char *c2,char *c3 ,int nroT);
int desapilarNroTerceto();
void escribirTercetoActualEnAnterior(int tercetoAEscribir,int tercetoBuscado);
int desapilarNroTerceto();
int apilarNroTerceto(int nroTerceto);

void escribirTablaSimbolos();//Sacar
void cargarVecTablaString(char * text);
void cargarVecTablaID();
void cargarVecTablaNumero(char * text);
void cargarVecTablaString(char * text);
int abrirTablaDeSimbolos();//Sacar



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
    | programa sentencia            {sentInd=prgInd;printf("\nREGLA 2: <programa> --> <programa> <sentencia>\n");};              
    
sentencia:
     declaracion                     {printf("\nREGLA 3: <sentencia> --> <declaracion>\n");}  
    |asignacion                      {printf("\nREGLA 4: <sentencia> --> <asignacion>\n");}   
    |ciclo                           {printf("\nREGLA 5: <sentencia> --> <cilco>\n");}   
    |seleccion                       {printf("\nREGLA 6: <sentencia> --> <seleccion>\n");}   
    |salida                          {printf("\nREGLA 7: <sentencia> --> <salida>\n");}   
    |entrada                         {printf("\nREGLA 8: <sentencia> --> <entrada>\n");} 
    |longitud                        {printf("\nREGLA 9: <sentencia> --> <longitud>\n");}; 


declaracion:
    DECVAR  dec ENDDECVAR            {cargarVecTablaID();printf("\nREGLA 10: <declaracion> --> DECVAR DIM <dec> ENDDECVAR\n");};    

  
listavar:
    ID                             {crearTerceto(yytext,"_","_",tercetosCreados);ponerEnPila(&pVariable,yytext,LONG_ID);printf("\nCANTIDDD DE REGISTROS >>>>>>>>>>>> %d\n", cantReg);printf("\nREGLA 11: <listavar> --> ID \n");}
    | listavar COMA ID             {crearTerceto(yytext,"_","_",tercetosCreados);ponerEnPila(&pVariable,yytext,LONG_ID);printf("\nCANTIDDD DE REGISTROS >>>>>>>>>>>> %d\n", cantReg);printf("\nREGLA 12: <listavar> --> <listavar> COMA ID\n");};

listatipodato:
    tipodato                        {printf("\nREGLA 13: <listatipodato> --> <tipodato> \n");}
    | listatipodato COMA tipodato  {printf("\nREGLA 14: <listatipodato> --> <listatipodato> COMA <tipodato>\n");};

tipodato:
    INTEGER                         {ponerEnPila(&pTipoDato,yytext,LONG_TIPO_INTEGER);printf("\nREGLA 15: <tipodato> --> INTEGER  \n");}
    | FLOAT                         {ponerEnPila(&pTipoDato,yytext,LONG_TIPO_FLOAT);printf("\nREGLA 16: <tipodato> --> FLOAT \n");}
    | STRING                        {ponerEnPila(&pTipoDato,yytext,LONG_TIPO_STR);printf("\nREGLA 17: <tipodato> --> STRING \n");};

seleccion:
    IF condicion  THEN  programa ELSE programa ENDIF      {
                                                            int t = desapilarNroTerceto();
                                                            escribirTercetoActualEnAnterior(tercetosCreados,t);
                                                        printf("\nREGLA 18: <seleccion> --> IF <condicion> THEN <programa> ELSE <programa> ENDIF\n");  
                                                        }
    | IF                               
    condicion  THEN programa ENDIF    {
                              
                                    int t = desapilarNroTerceto();
                                    escribirTercetoActualEnAnterior(tercetosCreados,t);
                             
                                    printf("\nREGLA 19: <seleccion> --> IF <condicion> THEN <programa> ENDIF \n");
                                    };

ciclo:
    WHILE ID            {
                            crearTerceto(yytext,"_","_",tercetosCreados);
                        }
                 

    IN COR_A lista      {   int t;
                            cicloInd = crearTerceto("ETW","_","_",tercetosCreados);
                            apilarNroTerceto(cicloInd);
                            crearTerceto("CMP", "@pilaEstaVacia","@topePilaLista",tercetosCreados );
                            apilarNroTerceto(crearTerceto("BNQ","_" ,"_",tercetosCreados));
                             crearTerceto("OP_ASIG","@aux","@topePilaLista",tercetosCreados);
                        }   
                           
    COR_C DO programa   {
 
                            int t = desapilarNroTerceto();
                            char auxT [LONG_TERCETO]; 
                            escribirTercetoActualEnAnterior(tercetosCreados+1,t);
                            t = desapilarNroTerceto(); 
                            sprintf(auxT,"[%d]",t);
                            crearTerceto("BI","_",auxT,tercetosCreados);

                        }
                      

    ENDWHILE         {printf("\nREGLA 20: <ciclo> --> WHILE ID IN COR_A <lista> COR_C DO <sentencia> ENDWHILE\n");};

entrada:
    GET ID                                          {printf("\nREGLA 21: <entrada> --> GET <factor>\n");};

salida:
    DISPLAY CONST_STR                                   {cargarVecTablaString(yytext);printf("\nREGLA 22: <salida> -->  DISPLAY CONST_STR  \n");};

asignacion:
    ID {asignacionInd = crearTerceto(yytext,"_","_",tercetosCreados);} 
    OP_ASIG expresion 
                                                        {
                                                           
                                                            char auxAsig[LONG_TERCETO];
                                                           char auxInd[LONG_TERCETO];
                                                           sprintf(auxInd,"[%d]",expInd );
                                                            sprintf(auxAsig,"[%d]",asignacionInd);
                                                      
                                                            asignacionInd = crearTerceto("OP_ASIG",auxAsig,auxInd,tercetosCreados); printf("\nREGLA 23: <asignacion> --> ID OP_ASIG <expresion> \n");
                                                        };

condicion:
    comparacion                                         {
                                                        condicionInd = comparacionInd;
                                                        printf("\nREGLA 24: <condicion> --> <comparacion> \n");
                                                        }
                                                         
    | condicion AND comparacion                         {
                                                            char condicionAux [LONG_TERCETO];
                                                            char comparacionAux [LONG_TERCETO];

                                                            sprintf(condicionAux,"[%d]",condicionInd );
                                                            sprintf(comparacionAux, "[%d]", comparacionInd);

                                                        condicionInd = crearTerceto("AND", condicionAux , comparacionAux,tercetosCreados );
                                                        printf("\nREGLA 25: <condicion> --> <condicion> AND <comparacion>\n");
                                                        }
    | condicion OR comparacion                          {
                                                            char condicionAux [LONG_TERCETO];
                                                            char comparacionAux [LONG_TERCETO];
                                                            sprintf(condicionAux,"[%d]",condicionInd);
                                                            sprintf(comparacionAux, "[%d]", comparacionInd);
                                                            condicionInd = crearTerceto("OR", condicionAux , comparacionAux,tercetosCreados );
                                                            printf("\nREGLA 26: <condicion> --> <condicion> OR <comparacion>\n");
                                                        }
    
    | PAR_A NOT condicion PAR_C AND comparacion         {   char condicionAux [LONG_TERCETO];
                                                            char comparacionAux [LONG_TERCETO];

                                                            sprintf(condicionAux,"[%d]",condicionInd );
                                                            sprintf(comparacionAux, "[%d]", comparacionInd);
                                                            condicionInd = crearTerceto("AND", condicionAux , comparacionAux,tercetosCreados );
                                                            sprintf(condicionAux,"[%d]",condicionInd );
                                                            condicionInd = crearTerceto("NOT", condicionAux , "_",tercetosCreados );

                                                            printf("\nREGLA 27: <condicion> --> PAR_A NOT <condicion> PAR_C <comparacion> \n");
                                                        }
    | PAR_A  NOT condicion PAR_C OR comparacion         {   
                                                            char condicionAux [LONG_TERCETO];
                                                            char comparacionAux [LONG_TERCETO];

                                                            sprintf(condicionAux,"[%d]",condicionInd );
                                                            sprintf(comparacionAux, "[%d]", comparacionInd);
                                                            condicionInd = crearTerceto("OR", condicionAux , comparacionAux,tercetosCreados );
                                                            sprintf(condicionAux,"[%d]",condicionInd );
                                                            condicionInd = crearTerceto("NOT", condicionAux , "_",tercetosCreados );        
                                                            printf("\nREGLA 28: <condicion> --> PAR_A NOT <condicion> PAR_C <comparacion> \n");
                                                            };

comparacion:
    expresion comparador expresion                     {    int exp1;
                                                            int exp2;
                                                            
                                                            char auxExp1[LONG_TERCETO]  ;
                                                            char auxExp2[LONG_TERCETO] ;
                                                            sacarDePila(&pilaExp,&exp1,sizeof(int));
                                                            sacarDePila(&pilaExp,&exp2,sizeof(int));
                                                            sprintf(auxExp1,"[%d]",exp1 );
                                                            sprintf(auxExp2, "[%d]", exp2);
                                                              crearTerceto("CMP",auxExp1,auxExp2,tercetosCreados);
                                                           comparacionInd = crearTerceto(comparador,"_","_" ,tercetosCreados);
                                                           apilarNroTerceto(comparacionInd);
                                                            printf("\nREGLA 29: <comparacion> --> <expresion><comparador><expresion> \n");
                                                        };

expresion:
    expresion OP_SUMA termino                           {   
                                                            char auxTer[LONG_TERCETO];
                                                            char auxExp[LONG_TERCETO];
                                                            sprintf(auxTer,"[%d]",termInd);
                                                            sprintf(auxExp,"[%d]",expInd);
                                                            expInd = crearTerceto("OP_SUMA",auxExp,auxTer,tercetosCreados);  
                                                            ponerEnPila(&pilaExp,&expInd,sizeof(int));
                                                            printf("\nREGLA 30: <expresion> --> <expresion>OP_SUMA<termino> \n");
                                                        }

    | expresion OP_RESTA termino                        {   char auxTer[LONG_TERCETO];
                                                            char auxExp[LONG_TERCETO];
                                                            sprintf(auxTer,"[%d]",termInd);
                                                            sprintf(auxExp,"[%d]",expInd);
                                                            expInd = crearTerceto("OP_RESTA",auxExp,auxTer,tercetosCreados);
                                                            ponerEnPila(&pilaExp,&expInd,sizeof(int));
                                                            printf("\nREGLA 31: <expresion> --> <expresion>OP_RESTA<termino> \n");    
                                                        }

    | termino                                           {   expInd = termInd;
                                                            ponerEnPila(&pilaExp,&expInd,sizeof(int));
                                                             printf("\nREGLA 32: <expresion> --> <termino> \n");
                                                        }

    |OP_RESTA expresion %prec MENOS_UNARIO              {   char auxExp[LONG_TERCETO];
                                                            sprintf(auxExp,"[%d]",expInd);
                                                            expInd = crearTerceto("OP_RESTA", auxExp,"_",tercetosCreados);
                                                             ponerEnPila(&pilaExp,&expInd,sizeof(int));
                                                            printf("\nREGLA 33: <expresion> --> OP_RESTA <expresion> \n");
                                                        }  

    |longitud                                           {   expInd = longInd ;
                                                            ponerEnPila(&pilaExp,&expInd,sizeof(int));    
                                                            printf("\nREGLA 34: <expresion> --> <longitud> \n");
                                                        };      
    
termino:
    termino OP_MULT factor                              {   char auxTer[LONG_TERCETO];
                                                            char auxFac[LONG_TERCETO];
                                                            sprintf(auxTer,"[%d]",termInd);
                                                            sprintf(auxFac,"[%d]",factInd);
                                                            termInd = crearTerceto("OP_MULT",auxTer,auxFac,tercetosCreados);
                                                            ponerEnPila(&pilaTerm,&termInd,sizeof(int));  
                                                            printf("\nREGLA 36: <termino> --> <termino>OP_MULT<factor> \n");}
    | termino OP_DIV factor                             {   char auxTer[LONG_TERCETO];
                                                            char auxFac[LONG_TERCETO];
                                                            sprintf(auxTer,"[%d]",termInd);
                                                            sprintf(auxFac,"[%d]",factInd);
                                                            termInd = crearTerceto("OP_DIV",auxTer,auxFac,tercetosCreados);
                                                            ponerEnPila(&pilaTerm,&termInd,sizeof(int));                                           
                                                            printf("\nREGLA 37: <termino> --> <termino>OP_DIV<factor> \n");}
    | factor                                            {   termInd = factInd ;
                                                            ponerEnPila(&pilaTerm,&termInd,sizeof(int));
                                                            printf("\nREGLA 38: <termino> --> <factor> \n");};

longitud:
    LONG PAR_A lista PAR_C                    {longInd = listaInd ; printf("\nREGLA 39: <longitud> --> <ID>OP_ASIF<LONG>PAR_A<lista>PAR_C\n");};

lista:
    factor                                              {listaInd = factInd ; contList=1;printf("\nREGLA 40: <lista> --> <factor> \n");}
    | lista COMA factor                                 {listaInd = factInd; contList++;printf("\nREGLA 41: <lista> --> <lista>COMA<factor> \n");};

factor:
    PAR_A expresion PAR_C       {
                                factInd = expInd; 
                                ponerEnPila(&pilaFact,&factInd,sizeof(int));
                                printf("\nREGLA 42: <factor> --> PAR_A <expresion> PAR_C\n");
                                } 
    | CONST_REAL                {
                                factInd = crearTerceto(yytext,"_","_", tercetosCreados); 
                                ponerEnPila(&pilaFact,&factInd,sizeof(int));
                                cargarVecTablaNumero(yytext);printf("\nREGLA 43: <factor> --> CONST_REAL\n");
                                } 
    | ID                        {
                                factInd = crearTerceto(yytext,"_","_",tercetosCreados);
                                ponerEnPila(&pilaFact,&factInd,sizeof(int));
                                printf("\nREGLA 44: <factor> --> ID\n");
                                } 
    | CONST_ENT                 {
                                factInd = crearTerceto(yytext,"_","_", tercetosCreados);
                                cargarVecTablaNumero(yytext);
                                ponerEnPila(&pilaFact,&factInd,sizeof(int));
                                printf("\nREGLA 45: <factor> --> CONST_ENT\n");
                                };

comparador:
    OP_MAY          {strcpy(comparador, "BLE");printf("\nREGLA 46: <comparador> --> OP_MAY\n");} 
    | OP_MEN        {strcpy(comparador, "BGE");printf("\nREGLA 47: <comparador> --> OP_MEN\n");} 
    | OP_MENIGU     {strcpy(comparador,"BGT");printf("\nREGLA 48: <comparador> --> OP_MENIGU\n");} 
    | OP_MAYIGU     {strcpy(comparador, "BLT") ;printf("\nREGLA 49: <comparador> --> OP_MAYIGU\n");} 
    | OP_IGUAL      {strcpy(comparador,"BNE" );printf("\nREGLA 50: <comparador> --> OP_IGUAL\n");} 
    | OP_DIF        {strcpy(comparador,"BNQ" );printf("\nREGLA 51: <comparador> --> OP_DIF\n");};

dec:
    dec DIM COR_A listavar COR_C AS COR_A listatipodato COR_C   {printf("\nREGLA 52: <dec> --> <dec> COR_A listavar COR_C AS COR_A listatipodato COR_C\n");} 
    | DIM COR_A listavar COR_C AS COR_A listatipodato COR_C      {printf("\nREGLA 53: <dec> --> <dec> COR_A listavar COR_C AS COR_A listatipodato COR_C\n");};

%%





void cargarVecTablaNumero(char * text)
{

   int duplicados = 0,j;
    for ( j=0 ;j< (cantReg); j++)
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

        (cantReg)++;
    }



}





void cargarVecTablaID()
{
    while(!pilaVacia(&pVariable))
    {
        char vari[100];
        char tipoD[100];
        char* text;
        char * tDat;
        text =vari;
        tDat =tipoD;
        sacarDePila(&pVariable,vari,100);
        sacarDePila(&pTipoDato,tipoD,100);
        int duplicados = 0,j;
        for ( j=0 ;j< (cantReg); j++)
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
            // tb[cantReg].tipo[0] ='-';
            // tb[cantReg].tipo[1] ='\0'; 
            strcpy(tb[cantReg].tipo,tDat);
            tb[cantReg].longitud = 0;
            //printf("\nNombre : %s   -   Valor : %s -   longitud :    %d\n",tb[cantReg].nombre,tb[cantReg].valor,tb[cantReg].longitud);
            (cantReg)++;
        }

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
        for ( j=0 ;j < (cantReg); j++)
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
            (cantReg)++;
        //printf("\nNombre : %s   -   Valor : %s -   longitud :    %d\n",tb[cantReg-1].nombre , tb[cantReg-1].valor,tb[cantReg-1].longitud);
        }

    
}


int crearTerceto(char *c1, char*c2 ,char *c3,int nroT){//Acordarme de apsar [ ] cuando paso un indice
    
    t_Terceto tercetos;
    tercetosCreados++;
    tercetos.numTerceto = nroT;
    strcpy(tercetos.posUno,c1);
    strcpy(tercetos.posDos,c2);
    strcpy(tercetos.posTres,c3);
  

    ponerEnCola(&colaTercetos,&tercetos,sizeof(tercetos));

    return nroT;
}


int apilarNroTerceto(int nroTerceto)
{
    return ponerEnPila(&pilaNroTerceto,&nroTerceto,sizeof(nroTerceto));
    
}

int desapilarNroTerceto()
{   
    int  nroTerceto;
    sacarDePila(&pilaNroTerceto,&nroTerceto,sizeof(nroTerceto));
    return nroTerceto;
}


void escribirTercetoActualEnAnterior(int tercetoAEscribir,int tercetoBuscado)
{
    tCola  aux;
    crearCola(&aux);
    t_Terceto terceto;

    
 
    while(!colaVacia(&colaTercetos))
    {
        sacarDeCola(&colaTercetos,&terceto,sizeof(terceto));
       

        if(terceto.numTerceto == tercetoBuscado){
                char nueComponente [LONG_TERCETO];
                sprintf( nueComponente, "[%d]",tercetoAEscribir);
                strcpy(terceto.posTres, nueComponente);
        }
        ponerEnCola(&aux,&terceto,sizeof(terceto));
    }
    
    colaTercetos=aux;

}





