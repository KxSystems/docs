---
title: GPUs – calling CUDA code from q
description: This is a quick example of calling CUDA code from q. CUDA is a variant on C that is used to write general-purpose programs that execute on NVIDIA graphics cards. Data is copied to the card, the computation executed, and the results copied back. It is important that there is significant computation work to be performed on the card (ideally this entirely dominates the execution time); there is enough parallelism in the computation to keep the hardware resources of the card/s busy; and that the data set fit in the limited memory of the cards.
keywords: api, cuda, gpu, graphical, kdb+, library, processing, q, unit
---
# GPUs



This is a quick example of calling CUDA code from q. It’s quite trivial to call out to the code.

To set the scene (and hopefully experts will forgive the simplifications) CUDA is a variant on C that is used to write general-purpose programs that execute on NVIDIA graphics cards. Data is copied to the card, the computation executed, and the results copied back. It is important that

-   there is significant computation work to be performed on the card – ideally this entirely dominates the execution time
-   there is enough parallelism in the computation to keep the hardware resources of the card/s busy
-   that the data set fit in the limited memory of the cards

<i class="far fa-hand-point-right"></i> [Documentation on CUDA](http://www.nvidia.com/object/cuda_develop.html)

On to a simple example of a function that takes an array of reals and squares it. Here we use single-precision floating point, however double can be used as well on later-model cards. Here is the annotated code:

```cuda
// Include the cuda header and the k.h interface.
#include <cuda.h>
#include"k.h"

// Export the function we will load into kdb+
extern "C" K gpu_square(K x);

// Define the "Kernel" that executes on the CUDA device in parallel
__global__ void square_array(float *a, int N) {
 int idx = blockIdx.x * blockDim.x + threadIdx.x;
 if (idx<N)
    a[idx] = a[idx] * a[idx];
}

// A function to use from kdb+ to square a vector of reals by
// - allocating space on the graphics card
// - copying the data over from the K object
// - doing the work
// - copy back and overwrite the K object data
K gpu_square(K x) {
  // Pointers to host & device arrays
 float *host_memory = (float*) &(kF(x)[0]), *device_memory;

 // Allocate memory on the device for the data and copy it to the GPU
 size_t size = xn * sizeof(float);
 cudaMalloc((void **)&device_memory, size);
 cudaMemcpy(device_memory, host_memory, size, cudaMemcpyHostToDevice);

 // Do the computaton on the card
 int block_size = 4;
 int n_blocks = xn/block_size + (xn%block_size == 0 ? 0:1);
 square_array <<< n_blocks, block_size >>> (device_memory, xn);

 // Copy back the data, overwriting the input, 
 // free the memory we allocated on the graphics card
 cudaMemcpy(host_memory, device_memory, size, cudaMemcpyDeviceToHost);
 cudaFree(device_memory);
 return 0;
}

// Then we use the function from kdb+ like this:
$ cat test.q
square:`cudalib 2:(`gpu_square;1)
numbers: "e"$til 10
square[numbers]
numbers
\\

// And here's a sample execution 64-bit Linux with an NVIDIA GTX 8800:
$ q test.q
KDB+ 2.4 2008.09.02 Copyright (C) 1993-2008 Kx Systems
l64/ ...

0 1 4 9 16 25 36 49 64 81e
```

To give a feel for real use-cases, a Libor Monte-Carlo portfolio computation runs in about 26 seconds on a single core of an x86 machine, and in 0.2 seconds on the graphics card. Some companies are releasing commercial code, such as swaption volatility calculations, as libraries that use GPUs under the covers.

<i class="far fa-hand-point-right"></i> [nvidia.com/object/cuda_home.html](http://www.nvidia.com/object/cuda_home.html) 

(Based on a k4 post by Niall 2008.09.13)

