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

void generarAssembler();

int crearTerceto(char* c1,char *c2,char *c3 ,int nroT);
int desapilarNroTerceto();
void escribirTercetoActualEnAnterior(int tercetoAEscribir,int tercetoBuscado);
int desapilarNroTerceto();
int apilarNroTerceto(int nroTerceto);


void cargarVecTablaNumeroReal(char * text);
void cargarVecTablaString(char * text);
void cargarVecTablaID();
void cargarVecTablaNumero(char * text);
void cargarVecTablaString(char * text);


void escribirTablaSimbolos();
int abrirTablaDeSimbolos(char*);
int abrirIntermedia(char*);
void escribirTercetosEnIntermedia();



%}

%start start 
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
start: programa                     {       abrirTablaDeSimbolos("wt");
                                            abrirIntermedia("wt");
                                            escribirTablaSimbolos();
                                            escribirTercetosEnIntermedia();
                                            fclose(fpTabla);
                                            fclose(fpIntermedia);
                                            
                                                crearArchivoAssembler();

                                            abrirTablaDeSimbolos("rt");
                                            abrirIntermedia("rt");
                                            
                                            generarAssembler();

                                            fclose(fpTabla);
                                            fclose(fpIntermedia);
                                            fclose(fpAss);
                                    };
    
                                        

programa:
    sentencia                       {prgInd=sentInd;printf("\nREGLA 1: <programa> --> <sentencia>\n");}       
    | programa sentencia            {prgInd=sentInd;printf("\nREGLA 2: <programa> --> <programa> <sentencia>\n");};              
    
sentencia:
     declaracion                     {sentInd=decInd ;printf("\nREGLA 3: <sentencia> --> <declaracion>\n");}  
    |asignacion                      {sentInd=asignacionInd;printf("\nREGLA 4: <sentencia> --> <asignacion>\n");}   
    |ciclo                           {sentInd= cicloInd;printf("\nREGLA 5: <sentencia> --> <cilco>\n");}   
    |seleccion                       {sentInd= selecInd;printf("\nREGLA 6: <sentencia> --> <seleccion>\n");}   
    |salida                          {sentInd=salidaInd;printf("\nREGLA 7: <sentencia> --> <salida>\n");}   
    |entrada                         {sentInd=entradaInd;printf("\nREGLA 8: <sentencia> --> <entrada>\n");} 
    |longitud                        {sentInd=longInd;printf("\nREGLA 9: <sentencia> --> <longitud>\n");}; 


declaracion:
    DECVAR  dec ENDDECVAR            {cargarVecTablaID();printf("\nREGLA 10: <declaracion> --> DECVAR DIM <dec> ENDDECVAR\n");};    

  
listavar:
    ID                             {
                                    char nv[200];
                                    nv[0]='_';
                                    nv[1]='\0';
                                    strcat(nv,yytext); 
                                    crearTerceto(nv,"_","_",tercetosCreados);
                                    ponerEnPila(&pVariable,yytext,LONG_ID);
                                    printf("\nREGLA 11: <listavar> --> ID \n");
        
                                    }
    | listavar COMA ID             {
                                    char nv[200];
                                    nv[0]='_';
                                    nv[1]='\0';
                                    strcat(nv,yytext); 
                                    crearTerceto(nv,"_","_",tercetosCreados);
                                    ponerEnPila(&pVariable,yytext,LONG_ID);
                                    printf("\nREGLA 12: <listavar> --> <listavar> COMA ID\n");};

listatipodato:
    tipodato                        {printf("\nREGLA 13: <listatipodato> --> <tipodato> \n");}
    | listatipodato COMA tipodato  {printf("\nREGLA 14: <listatipodato> --> <listatipodato> COMA <tipodato>\n");};

tipodato:
    INTEGER                         {ponerEnPila(&pTipoDato,yytext,LONG_TIPO_INTEGER);printf("\nREGLA 15: <tipodato> --> INTEGER  \n");}
    | FLOAT                         {ponerEnPila(&pTipoDato,yytext,LONG_TIPO_FLOAT);printf("\nREGLA 16: <tipodato> --> FLOAT \n");}
    | STRING                        {ponerEnPila(&pTipoDato,yytext,LONG_TIPO_STR);printf("\nREGLA 17: <tipodato> --> STRING \n");};

