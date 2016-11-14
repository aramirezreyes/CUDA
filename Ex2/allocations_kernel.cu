/* allocations_kernel.cu*/
#include "test_conf.h"
#include <string.h>


__global__ void increase(int* src){
  src[0]++;  
}

__global__ void inc_gpu(int* src, int n){
  int tid = threadIdx.y*blockDim.x + threadIdx.x;
  if(tid<n)
    src[tid]++;
}





