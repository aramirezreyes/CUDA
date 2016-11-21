/*matMul_conf.h */

#ifndef MATMUL_CONF_H
#define MATMUL_CONF_H
#define BLOCKSIZE 16
#define WIDTH (3*BLOCK_SIZE)
#include <cuda_runtime.h>

#define gpuErrchk(ans)				\
  { gpuAssert((ans), __FILE__, __LINE__); }
inline void gpuAssert(cudaError_t code,   char *file, int line,
                      bool abort = true) {
  if (code != cudaSuccess) {
    fprintf(stderr, "GPUassert: %s %s %d\n", cudaGetErrorString(code), file,
            line);
    if (abort)
      exit(code);
  }
}

#endif


