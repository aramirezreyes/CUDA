/*matMul.cu*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "matMul_kernel.cu"
extern "C" void matMul_cpu(float *out, float* arrA, float *arrB,int size);
extern "C" bool compareResults(  float *arrA,  float *arrB,  int size,   float eps);
extern "C" void printArray(  float* arr,  int nbelem);

int main(int argc, char **argv){
cudaFree(0);
cudaEvent_t start,stop;
float msec;
cudaEventCreate(&start);
cudaEventCreate(&stop);
//get array size from command line argument
if(argc==1){
printf("provide nbelem\n");
exit(0);
}
int nbelem=atoi(argv[1]);

//**** CPU ****
//declare host pointers
float *arrA, *arrB, *arrC;

//allocate on host
arrA = (float*)malloc(nbelem*nbelem*sizeof(float));
arrB = (float*)malloc(nbelem*nbelem*sizeof(float));
arrC = (float*)malloc(nbelem*nbelem*sizeof(float));
for(int i=0; i<nbelem*nbelem;i++)
  arrC[i] = 0;
//initialize on host
srand( time(NULL) );
for(int j=0;j<nbelem;++j){
for(int i=0;i<nbelem;++i){
*(arrA+nbelem*j+i)=rand()%10;
*(arrB+nbelem*j+i)=rand()%10;
}
}

//compute on host, store result in arrC
cudaEventRecord(start);
matMul_cpu(arrC,arrA,arrB,nbelem);
cudaEventRecord(stop);
cudaEventSynchronize(stop);
cudaEventElapsedTime(&msec,start,stop);
printf("Time elapsed while computing on cpu: %f\n",msec);
//**** GPU ****
//declare device pointers
float *arrA_d,*arrB_d, *arrC_d;

//allocate on device
gpuErrchk( cudaMalloc((void**)&arrA_d,nbelem*nbelem*sizeof(float)) );
gpuErrchk( cudaMalloc((void**)&arrB_d,nbelem*nbelem*sizeof(float)) );
gpuErrchk( cudaMalloc((void**)&arrC_d,nbelem*nbelem*sizeof(float)) );

//copy input H2D
cudaEventRecord(start);
gpuErrchk(  cudaMemcpy(arrA_d,arrA,nbelem*nbelem*sizeof(float),cudaMemcpyHostToDevice) );
gpuErrchk(  cudaMemcpy(arrB_d,arrB,nbelem*nbelem*sizeof(float),cudaMemcpyHostToDevice) );
cudaEventRecord(stop);
cudaEventSynchronize(stop);
cudaEventElapsedTime(&msec,start,stop);
printf("Time elapsed while copying data to gpu: %f\n",msec);
//kernel launch parameters
dim3 dG(1);
dim3 dB(BLOCKSIZE,BLOCKSIZE);

//compute on device
cudaEventRecord(start);
matMulKernel<<< dG,dB >>>(arrC_d, arrA_d, arrB_d, nbelem);
cudaEventRecord(stop);
cudaEventSynchronize(stop);
cudaEventElapsedTime(&msec,start,stop);
printf("Time elapsed while executing the kernel: %f\n",msec);

//gpuErrchk( cudaPeekAtLastError() );
//gpuErrchk( cudaDeviceSynchronize() );

//declare and allocate auxiliary host array
float *arrAux;
arrAux = (float*)malloc(nbelem*nbelem*sizeof(float));

//copy result D2H
cudaEventRecord(start);
gpuErrchk( cudaMemcpy(arrAux,arrC_d,nbelem*nbelem*sizeof(float),cudaMemcpyDeviceToHost) );
cudaEventRecord(stop);
cudaEventSynchronize(stop);
cudaEventElapsedTime(&msec,start,stop);
printf("Time elapsed while retrieving data from gpu: %f\n",msec);
//compare hostand device results
if(compareResults(arrC,arrAux,nbelem,1.0e-2))printf("test ok\n");
 else printf("test failed\n");
printf("A\n");
printArray(arrA,nbelem);
printf("B\n");
printArray(arrB,nbelem);
printf("C\n");
printArray(arrC,nbelem);
printf("D\n");
printArray(arrAux,nbelem);
//free memory on host
free(arrA);
free(arrB);
free(arrC);
free(arrAux);

//free memory on device
gpuErrchk( cudaFree(arrA_d) );
gpuErrchk( cudaFree(arrB_d) );
gpuErrchk( cudaFree(arrC_d) );

//reset device
gpuErrchk( cudaDeviceReset() );
cudaEventDestroy(start);
cudaEventDestroy(stop);
}
