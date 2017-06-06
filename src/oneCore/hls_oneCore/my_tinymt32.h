/*
Copyright (c) 2011, 2013 Mutsuo Saito, Makoto Matsumoto,
Hiroshima University and The University of Tokyo.
*/

#ifndef _MYTINYMT32_H_
#define _MYTINYMT32_H_

//#include "hls_stream.h"
#include <cmath>

#define MY_TINYMT32_MEXP 127
#define MY_TINYMT32_SH0 1
#define MY_TINYMT32_SH1 10
#define MY_TINYMT32_SH8 8
#define MY_TINYMT32_MASK 0x7fffffff
#define MY_TINYMT32_MUL (1.0f / 16777216.0f)

#define MIN_LOOP 8
#define PRE_LOOP 8


/*typedef union {
	float f;
	int ui;
} ftoi_un;
*/
/**
 * tinymt32 internal state vector and parameters
 */
class my_tinymt32_t
{
public:
    unsigned int status[4];
    unsigned int mat1;
    unsigned int mat2;
    unsigned int tmat;

    my_tinymt32_t()
    {
/*     	mat1 = 0; */
/*     	mat2 = 0; */
/*     	tmat = 0; */
    }

   /**
     * This function represents a function used in the initialization
     * by init_by_array
     * @param x 32-bit integer
     * @return 32-bit integer
     */
    unsigned int ini_func1(unsigned int x) {
#pragma HLS INLINE
        return (x ^ (x >> 27)) * (1664525);
    }

    /**
     * This function represents a function used in the initialization
     * by init_by_array
     * @param x 32-bit integer
     * @return 32-bit integer
     */
    unsigned int ini_func2(unsigned int x) {
#pragma HLS INLINE
        return (x ^ (x >> 27)) * (1566083941);
    }

    /**
     * This function certificate the period of 2^127-1.
     * @param random tinymt state vector.
     */
    void period_certification() 
    {
#pragma HLS INLINE
        if ((status[0] & MY_TINYMT32_MASK) == 0 &&
            status[1] == 0 &&
            status[2] == 0 &&
            status[3] == 0) 
            {
                status[0] = 'T';
                status[1] = 'I';
                status[2] = 'N';
                status[3] = 'Y';
            }
    }
    /**
     * This function initializes the internal state array with a 32-bit
     * unsigned integer seed.
     * @param random tinymt state vector.
     * @param seed a 32-bit unsigned integer used as a seed.
     */
    void tinymt32_init(unsigned int seed) 
    {
#pragma HLS INLINE
        /* #pragma HLS INLINE */
        status[0] = seed;
        status[1] = mat1;
        status[2] = mat2;
        status[3] = tmat;

        TINY_MIN_LOOP: for (int i = 1; i < MIN_LOOP; i++) {
        	status[i & 3] ^= i + (1812433253)
            		* (status[(i - 1) & 3]
					^ (status[(i - 1) & 3] >> 30));
        }
        period_certification();
        TINY_PRE_LOOP: for (int i = 0; i < PRE_LOOP; i++) {
            tinymt32_next_state();
        }
    }


    int tinymt32_get_mexp() {    	return MY_TINYMT32_MEXP; }



    /**
     * This function outputs 32-bit unsigned integer from internal state.
     * @param random tinymt internal status
     * @return 32-bit unsigned integer r (0 <= r < 2^32)
     */
    unsigned int tinymt32_generate_uint32() 
    {
#pragma HLS INLINE
        tinymt32_next_state();
        return tinymt32_temper();
    }

    /**
     * This function outputs floating point number from internal state.
     * This function is implemented using multiplying by (1 / 2^24).
     * floating point multiplication is faster than using union trick in
     * my Intel CPU.
     * @param random tinymt internal status
     * @return floating point number r (0.0 <= r < 1.0)
     */
    float tinymt32_generate_float() 
    {
#pragma HLS INLINE
        tinymt32_next_state();
        return tinymt32_temper_conv();
    }

