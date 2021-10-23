#include "funciones.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define minimo(X,Y) ((X) <= (Y) ? (X) : (Y))

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



////////////////////////////////////COLA/////////////

void crearCola(tCola *c)
{
    c->priC = NULL;
    c->ultC = NULL;

}

int colaLlena(const tCola *c,unsigned cantBytes)
{
    tNodo_c *aux = (tNodo_c *)malloc(sizeof(tNodo_c));
    void *infoC = malloc(cantBytes);
    free(aux);
    free(infoC);
    return aux == NULL|| infoC == NULL;
}

int ponerEnCola(tCola *c, const void *d, unsigned cantBytes)
{
    tNodo_c *nue = (tNodo_c *) malloc(sizeof(tNodo_c));

    if(nue == NULL || (nue->infoC = malloc(cantBytes))== NULL)
    {
        free(nue);
        return 0;
    }

    
    memcpy(nue->infoC,d, cantBytes);

    // printf("NUMERO TERCETO : %d\n",((t_Terceto*)d)->numTerceto);
    // printf("PRIEMERA POS TERCETO : %s\n",((t_Terceto*)d)->posUno);
    // printf("SEGUDA POS TERCETO : %s\n",((t_Terceto*)d)->posDos);
    // printf("TERCERTA POS TERCETO : %s\n",((t_Terceto*)d)->posTres);

    // printf("NUMERO TERCETO BIS : %d\n",((t_Terceto*)nue->infoC)->numTerceto);
    // printf("PRIEMERA POS TERCETO  BIS: %s\n",((t_Terceto*)nue->infoC)->posUno);
    // printf("SEGUDA POS TERCETO BIS: %s\n",((t_Terceto*)nue->infoC)->posDos);
    // printf("TERCERTA POS TERCETO BIS : %s\n",((t_Terceto*)nue->infoC)->posTres);

    nue->tamInfoC = cantBytes;
    nue->sigC = NULL;
    if(c->ultC)
        c->ultC->sigC = nue;
    else
        c->priC = nue;
    c->ultC = nue;
    return 1;
}

void vaciaCola(tCola *c)
{
    tNodo_c *aux;
    while(c->priC)
    {
        aux = c->priC;
        c->priC = aux->sigC;
        free(aux->sigC);
        free(aux);
    }
    c->ultC = NULL;
}

int verPrimeroCola(const tCola *c, void *d, unsigned cantBytes)
{
    if(c->priC == NULL)
        return 0;
    memcpy(d, c->priC->infoC,minimo(cantBytes, c->priC->tamInfoC));
    return 1;

}

int colaVacia (const tCola *c)
{
    return c->priC ==NULL;
}

int sacarDeCola(tCola *c, void *d, unsigned cantBytes)
{
    tNodo_c *elim = c->priC;
    if(elim == NULL)
        return 0;
    c->priC = elim->sigC;

    memcpy(d,elim->infoC,minimo( elim->tamInfoC, cantBytes));
   printf("NUMERO TERCETO : %d\n",((t_Terceto*)elim->infoC)->numTerceto);

    free(elim->infoC);
    free(elim);
    if(c->priC == NULL)
        c->ultC = NULL;
    return 1;
}








