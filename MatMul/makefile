NAME = matMul

PG =   -g
OPT = $(PG) -Wall -Wno-deprecated -Wno-non-virtual-dtor

CUDA_PATH = /usr/local/cuda-8.0

CUDA_BIN_PATH = $(CUDA_PATH)/bin
NVCC_OPT = #--ptxas-options=-v -G -lineinfo

NVCC = $(CUDA_BIN_PATH)/nvcc $(NVCC_OPT)
CC = g++

INC = /usr/local/cuda-8.0/include/
CC += -I $(INC)

$(NAME) : $(NAME).o $(NAME)_gold.o
	$(NVCC) -o $(NAME) $(NAME).o $(NAME)_gold.o $(PG)

$(NAME).o : $(NAME).cu
	$(NVCC) -o $(NAME).o -c $(NAME).cu

$(NAME)_kernel.o : $(NAME)_kernel.cu
	$(NVCC) -o $(NAME)_kernel.o -c $(NAME)_kernel.cu

$(NAME)_gold.o : $(NAME)_gold.cpp
	$(CC) -o $(NAME)_gold.o -c $(NAME)_gold.cpp

clean :
	rm *.o
