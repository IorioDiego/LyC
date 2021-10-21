#ifndef FUNCIONES_H
#define FUNCIONES_H


#define STR_LIMITE 100
#define ID_LIMITE 30
#define ENT_LIMITE 5
#define TABLA_SIMBOLOS_TXT "ts.txt"

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


////////Variables///////
tPila pTipoDato;
tPila pVariable;


tablaSimbolos tb[2000];
int cantReg;
FILE * fpTabla;
char aux[1000] ;

///OTRAS FUNCIONES

#endif // PRIMITIVAS_H_INCLUDED
