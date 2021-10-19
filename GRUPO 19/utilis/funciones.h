#ifndef FUNCIONES_H
#define FUNCIONES_H




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

tablaSimbolos tb[2000];
int* cantReg;
FILE * fpTabla;
char aux[1000] ;


// ESTRUCTURA DE PILA
typedef struct tagStackItem
{
    char value[30];
    struct tagSExpression *estructura;
} StackItem;


typedef struct s_nodo_pila
{
    StackItem dato;
    struct s_nodo_pila *psig;
} t_nodo_pila;

typedef t_nodo_pila *t_pila;

///TIPOS DE FUNCION
typedef void (*t_mostrar)(const void *);

///PRIMITIVAS
void crearPila(t_pila *);
void vaciar_pila(t_pila *);
int meterEnPila(t_pila *, StackItem *);
int sacarDePila(t_pila *, StackItem *);
int esPilaVacia(const t_pila *);
int esPilaLlena(const t_pila *);
void vaciarPila(t_pila *);
int tope_de_pila(const t_pila *, StackItem *);



///OTRAS FUNCIONES
void mostrar_pila(const t_pila *, StackItem);

#endif // PRIMITIVAS_H_INCLUDED
