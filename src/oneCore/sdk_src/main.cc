/*
 * Empty C++ Application
 */
//#include "bram_init.h"
#include "bram_init_8k.h"
#include "xil_io.h"
//#include <stdio.h>


float final_abs[SIZE];

int main()
{

	init_setup_values();
	//*
	init_mat_idx_0();
	init_mat_idx_1();
	init_mat_idx_2();
	init_mat_idx_3();
	init_mat_idx_4();
	init_mat_idx_5();
	init_mat_idx_6();
	init_mat_idx_7();

	init_mat_prop_0();
	init_mat_prop_1();
	init_mat_prop_2();
	init_mat_prop_3();
	// */



	*(ctrl_ptr) |= 0x01;


	while(!(*ctrl_ptr & 0x04));


	// converting to fluence
	//*
	float cube_length = *(cubelength_data);
	float cube_length_3 = cube_length*cube_length*cube_length;
	int conv_idx = 1;
	for (unsigned int i = 0; i < SIZE; i+=8)
	{
		*(abs0 + (conv_idx)) /= (cube_length_3* (*(mat_prop_0 + *(mat_idx_0 + (conv_idx)))));
		*(abs1 + (conv_idx-1)) /= (cube_length_3* (*(mat_prop_0 + *(mat_idx_1 + (conv_idx-1)))));
		*(abs2 + (conv_idx-1)) /= (cube_length_3* (*(mat_prop_0 + *(mat_idx_2 + (conv_idx-1)))));
		*(abs3 + (conv_idx-1)) /= (cube_length_3* (*(mat_prop_0 + *(mat_idx_3 + (conv_idx-1)))));
		*(abs4 + (conv_idx-1)) /= (cube_length_3* (*(mat_prop_0 + *(mat_idx_4 + (conv_idx-1)))));
		*(abs5 + (conv_idx-1)) /= (cube_length_3* (*(mat_prop_0 + *(mat_idx_5 + (conv_idx-1)))));
		*(abs6 + (conv_idx-1)) /= (cube_length_3* (*(mat_prop_0 + *(mat_idx_6 + (conv_idx-1)))));
		*(abs7 + (conv_idx-1)) /= (cube_length_3* (*(mat_prop_0 + *(mat_idx_7 + (conv_idx-1)))));
		conv_idx++;

	}
	// */

	int idx = 0;
	for (unsigned int i = 0; i < PARTIAL; i++)
	{
		final_abs[idx++] = *(abs0 + i);
		if (i < PARTIAL - 1)
		{
		final_abs[idx++] = *(abs1 + i);
		final_abs[idx++] = *(abs2 + i);
		final_abs[idx++] = *(abs3 + i);
		final_abs[idx++] = *(abs4 + i);
		final_abs[idx++] = *(abs5 + i);
		final_abs[idx++] = *(abs6 + i);
		final_abs[idx++] = *(abs7 + i);
		}
	}


	float max_value = 0;
	unsigned int max_idx = 0;

	for (unsigned int i = 0; i < SIZE; i++){
		if (max_value < final_abs[i])
		{
			max_value = final_abs[i];
			max_idx = i;
		}
	}

	//xil_printf("The max value is: %g at index: \n", max_value, max_idx);


	return 0;
}
