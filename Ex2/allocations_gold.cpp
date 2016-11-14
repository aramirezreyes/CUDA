/* test_gold.cpp*/
#include "test_conf.h"
#include <string.h>
//export C interface
 extern "C" void inc_cpu(int* src, int length);

void inc_cpu(int* src, int length){
  int i;
  for(i=0;i<length;i++)
    src[i] = src[i]+1;
}




