#ifndef PRIMITIVAS_H_INCLUDED
#define PRIMITIVAS_H_INCLUDED
#include "expression.h"

#define SIN_MEMORIA 0
#define COLA_VACIA 0

// ESTRUCTURA DE COLA
typedef struct
{
    char nombre[30];
    char tipo[30];
    int longitud;
    char valor[30];
} QueueItem;

typedef struct s_nodo
{
    QueueItem dato;
    struct s_nodo *sig;
} t_nodo;

typedef struct
{
    t_nodo *pri;
    t_nodo *ult;
} t_cola;

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

void crearCola(t_cola *);
int acolar(t_cola *, const QueueItem *);
int desacolar(t_cola *, QueueItem *);
int colaLlena(const t_cola *);
int colaVacia(const t_cola *);
int verPrimero(const t_cola *, QueueItem *);
void vaciarCola(t_cola *);
void cargarItemSimbolo(QueueItem *, char *, char *);
void cargarItemSimboloCadena(QueueItem *, char *, int *);
void cargarItemSimboloVariable(QueueItem *, char *, char *);

///OTRAS FUNCIONES
void mostrar_pila(const t_pila *, StackItem);

#endif // PRIMITIVAS_H_INCLUDED
