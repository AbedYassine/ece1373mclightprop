/*
 * This file runs the main algorithm
 *
 * @author: Abed Yassine
 * @date_created: April 13th, 2017
 */

//#include "tinymt32.h"
#include "my_tinymt32.h"
#include "mc_data_structures.h"
#include <fstream> // USED for debugging

using namespace std;

void mc_core(HLS_simulator* sim1, unsigned int num_packets, unsigned int mesh_size,
		Light_source source, float_used cube_length,
		material materials[MAX_NUM_MATERIALS],
		uint6t material_index[MAX_DATA_SIZE + 1],
		unsigned int x_dim, unsigned int y_dim, unsigned int z_dim,
		float_used x_min, float_used y_min, float_used z_min,
		unsigned int seed);

void mc_light_prop(	float_used materials_array[MAX_NUM_MATERIALS*4],
					float_used absorption[MAX_DATA_SIZE+1],
					unsigned int material_index[MAX_DATA_SIZE + 1],
					const float_used source_x, const float_used source_y, const float_used source_z,
					const float_used cubeLength, const float_used xmin, const float_used ymin, const float_used zmin,
					const unsigned int dimx, const unsigned int dimy, const unsigned int dimz,
					const unsigned int seed, unsigned int actual_mesh_size
		)
{
#pragma HLS INTERFACE s_axilite port=return
#pragma HLS INTERFACE s_axilite port=seed
#pragma HLS INTERFACE s_axilite port=actual_mesh_size
#pragma HLS INTERFACE s_axilite port=dimz
#pragma HLS INTERFACE s_axilite port=dimy
#pragma HLS INTERFACE s_axilite port=dimx
#pragma HLS INTERFACE s_axilite port=zmin
#pragma HLS INTERFACE s_axilite port=ymin
#pragma HLS INTERFACE s_axilite port=xmin
#pragma HLS INTERFACE s_axilite port=cubeLength
#pragma HLS INTERFACE s_axilite port=source_z
#pragma HLS INTERFACE s_axilite port=source_y
#pragma HLS INTERFACE s_axilite port=source_x
#pragma HLS INTERFACE bram port=material_index name=material_index_bram
#pragma HLS INTERFACE bram port=absorption name=absorption_bram
#pragma HLS INTERFACE bram port=materials_array name=materials_array
#pragma HLS DATAFLOW
#pragma HLS RESOURCE variable=materials_array core=RAM_1P_BRAM
#pragma HLS RESOURCE variable=absorption core=RAM_1P_BRAM
#pragma HLS RESOURCE variable=material_index core=RAM_1P_BRAM
#pragma HLS ARRAY_PARTITION variable=materials_array cyclic factor=4 dim=1
#pragma HLS ARRAY_PARTITION variable=material_index cyclic factor=8 dim=1
#pragma HLS ARRAY_PARTITION variable=absorption cyclic factor=8 dim=1

	material materials[MAX_NUM_MATERIALS];
#pragma HLS RESOURCE variable=materials core=RAM_T2P_BRAM

	unsigned int index = 0;
	INIT_MAT: for (int i = 0; i < MAX_NUM_MATERIALS*4; i+=4)
	{
		#pragma HLS PIPELINE
		float_used mu_a = materials_array[i];
		float_used mu_s = materials_array[i+1];
		float_used g = materials_array[i+2];
		float_used n = materials_array[i+3];
		materials[index].mu_a = mu_a;
		materials[index].mu_s = mu_s;
		materials[index].g = g;
		materials[index].n = n;
		materials[index].n_inv = 1/n;
		materials[index].albedo = mu_s/(mu_s + mu_a);
		materials[index].mfp = mu_s + mu_a;
		materials[index].mfp_inv = 1/(mu_s + mu_a);

#ifdef VERBOSE
		std::cout<<materials[index].mu_a<<std::endl;
#endif
		index++;
	}

	uint6t mat_idx[MAX_DATA_SIZE+1];
#pragma HLS ARRAY_PARTITION variable=mat_idx cyclic factor=8 dim=1
	INIT_MAT_IDX: for (unsigned int i = 0; i < MAX_DATA_SIZE+1; i+=UNROLL_SIZE)
	{
#pragma HLS PIPELINE
	    if (i > actual_mesh_size + 1)
	        break;
		INIT_IDX_UNROLL: for (unsigned int j = 0; j < UNROLL_SIZE; j++)
		{
#pragma HLS UNROLL
			mat_idx[i+j] = material_index[i+j] & UINT6_MASK;

			//if (i+j < 11)
				//cout << mat_idx[i+j] << endl;
		}
	}

	//*
	unsigned int x_dim = dimx, y_dim = dimy, z_dim = dimz;
	float_used cube_length = cubeLength;
	float_used x_min = xmin, y_min = ymin, z_min = zmin;

	Point source_pos;

	source_pos.xcoord = source_x;
	source_pos.ycoord = source_y;
	source_pos.zcoord = source_z;

	unsigned int rand_seed = seed;
	// */
	
	if( source_pos.xcoord > x_dim*cube_length + xmin||
		source_pos.ycoord > y_dim*cube_length + ymin||
		source_pos.zcoord > z_dim*cube_length + zmin||
		source_pos.xcoord < x_min || source_pos.ycoord < y_min || source_pos.zcoord < z_min)
	{
		cout<<"Source position is out of bounds"<<endl;
		exit(0);
	}
	
	INIT_TEMP_ABSORB: for (unsigned i = 0; i < MAX_DATA_SIZE + 1; i+=UNROLL_SIZE)
	{
#pragma HLS PIPELINE
	    if (i > actual_mesh_size + 1)
	        break;

	    TAB_UNROLL: for (unsigned k = 0; k < UNROLL_SIZE; k++)
		{
#pragma HLS UNROLL
			absorption[i+k] = 0.0f;
		}
	}

	Light_source source;
	source.init_light_source(source_pos, 4);

	unsigned int num_packets = MAX_NUM_PACKETS;
	unsigned int mesh_size = actual_mesh_size;

	HLS_simulator sim;
#pragma HLS ARRAY_PARTITION variable=sim._random_generator.status complete dim=1
#pragma HLS ARRAY_PARTITION variable=sim._random_generator_hop.status complete dim=1
#pragma HLS ARRAY_PARTITION variable=sim._random_generator_drop.status complete dim=1
#pragma HLS ARRAY_PARTITION variable=sim._random_generator_spin.status complete dim=1
#pragma HLS RESOURCE variable=sim._material_index core=RAM_T2P_BRAM
#pragma HLS ARRAY_PARTITION variable=sim._material_index cyclic factor=8 dim=1
#pragma HLS ARRAY_PARTITION variable=sim._absorption complete dim=1
#pragma HLS ARRAY_PARTITION variable=sim._absorption cyclic factor=8 dim=2



		mc_core(&sim, num_packets, mesh_size, source,
				cube_length, materials, mat_idx, x_dim, y_dim, z_dim, x_min, y_min, z_min, rand_seed);

	// Partially unrolled
	//float_used cores_abs[NUM_OF_CORES][MAX_DATA_SIZE+1];
	CORES_ABS_LOOP: for(unsigned int j = 0; j < MAX_DATA_SIZE+1; j+=8)
	{
#pragma HLS PIPELINE// factor=2
	    if (j > actual_mesh_size + 1)
	        break;
		ABS_LOOP: for ( int i = 0; i < 8; i++)
		{
#pragma HLS UNROLL
			ACC_LOOP: for (unsigned int k = 0; k < BUFFER_SIZE; k++)
			{
			//#pragma HLS UNROLL
				absorption[i+j] += sim._absorption[k][i+j];

			}
		}
	}
}

