#ifndef FUNCIONES_H
#define FUNCIONES_H


#define STR_LIMITE 100
#define ID_LIMITE 30
#define ENT_LIMITE 5
#define TABLA_SIMBOLOS_TXT "ts.txt"
#define INTERMEDIA_TXT "intermedia.txt"
#define ELEMENTOS_TERCETO 20

#define SIN_MEMORIA 0
#define COLA_VACIA 0



#include <stdio.h>
#include <stdlib.h>
#include <string.h>


typedef struct
{
    char nombre[200];
    char tipo[30];
    char valor[200];
    int longitud;   

}tablaSimbolos;




// ESTRUCTURA DE PILA

typedef struct sNodo
{
    void           *info;
    unsigned        tamInfo;
    struct sNodo   *sig;
} tNodo;
typedef tNodo *tPila;

void crearPila(tPila *p);
int  pilaLlena(const tPila *p, unsigned cantBytes);
int  ponerEnPila(tPila *p, const void *d, unsigned cantBytes);
int  verTope(const tPila *p, void *d, unsigned cantBytes);
int  pilaVacia(const tPila *p);
int  sacarDePila(tPila *p, void *d, unsigned cantBytes);
void vaciarPila(tPila *p);

//////////////lists///////////
typedef struct lNodo
{
    unsigned    cantBytes;
    void*   d;
    struct sNodo* sig;

}lNodo;
typedef lNodo* tLista;






/////////ESTRCUTURA COLA ////////////
typedef struct cNodo
{
    void *infoC;
    unsigned tamInfoC;
    struct cNodo *sigC;
} tNodo_c;

typedef struct
{
    tNodo_c *priC,
          *ultC;
} tCola;


void crearCola(tCola *c);

int colaLlena(const tCola *c,unsigned cantBytes);

int ponerEnCola(tCola *c, const void *d, unsigned cantBytes);

void vaciaCola(tCola *c);

int verPrimeroCola(const tCola *c, void *d, unsigned cantBytes);

int colaVacia (const tCola *c);

int sacarDeCola(tCola *c, void *d, unsigned cantBytes);


////////TERCETOS/////////
typedef struct
{
    int numTerceto;
    char posUno[ELEMENTOS_TERCETO];
    char posDos[ELEMENTOS_TERCETO];
    char posTres[ELEMENTOS_TERCETO];
}t_Terceto;




////////Variables///////
//-Pila
tPila pTipoDato;
tPila pVariable;
//-Cola
tCola  colaTercetos;


tablaSimbolos tb[2000];
int cantReg;
FILE * fpTabla;
char aux[1000] ;
FILE* fpIntermedia;

///OTRAS FUNCIONES

#endif // PRIMITIVAS_H_INCLUDED
