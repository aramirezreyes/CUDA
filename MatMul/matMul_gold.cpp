/* matMul_gold.cpp*/


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "matMul_conf.h"

extern "C" void matMul_cpu(float *out,  float* arrA,  float *arrB, int size);
extern "C" bool compareResults( float *arrA,float *arrB, int size, float eps);
extern "C" void printArray(  float* arr,  int nbelem);

//out <- C = A*B
void matMul_cpu(float *out,   float* arrA,   float *arrB,   int size){
for(int j=0;j<size;++j){
for(int i=0; i<size; ++i){
for(int k=0;k<size;k++)
  *(out+size*j+i) += *(arrA+size*j+k)*(*(arrB+size*i+k));
}
}
}

bool compareResults( float *arrA,float *arrB, int size,  float eps){
for(int j=0;j<size;++j){
for(int i=0;i<size;++i){
if(fabs(arrA[i*size+j]-arrB[i*size+j])>eps)return false;
}}

return true;
}

void printArray(  float *arr,  int nbelem){
for(int i=0;i<nbelem;++i){
  for(int j=0;j<nbelem;++j)
    printf("%.5f ",arr[i*nbelem+j]);
printf("\n");}
}