void mc_core(HLS_simulator* sim1, unsigned int num_packets, unsigned int mesh_size,
		Light_source source, float_used cube_length,
		material materials[MAX_NUM_MATERIALS],
		uint6t material_index[MAX_DATA_SIZE + 1],
		unsigned int x_dim, unsigned int y_dim, unsigned int z_dim,
		float_used x_min, float_used y_min, float_used z_min,
		unsigned int seed)
{
#pragma HLS INLINE
	sim1->init_hls_simulator(num_packets, mesh_size, source,
			cube_length, materials, material_index, x_dim, y_dim, z_dim, x_min, y_min, z_min, seed);


	LAUNCH1: for (unsigned int i = 0; i < NUM_PACKETS_LAUNCH; i++)
	{
	#pragma HLS PIPELINE

			Photon ph = sim1->launch(i);
			sim1->photons[i] = ph;

	}

	unsigned int iter_idx1 = 0;
	Photon ph;
	MC_CORE1: while(iter_idx1 < MAX_NUM_PACKETS/NUM_OF_CORES)
	{
#pragma HLS LOOP_TRIPCOUNT min=1 max=1000

#ifdef VERBOSE
		cout<<" \n terminated photons: "<<iter_idx1<<endl<<endl;
#endif
		PHOTON_LOOP1: for ( int i = 0; i < NUM_PACKETS_LAUNCH; i++)
		{
#pragma HLS PIPELINE II=8

			ph = sim1->launch(i);

			bool res = sim1->HOP( i );
			if (res)
			{
				sim1->terminate();
				sim1->photons[i] = ph;
				iter_idx1++;
			}
			if (sim1->get_photon_i_num_hits(i) >= MAX_NUM_HITS_HOP)
			{
				sim1->set_photon_i_remaining_step(i , 0);
				sim1->SPIN(i);
				if (sim1->DROP(i)){
					sim1->photons[i] = ph;
					iter_idx1++;
				}
				sim1->set_photon_i_num_of_hits(i, 0);
			}
		}
	}

	cout << "Iter index: " << iter_idx1 << endl;
}
