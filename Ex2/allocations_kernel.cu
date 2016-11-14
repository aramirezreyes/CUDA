/* allocations_kernel.cu*/
#include "test_conf.h"
#include <string.h>


__global__ void increase(int* src){
  src[0]++;  
}