seleccion:
    IF condicion  THEN  programa else programa ENDIF      {
                                                            // int t = desapilarNroTerceto();
                                                            int t;
                                                           
                                                          
                                                            while(!pilaVacia(&pilaComparacion)){
                                                                sacarDePila(&pilaComparacion,&t,sizeof(int));
                                                                escribirTercetoActualEnAnterior(tercetosCreados,t);
                                                            }
                                                            
                                                              selecInd = desapilarNroTerceto();
                                                              escribirTercetoActualEnAnterior(tercetosCreados,selecInd);
                                                             
                                                        printf("\nREGLA 18: <seleccion> --> IF <condicion> THEN <programa> ELSE <programa> ENDIF\n");  
                                                        }
    | IF                               
    condicion  THEN programa ENDIF    {
                               
                                    
                                    int t; 
                                     
                                     while(!pilaVacia(&pilaComparacion)){
                                         sacarDePila(&pilaComparacion,&t,sizeof(int));
                                         escribirTercetoActualEnAnterior(tercetosCreados,t);
                                     }
                                     selecInd = desapilarNroTerceto();
                                    printf("\nREGLA 19: <seleccion> --> IF <condicion> THEN <programa> ENDIF \n");
                                    };
else:
    ELSE {   
        //  int t= desapilarNroTerceto();
        int t; 
         sacarDePila(&pilaComparacion,&t,sizeof(int));
        escribirTercetoActualEnAnterior(tercetosCreados+1,t);
        apilarNroTerceto(sentInd);
        apilarNroTerceto(crearTerceto("BI","_","_",tercetosCreados));};


           



ciclo:
    WHILE ID            {
                                   char nv[200];
                                    nv[0]='_';
                                    nv[1]='\0';
                                    strcat(nv,yytext); 
                            crearTerceto(nv,"_","_",tercetosCreados);
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
    GET ID                                          {   

                                                        char nv[200] ;
                                                        nv[0] = '_';
                                                        nv[1] = '\0';
                                                        strcat(nv,yytext);
                                                        entradaInd= crearTerceto("GET",nv,"_",tercetosCreados);
                                                        printf("\nREGLA 21: <entrada> --> GET <factor>\n");};

salida:
    DISPLAY CONST_STR                                   {   
                                                                int i=0 ;
                                                                char aux [strlen(yytext)+1];
                                                                strcpy(aux,yytext);
                                                                aux[0] = '_';
                                                                for (i=0; i<= strlen(yytext) ; i++ )
                                                                {
                                                                    if(aux[i] == ' ')
                                                                        aux[i]= '_';
                                                                }
                                                                aux[i-2]='\0';
                                                            salidaInd=crearTerceto("DISPLAY",aux,"_",tercetosCreados);
                                                            cargarVecTablaString(yytext);printf("\nREGLA 22: <salida> -->  DISPLAY CONST_STR  \n");};

asignacion:
    ID                                                 {

                                                        char nv[200] ;
                                                        nv[0] = '_';
                                                        nv[1] = '\0';
                                                        strcat(nv,yytext);
                                                        asignacionInd = crearTerceto(nv,"_","_",tercetosCreados);} 
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
                                                            comparacionInd=crearTerceto("CMP",auxExp2,auxExp1,tercetosCreados);
                                                           apilarNroTerceto(comparacionInd);
                                                           int t= crearTerceto(comparador,"_","_" ,tercetosCreados);
                                                           ponerEnPila(&pilaComparacion,&t,sizeof(int));
                                                          // apilarNroTerceto(t);
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
    | CONST_REAL                {          char nv[strlen(yytext)+3];
                                    if( *yytext == '.' ){
                              
                                        nv[0] = '_';
                                        nv[1] = '0';
                                         nv[2] = '\0';
                                        strcat(nv,yytext);
                                      
                                    }else{
                                     
                                        nv[0] = '_';
                                        nv[1] = '\0';
                                        strcat(nv,yytext);
                                       
                                    }
                                 factInd = crearTerceto(nv,"_","_", tercetosCreados); 
                                 cargarVecTablaNumeroReal(nv);
                                ponerEnPila(&pilaFact,&factInd,sizeof(int));
                             printf("\nREGLA 43: <factor> --> CONST_REAL\n");
                                }


    | ID                        {
                                char nv[200];   
                                nv[0] = '_';
                                        
                                nv[1] = '\0';
                                strcat(nv,yytext);
                                factInd = crearTerceto(nv,"_","_",tercetosCreados);
                                ponerEnPila(&pilaFact,&factInd,sizeof(int));
                                printf("\nREGLA 44: <factor> --> ID\n");
                                } 
    | CONST_ENT                 {
                                
                                
                                char nv[strlen(yytext)+4];
                                nv[0]='_';
                                nv[1] = '\0';
                                strcat( nv,yytext);
                                strcat(nv,".0\0");
                                
                                factInd = crearTerceto(nv,"_","_", tercetosCreados);
                                ponerEnPila(&pilaFact,&factInd,sizeof(int));
                                cargarVecTablaNumero(nv);
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
    dec DIM COR_A listavar COR_C AS COR_A listatipodato COR_C   {decInd =listavarInd  ;printf("\nREGLA 52: <dec> --> <dec> COR_A listavar COR_C AS COR_A listatipodato COR_C\n");} 
    | DIM COR_A listavar COR_C AS COR_A listatipodato COR_C     {decInd =listavarInd  ;printf("\nREGLA 53: <dec> --> <dec> COR_A listavar COR_C AS COR_A listatipodato COR_C\n");};

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
        char aux[tamanio+1];
     
        for (i=0; i<= tamanio ; i++ )
        {
            aux[i]=*(text+i+1);

        }
       
        aux[i]='\0';
        strcpy(tb[cantReg].nombre,text);
         strcpy( tb[cantReg].valor,aux);
    //    strcat(tb[cantReg].valor,".0");
        strcpy(tb[cantReg].tipo,"INTEGER\0");
        tb[cantReg].longitud = 0;
     

        (cantReg)++;
    }



}

