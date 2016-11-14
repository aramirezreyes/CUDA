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
  dim3 dB(1);

  printf("Checkpoint -2\n");
  i = atoi(argv[1]);
  printf("Checkpoint -1\n");
  a_h = (int*) malloc(i*sizeof(int));
  printf("Checkpoint 0\n");
  cudaMalloc((void**)&b_d,i*sizeof(int));
  c_h = (int*) malloc(i*sizeof(int));
  printf("Checkpoint 1\n");
  for(j=0;j<i;j++){
    *(a_h+j) = j;
    printf("The value at a+%d is: %d \n",j,*(a_h+j));
  }
  cudaMemcpy(b_d,a_h,i*sizeof(int),cudaMemcpyHostToDevice);
  increase<<< 1, 1>>>(b_d);
  cudaMemcpy(c_h,b_d,i*sizeof(int),cudaMemcpyDeviceToHost);
  for(j=0;j<i;j++)
    printf("The value at c+%d is: %d \n",j,*(c_h+j));
  printf("Checkpoint 3\n"); 
  return 0;
}