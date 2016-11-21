/*matMul_kernel.cu*/
#include "matMul_conf.h"


//matMul kernel
__global__ void matMulKernel(float *out,  float* arrA,   float* arrB,  int nbelem){
  int tidx =  threadIdx.x;
  int tidy =  threadIdx.y;
  *(out+nbelem*tidx+tidy) = 0;
  if(tidx<nbelem & tidx<nbelem){
	for(int k=0;k<nbelem;k++)
	  *(out+nbelem*tidx+tidy) += *(arrA+nbelem*tidx+k)*(*(arrB+nbelem*k+tidy));
  }
}




