#include "funciones.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

//////////////////////////////////////////////////////////////////////////////////
///PRIMITIVAS
//////////////////////////////////////////////////////////////////////////////////
void crearPila(t_pila *pp)
{
    *pp = NULL;
}
//////////////////////////////////////////////////////////////////////////////////
int meterEnPila(t_pila *pp, StackItem *pi)
{
    t_nodo_pila *pn = (t_nodo_pila *)malloc(sizeof(t_nodo_pila));
    if (!pn)
        return 0;
    pn -> dato = *pi;
    pn -> psig = *pp;
    *pp = pn;
    return 1;
}
//////////////////////////////////////////////////////////////////////////////////
int sacarDePila(t_pila *pp, StackItem *pi)
{
    t_nodo_pila *pn;
    if (!*pp)
        return 0;
    pn = *pp;
    *pi = (*pp)->dato; //Para que guarda este dato si lo va a sacar?//Es para mostrar en un printf "se saco este dato"??
    *pp = (*pp)->psig;
    free(pn);
    return 1;
}
//////////////////////////////////////////////////////////////////////////////////
int esPilaVacia(const t_pila *pp)
{
    return *pp == NULL;
}
//////////////////////////////////////////////////////////////////////////////////
int esPilaLlena(const t_pila *pp)
{
    t_nodo_pila *pn = (t_nodo_pila *)malloc(sizeof(t_nodo_pila)); //Crea un nodo, el cual hace que sea apuntado por pn.
    free(pn);                                                     //Si hay memoria, el puntero pn va a existir, por ende libera la memoria para no desperdiciarla.
    return pn == NULL;                                            //Pregunta si el puntero pn se creo.
}
//////////////////////////////////////////////////////////////////////////////////
int tope_de_pila(const t_pila *pp, StackItem *pi)
{
    if (!*pp)
        return 0;
    *pi = (*pp)->dato;
    return 0;
}

void vaciarPila(t_pila *pp)
{
    t_nodo_pila *pn;
    while (*pp)
    {
        pn = *pp;
        *pp = (*pp)->psig;
        printf("\n%s\n", pn->dato.value);
        free(pn);
    }
}

