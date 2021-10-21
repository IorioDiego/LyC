#include "funciones.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

//////////////////////////////////////////////////////////////////////////////////
///PRIMITIVAS
//////////////////////////////////////////////////////////////////////////////////

void crearPila(tPila * p)
{
    *p=NULL;
}

//int  pilaLlena(const tPila *p,unsigned cantBytes)
//{
//    tNodo * nue;
//    nue=(tNodo*)malloc(sizeof(cantBytes));
//    if(!nue)
//        return 0;
//    free(nue);
//    return 1;
//}

int  pilaLlena(const tPila *p,unsigned cantBytes)
{
    tNodo * nue=(tNodo*)malloc(sizeof(tNodo));
    void* info=malloc(cantBytes);
    free(nue);
    free(info);
    return nue==NULL || info==NULL;
}



int pilaVacia(const tPila* p)
{
    return *p==NULL;
}

int ponerEnPila(tPila *p,const void *d,unsigned cantBytes)
{
    tNodo * nue;
    nue=(tNodo*)malloc(sizeof(tNodo));
    if(!nue)
        return 0;
    nue->info=malloc(cantBytes);
    if(!nue->info)
        {
            free(nue);
            return 0;
        }
    memcpy(nue->info,d,cantBytes);
    nue->tamInfo=cantBytes;
    nue->sig=*p;
    *p=nue;
    return 1;
}

int sacarDePila(tPila* p, void *d,unsigned cantBytes)
{
    unsigned min;
    tNodo* aux = *p;
    if(*p==NULL)
        return 0;
    if(cantBytes> aux->tamInfo)
        min=aux->tamInfo;
    else
        min=cantBytes;
    *p=aux->sig;
    memcpy(d,aux->info,min);
    free(aux->info);
    free(aux);
    return 1;
}

void vaciarPila(tPila *p)
{
    tNodo *aux = *p;
    while(*p)
    {
        aux = *p;
        *p=aux->sig;
        free(aux->info);
        free(aux);
    }
}

int verTope(const tPila * p,void *d, unsigned cantBytes)
{
    unsigned min;
    tNodo* aux = *p;
    if(*p==NULL)
        return 0;
    if(cantBytes> aux->tamInfo)
        min=aux->tamInfo;
    else
        min=cantBytes;
    memcpy(d,aux->info,min);
    return 1;
}