    /**
     * This function outputs floating point number from internal state.
     * This function may return 1.0 and never returns 0.0.
     * @param random tinymt internal status
     * @return floating point number r (0.0 < r <= 1.0)
     */
    float tinymt32_generate_floatOC() {
#pragma HLS INLINE
        tinymt32_next_state();
        return 1.0f - tinymt32_generate_float();
    }



private:
    /**
     * This function changes internal state of tinymt32.
     * Users should not call this function directly.
     * @param random tinymt internal status
     */
    void tinymt32_next_state() 
    {
#pragma HLS INLINE

        unsigned int x;
        unsigned int y;

        y = status[3];
        x = (status[0] & (unsigned int)MY_TINYMT32_MASK)
        ^ status[1]
        ^ status[2];
        x ^= (x << (unsigned int)MY_TINYMT32_SH0);
        y ^= (y >> (unsigned int)MY_TINYMT32_SH0) ^ x;

    	status[0] = status[1];
		status[1] = status[2] ^ (-((int)(y & 1)) & mat1);
		status[2] = x ^ (y << (unsigned int)MY_TINYMT32_SH1)
				^ (-((int)(y & 1)) & mat2);
		status[3] = y;
    }
    /**
     * This function outputs 32-bit unsigned integer from internal state.
     * Users should not call this function directly.
     * @param random tinymt internal status
     * @return 32-bit unsigned pseudorandom number
     */
    unsigned int tinymt32_temper() 
    {
#pragma HLS INLINE

        unsigned int t0, t1;
        t0 = status[3];
        t1 = status[0]
        + (status[2] >> MY_TINYMT32_SH8);
        t0 ^= t1;
        t0 ^= -((int)(t1 & 1)) & tmat;
        return t0;
    }


    /**
     * This function outputs floating point number from internal state.
     * Users should not call this function directly.
     * @param random tinymt internal status
     * @return floating point number r (1.0 <= r < 2.0)
     */
    float tinymt32_temper_conv()
    {
#pragma HLS INLINE

        unsigned int t0, t1;
        union {
    	unsigned int u;
    	float f;
        }
        conv;

        t0 = status[3];

        t1 = status[0]
    	+ (status[2] >> MY_TINYMT32_SH8);

        t0 ^= t1;
        conv.u = ((t0 ^ (-((int)(t1 & 1)) & tmat)) >> 9)
    	      | 0x3f800000;

		 unsigned int mantissa = conv.u & 0x007fffff;

		 // finding the leading 1 in the mantissa
		 int num_to_shift = msb(mantissa);

		 mantissa = mantissa << num_to_shift;
		 mantissa = mantissa & 0x007fffff;

		 unsigned int exponent = 127 - num_to_shift;


		 conv.u = (exponent << 23) | mantissa;

		 return conv.f;
    }



    unsigned int msb(unsigned int num)
    {
#pragma HLS INLINE
        if (num >= 4194304)
           return 1;
        else if (num >= 2097152)
           return 2;
        else if (num >= 1048576)
           return 3;
        else if (num >= 524288)
           return 4;
        else if (num >= 262144)
           return 5;
        else if (num >= 131072)
           return 6;
        else if (num >= 65536)
           return 7;
        else if (num >= 32768)
           return 8;
        else if (num >= 16384)
           return 9;
        else if (num >= 8192)
           return 10;
        else if (num >= 4096)
           return 11;
        else if (num >= 2048)
           return 12;
        else if (num >= 1024)
           return 13;
        else if (num >= 512)
           return 14;
        else if (num >= 256)
           return 15;
        else if (num >= 128)
           return 16;
        else if (num >= 64)
           return 17;
        else if (num >= 32)
           return 18;
        else if (num >= 16)
        	return 19;
        else if (num >= 8)
           return 20;
        else if (num >= 4)
           return 21;
        else if (num >= 2)
           return 22;
        else if (num >= 1)
           return 23;
        return 0;
    }
};


#endif