void cargarVecTablaNumeroReal(char * text)
{

   int duplicados = 0,j;
    for ( j=0 ;j< (cantReg); j++)
    {
        if(strcmp(text,(tb[j].nombre)+1)==0)
            duplicados = 1;      
    }

    if(!duplicados){
        
        strcpy(tb[cantReg].nombre,text);
        int tamanio=strlen(text),i;
        char aux[tamanio+1];
        
        for (i=0; i< tamanio ; i++ )
        {
            aux[i]=*(text+i+1);

        }
        aux[i]='\0';
  
      
     
            strcpy(tb[cantReg].valor,aux);
        
        
        strcpy(tb[cantReg].tipo,"FLOAT\0");
        tb[cantReg].longitud = 0;
     

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
        
            strcpy(tb[cantReg].tipo,tDat);
            tb[cantReg].longitud = 0;
           
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
            
            strcpy(tb[cantReg].tipo,"STRING\0");
            tb[cantReg].longitud = strlen(text)-2;
            (cantReg)++;
     
        }

    
}


int crearTerceto(char *c1, char*c2 ,char *c3,int nroT){
    
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


int abrirTablaDeSimbolos(char * modo)
{
    fpTabla = fopen(TABLA_SIMBOLOS_TXT,modo);
    if(!fpTabla)
    {
        printf("Error de apertura del archivo de la tabla de simbolos");
        return 0;
    }
    return 1;
}

//podriaSer la misma funcion q harab los archivos
int abrirIntermedia(char * modo){
    fpIntermedia = fopen(INTERMEDIA_TXT,modo);
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




void generarAssembler(){
tPila pAss;
crearPila(&pAss);
int  ponerEnPila(tPila *p, const void *d, unsigned cantBytes);

fprintf(fpAss,  "include macros2.asm");
fprintf(fpAss,  "\ninclude number.asm");
fprintf(fpAss,  "\n.MODEL LARGE");
fprintf(fpAss,  "\n.386");
fprintf(fpAss,  "\n.STACK 200h");
fprintf(fpAss,  "\n.DATA\n\n");
char linea[1000];

fgets(linea, sizeof(linea),fpTabla);
while(fgets(linea, sizeof(linea),fpTabla)){

    char nombre[40];
    char tipo[20];
    char valor[40];
    char longitud[20];   
    sscanf(linea,"\n%s\t\t\t%s\t\t\t%[^\t]\t\t\t%s\n",nombre,tipo, valor,longitud);
    if( strlen(valor)>1 && valor[0] =='-'){
        valor[0] = '?';
        valor[1] = '\0';
    }


    fprintf(fpAss,"%-20s dd\t\t %-30s : numero en formato %s\n",nombre,valor,tipo);

}

fprintf(fpAss,  "\n.CODE");
fprintf(fpAss,  "\nmov AX.@DATA");
fprintf(fpAss,  "\nmov DS.AX");
fprintf(fpAss,  "\nmov es.ax;");
while(fgets(linea, sizeof(linea),fpIntermedia)){
     char p0[200];
     char p1[200];
     char p2[200];
     char p3[200];


    sscanf(linea,"%s ( %s ; %s ; %s )",p0,p1,p2,p3);
    strcat(p0,"\0");
    printf("\n%s      %s      %s      %s\n",p0,p1,p2,p3);
    // if( (p2[0]  == '_')  &&  (p3[0] == '_') ){
    //     ponerEnPila(&pAss, &p1 , sizeof(p1));
    // }

    // if(strcmp("OP_ASIG",p1) == 0 )
    // {
    //     char st0[200];
    //     char st1[200];
    //     sacarDePila(&fpAss,st0,sizeof(st0));       
    //     sacarDePila(&fpAss,st1,sizeof(st1));
    //     fprintf(fpAss,)
    //     fprintf();
    // }

    // if(strcmp("OP_ASIG",p1) == 0 ){

    // }


}


fprintf(fpAss,  "\nmov ax.4c00h");
fprintf(fpAss,  "\nint 21h");
fprintf(fpAss,  "\nEnd");




}


int crearArchivoAssembler()
{
    fpAss = fopen("Final.asm","wt");
    if(!fpAss)
    {
        printf("Error de apertura del archivoassembler");
        return 0;
    }
    return 1;
}
