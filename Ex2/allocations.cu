/*test.cu*/
#include <stdio.h>
#include "allocations_kernel.cu"
extern void inc_cpu(int* src, int length);
int main (int argc, char **argv){
  int i,j;
  int* a_h;
  int* b_d;
  int* c_h;
  dim3 dG(1);
  dim3 dB(16,8,1);
  i = atoi(argv[1]);
  a_h = (int*) malloc(i*sizeof(int));
  cudaMalloc((void**)&b_d,i*sizeof(int));
  c_h = (int*) malloc(i*sizeof(int));
  for(j=0;j<i;j++){
    *(a_h+j) = j;
    printf("The value at a+%d is: %d \n",j,*(a_h+j));
  }
  cudaMemcpy(b_d,a_h,i*sizeof(int),cudaMemcpyHostToDevice);
  inc_gpu<<< dG, dB>>>(b_d,i);
  cudaMemcpy(c_h,b_d,i*sizeof(int),cudaMemcpyDeviceToHost);
  for(j=0;j<i;j++)
    printf("The value at c+%d is: %d \n",j,*(c_h+j));
  return 0;
}