/*
 * main.c
 *
 *  Created on: Jun 1, 2017
 *      Author: savi
 */


/*
 * main.cc
 *
 *  Created on: May 26, 2017
 *      Author: savi
 */


/*
 * Empty C++ Application
 */
#include "bram_init_8K.h"
//#include "bram_init.h"
#include "xil_io.h"
#include <stdio.h>


float final_abs[SIZE];




int main()
{

	init_setup_values(source_x_data_0,  source_y_data_0, source_z_data_0,
				cubelength_data_0 ,xmin_data_0, ymin_data_0 ,zmin_data_0 ,
		 dimx_data_0 , dimy_data_0 , dimz_data_0 ,
			     seed_data_0 ,  mesh_size_data_0, 12 );

	init_setup_values(source_x_data_1,  source_y_data_1, source_z_data_1,
				cubelength_data_1 ,xmin_data_1, ymin_data_1 ,zmin_data_1 ,
		 dimx_data_1 , dimy_data_1 , dimz_data_1 ,
				 seed_data_1 ,  mesh_size_data_1, 105 );

	init_setup_values(source_x_data_2,  source_y_data_2, source_z_data_2,
				cubelength_data_2 ,xmin_data_2, ymin_data_2 ,zmin_data_2 ,
		 dimx_data_2 , dimy_data_2 , dimz_data_2 ,
				 seed_data_2 ,  mesh_size_data_2, 101 );

	init_setup_values(source_x_data_3,  source_y_data_3, source_z_data_3,
				cubelength_data_3 ,xmin_data_3, ymin_data_3 ,zmin_data_3 ,
		 dimx_data_3 , dimy_data_3 , dimz_data_3 ,
				 seed_data_3 ,  mesh_size_data_3, 1000 );

	init_setup_values(source_x_data_4,  source_y_data_4, source_z_data_4,
					cubelength_data_4 ,xmin_data_4, ymin_data_4 ,zmin_data_4 ,
			dimx_data_4 , dimy_data_4 , dimz_data_4 ,
					seed_data_4 ,  mesh_size_data_4, 1 );

	init_setup_values(source_x_data_5,  source_y_data_5, source_z_data_5,
					cubelength_data_5 ,xmin_data_5, ymin_data_5 ,zmin_data_5 ,
			dimx_data_5 , dimy_data_5 , dimz_data_5 ,
					seed_data_5 ,  mesh_size_data_5, 444 );

	init_setup_values(source_x_data_6,  source_y_data_6, source_z_data_6,
					cubelength_data_6 ,xmin_data_6, ymin_data_6 ,zmin_data_6 ,
			dimx_data_6 , dimy_data_6 , dimz_data_6 ,
					seed_data_6 ,  mesh_size_data_6, 666 );

	init_setup_values(source_x_data_7,  source_y_data_7, source_z_data_7,
					cubelength_data_7 ,xmin_data_7, ymin_data_7 ,zmin_data_7 ,
			dimx_data_7 , dimy_data_7 , dimz_data_7 ,
					seed_data_7 ,  mesh_size_data_7, 3416341 );

	//*

	init_mat_idx_0(mat_idx_a);
	init_mat_idx_1(mat_idx_b);
	init_mat_idx_2(mat_idx_c);
	init_mat_idx_3(mat_idx_d);

	init_mat_idx_0(mat_idx_4);
	init_mat_idx_1(mat_idx_5);
	init_mat_idx_2(mat_idx_6);
	init_mat_idx_3(mat_idx_7);

	init_mat_idx_0(mat_idx_8);
	init_mat_idx_1(mat_idx_9);
	init_mat_idx_2(mat_idx_10);
	init_mat_idx_3(mat_idx_11);

	init_mat_idx_0(mat_idx_12);
	init_mat_idx_1(mat_idx_13);
	init_mat_idx_2(mat_idx_14);
	init_mat_idx_3(mat_idx_15);

	///

	init_mat_prop_0(mat_prop_a);
	init_mat_prop_1(mat_prop_b);
	init_mat_prop_2(mat_prop_c);
	init_mat_prop_3(mat_prop_d);

	init_mat_prop_0(mat_prop_4);
	init_mat_prop_1(mat_prop_5);
	init_mat_prop_2(mat_prop_6);
	init_mat_prop_3(mat_prop_7);

	init_mat_prop_0(mat_prop_8);
	init_mat_prop_1(mat_prop_9);
	init_mat_prop_2(mat_prop_10);
	init_mat_prop_3(mat_prop_11);

	init_mat_prop_0(mat_prop_12);
	init_mat_prop_1(mat_prop_13);
	init_mat_prop_2(mat_prop_14);
	init_mat_prop_3(mat_prop_15);
	// */



	*(ctrl_ptr_0) |= 0x01;
	*(ctrl_ptr_1) |= 0x01;
	*(ctrl_ptr_2) |= 0x01;
	*(ctrl_ptr_3) |= 0x01;
	*(ctrl_ptr_4) |= 0x01;
	*(ctrl_ptr_5) |= 0x01;
	*(ctrl_ptr_6) |= 0x01;
	*(ctrl_ptr_7) |= 0x01;


	while(!(*ctrl_ptr_0 & 0x04));
	while(!(*ctrl_ptr_1 & 0x04));
	while(!(*ctrl_ptr_2 & 0x04));
	while(!(*ctrl_ptr_3 & 0x04));
	while(!(*ctrl_ptr_4 & 0x04));
	while(!(*ctrl_ptr_5 & 0x04));
	while(!(*ctrl_ptr_6 & 0x04));
	while(!(*ctrl_ptr_7 & 0x04));


	// converting to fluence
	//*
	float cube_length = *(cubelength_data_0);
	float cube_length_3 = cube_length*cube_length*cube_length;
	int conv_idx = 1;
	for (unsigned int i = 0; i < SIZE; i+=4)
	{
		*(abs0 + (conv_idx)) /= (cube_length_3* (*(mat_prop_a + *(mat_idx_a + (conv_idx)))));
		*(abs1 + (conv_idx-1)) /= (cube_length_3* (*(mat_prop_a + *(mat_idx_b + (conv_idx-1)))));
		*(abs2 + (conv_idx-1)) /= (cube_length_3* (*(mat_prop_a + *(mat_idx_c + (conv_idx-1)))));
		*(abs3 + (conv_idx-1)) /= (cube_length_3* (*(mat_prop_a + *(mat_idx_d + (conv_idx-1)))));

		*(abs4 + (conv_idx)) /= (cube_length_3* (*(mat_prop_a + *(mat_idx_a + (conv_idx)))));
		*(abs5 + (conv_idx-1)) /= (cube_length_3* (*(mat_prop_a + *(mat_idx_b + (conv_idx-1)))));
		*(abs6 + (conv_idx-1)) /= (cube_length_3* (*(mat_prop_a + *(mat_idx_c + (conv_idx-1)))));
		*(abs7 + (conv_idx-1)) /= (cube_length_3* (*(mat_prop_a + *(mat_idx_d + (conv_idx-1)))));

		*(abs8 + (conv_idx)) /= (cube_length_3* (*(mat_prop_a + *(mat_idx_a + (conv_idx)))));
		*(abs9 + (conv_idx-1)) /= (cube_length_3* (*(mat_prop_a + *(mat_idx_b + (conv_idx-1)))));
		*(abs10 + (conv_idx-1)) /= (cube_length_3* (*(mat_prop_a + *(mat_idx_c + (conv_idx-1)))));
		*(abs11 + (conv_idx-1)) /= (cube_length_3* (*(mat_prop_a + *(mat_idx_d + (conv_idx-1)))));

		*(abs12 + (conv_idx)) /= (cube_length_3* (*(mat_prop_a + *(mat_idx_a + (conv_idx)))));
		*(abs13 + (conv_idx-1)) /= (cube_length_3* (*(mat_prop_a + *(mat_idx_b + (conv_idx-1)))));
		*(abs14 + (conv_idx-1)) /= (cube_length_3* (*(mat_prop_a + *(mat_idx_c + (conv_idx-1)))));
		*(abs15 + (conv_idx-1)) /= (cube_length_3* (*(mat_prop_a + *(mat_idx_d + (conv_idx-1)))));

		*(abs16 + (conv_idx)) /= (cube_length_3* (*(mat_prop_a + *(mat_idx_a + (conv_idx)))));
		*(abs17 + (conv_idx-1)) /= (cube_length_3* (*(mat_prop_a + *(mat_idx_b + (conv_idx-1)))));
		*(abs18 + (conv_idx-1)) /= (cube_length_3* (*(mat_prop_a + *(mat_idx_c + (conv_idx-1)))));
		*(abs19 + (conv_idx-1)) /= (cube_length_3* (*(mat_prop_a + *(mat_idx_d + (conv_idx-1)))));

		*(abs20 + (conv_idx)) /= (cube_length_3* (*(mat_prop_a + *(mat_idx_a + (conv_idx)))));
		*(abs21 + (conv_idx-1)) /= (cube_length_3* (*(mat_prop_a + *(mat_idx_b + (conv_idx-1)))));
		*(abs22 + (conv_idx-1)) /= (cube_length_3* (*(mat_prop_a + *(mat_idx_c + (conv_idx-1)))));
		*(abs23 + (conv_idx-1)) /= (cube_length_3* (*(mat_prop_a + *(mat_idx_d + (conv_idx-1)))));

		*(abs24 + (conv_idx)) /= (cube_length_3* (*(mat_prop_a + *(mat_idx_a + (conv_idx)))));
		*(abs25 + (conv_idx-1)) /= (cube_length_3* (*(mat_prop_a + *(mat_idx_b + (conv_idx-1)))));
		*(abs26 + (conv_idx-1)) /= (cube_length_3* (*(mat_prop_a + *(mat_idx_c + (conv_idx-1)))));
		*(abs27 + (conv_idx-1)) /= (cube_length_3* (*(mat_prop_a + *(mat_idx_d + (conv_idx-1)))));

		*(abs28 + (conv_idx)) /= (cube_length_3* (*(mat_prop_a + *(mat_idx_a + (conv_idx)))));
		*(abs29 + (conv_idx-1)) /= (cube_length_3* (*(mat_prop_a + *(mat_idx_b + (conv_idx-1)))));
		*(abs30 + (conv_idx-1)) /= (cube_length_3* (*(mat_prop_a + *(mat_idx_c + (conv_idx-1)))));
		*(abs31 + (conv_idx-1)) /= (cube_length_3* (*(mat_prop_a + *(mat_idx_d + (conv_idx-1)))));


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

		}
	}

	 idx = 0;
		for (unsigned int i = 0; i < PARTIAL; i++)
		{
			final_abs[idx++] += *(abs4 + i);
			if (i < PARTIAL - 1)
			{
			final_abs[idx++] += *(abs5 + i);
			final_abs[idx++] += *(abs6 + i);
			final_abs[idx++] += *(abs7 + i);

			}
		}

		idx = 0;
			for (unsigned int i = 0; i < PARTIAL; i++)
			{
				final_abs[idx++] += *(abs8 + i);
				if (i < PARTIAL - 1)
				{
				final_abs[idx++] += *(abs9 + i);
				final_abs[idx++] += *(abs10 + i);
				final_abs[idx++] += *(abs11 + i);

				}
			}

			 idx = 0;
				for (unsigned int i = 0; i < PARTIAL; i++)
				{
					final_abs[idx++] += *(abs12 + i);
					if (i < PARTIAL - 1)
					{
					final_abs[idx++] += *(abs13 + i);
					final_abs[idx++] += *(abs14 + i);
					final_abs[idx++] += *(abs15 + i);

					}
				}

				 idx = 0;
					for (unsigned int i = 0; i < PARTIAL; i++)
					{
						final_abs[idx++] += *(abs16 + i);
						if (i < PARTIAL - 1)
						{
						final_abs[idx++] += *(abs17 + i);
						final_abs[idx++] += *(abs18 + i);
						final_abs[idx++] += *(abs19 + i);

						}
					}

					 idx = 0;
						for (unsigned int i = 0; i < PARTIAL; i++)
						{
							final_abs[idx++] += *(abs20 + i);
							if (i < PARTIAL - 1)
							{
							final_abs[idx++] += *(abs21 + i);
							final_abs[idx++] += *(abs22 + i);
							final_abs[idx++] += *(abs23 + i);

							}
						}

						 idx = 0;
							for (unsigned int i = 0; i < PARTIAL; i++)
							{
								final_abs[idx++] += *(abs24 + i);
								if (i < PARTIAL - 1)
								{
								final_abs[idx++] += *(abs25 + i);
								final_abs[idx++] += *(abs26 + i);
								final_abs[idx++] += *(abs27 + i);

								}
							}

							 idx = 0;
								for (unsigned int i = 0; i < PARTIAL; i++)
								{
									final_abs[idx++] += *(abs28 + i);
									if (i < PARTIAL - 1)
									{
									final_abs[idx++] += *(abs29 + i);
									final_abs[idx++] += *(abs30 + i);
									final_abs[idx++] += *(abs31 + i);

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
