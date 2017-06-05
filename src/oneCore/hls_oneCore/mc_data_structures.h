/*
 * This file contains the definitions of all the data structures used
 * in the MC simulations for light propagation in turbid media project
 *
 * \file mc_data_structures.h
 * \brief Data structures definitions
 *
 * 	@author: Abed Yassine
 * 	@data_created: April 6th, 2017
 */

#ifndef _MC_LIGHT_H_
#define _MC_LIGHT_H_

//#include "tinymt32.h"
#include "my_tinymt32.h"

#include <iostream>
#include <vector>
#include <sstream>
#include <cmath>
#include <cstdlib>
#include "ap_int.h"

#define MAX_NUM_HITS_HOP 10
#define MAX_NUM_PHOTONS_PER_PACKET 10000
#define ROULETTE_W_MIN 0.00001f
#define ROULETTE_PR_WIN 0.0625f
#define ROULETTE_SCALE 16
#define NUM_PACKETS_LAUNCH 1000
#define MAX_NUM_PACKETS 1000000
#define NUM_OF_CORES 1

#define MAX_FLOAT_USED 1e19
#define MIN_FLOAT_USED -1e19
#define FLOAT_ACC 0.00000001f

#define NUM_LOGS_USED 8192
#define LOG_MASK 0x00001fff

//Values used for spin
#define COSZERO 0.99999f // DONE
#define PI 3.14159265359f

#define MAX_DATA_SIZE 8000
#define MAX_NUM_MATERIALS 32

#define BUFFER_SIZE 2
#define BUFFER_MASK 0x01

typedef float float_used; // This is used in case we decided later to
				// switch to fixed_point, then we only need to change this
typedef ap_uint<6> uint6t;
//typedef unsigned int uint6t;
#define UINT6_MASK 0x3f

#define NUM_TO_ADD_UNION 0x00800000

#define UNROLL_SIZE 4

//#define VERBOSE

typedef union {
	float_used f;
	int ui;
} ftoi_union;

class HLS_simulator; // This class is the top level class
class Photon; // this class represents a photon packet
class Volume_element;
class Light_source;

struct Point // stores the 3D coordinates of the point
{
	float_used xcoord;
	float_used ycoord;
	float_used zcoord;
};

struct dir_point // This struct stores the direction of the photon
{
	float_used x_dir;
	float_used y_dir;
	float_used z_dir;
};

struct material // this struct stores mu_a, mu_s, g and n for a certain material
{
	float_used 	mu_a; // absorption coefficient (1/cm, 1/mm, ...)
	float_used 	mu_s; // scattering coefficient (1/cm, 1/mm, ...)
	float_used 	n; // refraction index
	float_used  n_inv;
	float_used 	g; // anisotropy
	float_used  albedo; // equal to mu_a/mu_a+mu_t
	float_used  mfp; // transport mean free path
	float_used  mfp_inv;
};

class Volume_element // right now, this is implemented as a voxel
{
public:
	void init_volume_element (float_used x_coord, float_used y_coord, float_used z_coord,
			unsigned int idx, uint6t mat_idx, float_used cube_length)
	{
		_x_coord = x_coord;
		_y_coord = y_coord;
		_z_coord = z_coord;

		_xcoord_max = x_coord + cube_length;
		_ycoord_max = y_coord + cube_length;
		_zcoord_max = z_coord + cube_length;

		_index = idx;
		_material_index = mat_idx;
	}

	// Getters
	float_used get_xcoord() { return _x_coord; }
	float_used get_ycoord() { return _y_coord; }
	float_used get_zcoord() { return _z_coord; }
	float_used get_xcoord_max() { return _xcoord_max; }
	float_used get_ycoord_max() { return _ycoord_max; }
	float_used get_zcoord_max() { return _zcoord_max; }
	unsigned int get_index() const { return _index; }
	unsigned int get_material_index() const { return _material_index; }

	// Setters
	void set_x_coord(float_used xcoord) {
		_x_coord = xcoord;
	}
	void set_y_coord(float_used ycoord) {
		_y_coord = ycoord;
	}
	void set_z_coord(float_used zcoord) {
		_z_coord = zcoord;
	}
	void set_x_coord_max(float_used xcoord) {
		_x_coord = xcoord;
	}
	void set_y_coord_max(float_used ycoord) {
		_y_coord = ycoord;
	}
	void set_z_coord_max(float_used zcoord) {
		_z_coord = zcoord;
	}
	void set_index(unsigned int index) {
		_index = index;
	}
	void set_material_index(unsigned int materialIndex) {
		_material_index = materialIndex;
	}

private:
	// From CUBE_LENGTH, we can get rest of the coords
	float_used _x_coord; // stores x_min
	float_used _y_coord; // stores y_min
	float_used _z_coord; // stores z_min

	// For optimization
	float_used _xcoord_max;
	float_used _ycoord_max;
	float_used _zcoord_max;

	uint6t		_material_index;

	unsigned int 		_index;
};

class Photon
{
public:
	void init_photon(float_used xcoord, float_used ycoord,
			float_used zcoord, float_used dir_x,
			float_used dir_y, float_used dir_z,
			Volume_element c_elem,
			unsigned int num_photons = MAX_NUM_PHOTONS_PER_PACKET,
			float_used weight = 0)
	{
		//_coordinate = new Point;
		_coordinate.xcoord = xcoord;
		_coordinate.ycoord = ycoord;
		_coordinate.zcoord = zcoord;

		//_direction = new dir_point;
		_direction.x_dir = dir_x;
		_direction.y_dir = dir_y;
		_direction.z_dir = dir_z;

		_weight = weight;

		_current_element = c_elem;

		_remaining_step = 0;

		_num_hits = 0;
	}

	// Getters
	Point 			get_coordinate() { return _coordinate; }
	dir_point 			get_direction() { return _direction; }
	Volume_element&  get_current_volume_element() { return _current_element; }
	float_used 		get_weight() { return _weight; }
	float_used		get_remaining_step() { return _remaining_step; }
	unsigned int 	get_num_hits() { return _num_hits; }
	// Setters
	void set_coordinate(Point coordinate) {
		_coordinate = coordinate;
	}

	void set_current_element(Volume_element currentElement) {
		_current_element = currentElement;
	}

	void set_direction(dir_point direction) {
		_direction = direction;
	}

	void set_remaining_step(float_used remainingStep) {
		_remaining_step = remainingStep;
	}

	void set_weight(float_used weight) {
		_weight = weight;
	}

	void set_num_hits(unsigned int num_hits)
	{
		_num_hits = num_hits;
	}

	void increment_num_hits()
	{
		_num_hits++;
	}

private:
	Point _coordinate;
	dir_point _direction; // stores the direction of the photon beam
						// as a point of 3D coordinates of 1's and 0's
	float_used _weight;

	Volume_element _current_element; // stores the volume element that the photon is currently in

	float_used _remaining_step; // used only in the HOP step to check for intersection
	unsigned int _num_hits; // used to see how many interfaces happened
};


class Light_source // assuming all isotropic point sources
{
public:
	//Light_source
	void init_light_source(Point position, float_used power)
	{
		_position = position;
		_power = power;
	}

	// Getters
	Point get_position() const { return (_position); }
	float_used get_power() const { return (_power); }

	// Setters
	void set_position(Point position) {
		_position = position;
	}
	void set_power(float_used power) {
		_power = power;
	}

private:
	Point 		_position;
	float_used  _power;
};

class HLS_simulator
{
public:

	void init_log_array();

	void init_hls_simulator(unsigned int num_packets, unsigned int mesh_size,
				Light_source source, float_used cube_length,
				material materials[MAX_NUM_MATERIALS],
				uint6t material_index[MAX_DATA_SIZE + 1],
				unsigned int x_dim, unsigned int y_dim, unsigned int z_dim,
				float_used x_min, float_used y_min, float_used z_min,
				unsigned int seed = 12)
	{
#pragma HLS INLINE
		_num_photon_packets = num_packets;
		_mesh_size = mesh_size;

		_source = source;

		_cube_length = cube_length;
		_cube_length_inv = 1.0f/cube_length;

		_random_generator.mat1 = 2141;
		_random_generator.mat2 = 122;
		_random_generator.tmat = 231;
		_random_generator.tinymt32_init(seed);

		_random_generator_hop.mat1 = 5472;
		_random_generator_hop.mat2 = 1616;
		_random_generator_hop.tmat = 15346;
		_random_generator_hop.tinymt32_init(10*seed);

		_random_generator_interface.mat1 = 2145672;
		_random_generator_interface.mat2 = 46311;
		_random_generator_interface.tmat = 1641431;
		_random_generator_interface.tinymt32_init(1252*seed);

		_random_generator_drop.mat1 = 2445;
		_random_generator_drop.mat2 = 1263;
		_random_generator_drop.tmat = 566;
		_random_generator_drop.tinymt32_init(100*seed);

		_random_generator_spin.mat1 = 7746;
		_random_generator_spin.mat2 = 1788;
		_random_generator_spin.tmat = 221;
		_random_generator_spin.tinymt32_init(1000*seed);



		//_list_of_materials = materials;
		INIT_MAT: for (unsigned int i = 0; i < MAX_NUM_MATERIALS; i++)
		{
#pragma HLS PIPELINE
			_list_of_materials[i] = materials[i];
		}

		INIT_ELEM_ABSORB: for (unsigned int i = 0; i < MAX_DATA_SIZE+1; i+=UNROLL_SIZE)
		{
#pragma HLS PIPELINE
		    if (i > mesh_size + 1)
		        break;

			IEA: for (unsigned int k = 0; k < UNROLL_SIZE; k++)
			{
#pragma HLS UNROLL
				INIT_ABS_BUFF: for (unsigned int j = 0; j < BUFFER_SIZE; j++)
				{
#pragma HLS UNROLL
					_absorption[j][i+k] = 0;
				}
				_material_index[i+k] = material_index[i+k];
			}
		}

		init_log_array();

		_x_DIM = x_dim;
		_y_DIM = y_dim;
		_z_DIM = z_dim;
		_y_z_DIM = y_dim*z_dim;

		_x_min = x_min;
		_y_min = y_min;
		_z_min = z_min;

		_x_max = x_dim*cube_length + x_min;
		_y_max = y_dim*cube_length + y_min;
		_z_max = z_dim*cube_length + z_min;

		_num_terminated = 0;

	}

	// Main methods of the pipeline
	Photon launch(int i_photon);
	bool HOP( int i_photon);
	bool check_intersection(Volume_element* curr_element,
				Point* new_pos);
	void interface(int i_photon, Volume_element new_elem, short inter_dir);
	float_used get_albedo(int i_photon);
	bool russian_roulette(int i_photon);
	bool DROP(int i_photon);
	float_used spintheta(float_used g);
	void SPIN(int i_photon);
	void terminate();
	void set_photon_i_num_of_hits(int i_photon, int value);
	void set_photon_i_remaining_step(int i_photon, int value);
	// Getters
	unsigned int get_mesh_size() const { return (_mesh_size); }
	unsigned int get_num_photon_packets() const { return (_num_photon_packets); }
	float_used get_cube_length() const { return (_cube_length); }
	unsigned int get_photon_i_num_hits(int i_photon);

	// Setters
	void add_absorption(float_used value, unsigned int idx, unsigned int photon_idx)
	{
#pragma HLS INLINE
		if (idx >= _mesh_size + 1 || idx == 0)
		{
			std::cerr << "HLS_simulator::add_absorption::Index" <<
					" is out of bound!!! " << idx << std::endl;

			std::cerr << "NUM_hits " << photons[photon_idx].get_num_hits() << std::endl;
			std::exit(0);
		}

		_absorption[photon_idx & BUFFER_MASK][idx] += value;
	}

	void set_absorption(float_used absorption[MAX_DATA_SIZE+1]) {
		SET_ABS: for (unsigned int i = 0; i < MAX_DATA_SIZE +1; i++)
		{
		    if (i > _mesh_size + 1)
		        break;

			SET_ABS1: for (unsigned int j = 0; j < BUFFER_SIZE; j++)
				_absorption[j][i] = absorption[i];
		}
	}

	void set_mesh_size(unsigned int meshSize) {
		_mesh_size = meshSize;
	}

	void set_num_photon_packets(unsigned int numPhotonPackets) {
		_num_photon_packets = numPhotonPackets;
	}

	void set_cube_length(float_used cubeLength) {
		_cube_length = cubeLength;
	}

	unsigned int get_num_terminated() { return _num_terminated; }

	float_used 				_absorption[BUFFER_SIZE][MAX_DATA_SIZE +1];
	uint6t 					_material_index[MAX_DATA_SIZE + 1];

	my_tinymt32_t			_random_generator; // for launch
    my_tinymt32_t			_random_generator_hop;
    my_tinymt32_t			_random_generator_interface;
    my_tinymt32_t			_random_generator_drop;
    my_tinymt32_t			_random_generator_spin;

    Photon 					photons[NUM_PACKETS_LAUNCH];


private:
	// Helper methods
	Volume_element get_voxel_index(Point p); // returns the voxel index that the point is in
	unsigned int msb(unsigned int num);
	float_used num_minus_1(ftoi_union ff);
	bool float_a_less_b(float_used a, float_used b);
	int get_int_from_float(float a);


	// Data should be on the DDR4, so we won't add a list of
	// all the voxels in this class. Whenever we need data, we
	// read directly from the DDR

	unsigned int 			_num_photon_packets;
	unsigned int 			_mesh_size;

	 // This vector stores
		// the total absorption in each voxel element
		// Microblaze will eventually read all the _absorption lists from
		// all the independent kernels, and accumulate them and get the average

	Light_source 			_source;


	float_used 				_cube_length;
	float_used				_cube_length_inv;

	material 				_list_of_materials[MAX_NUM_MATERIALS];



	unsigned int 			_x_DIM; // number of voxel rows in x Dimension
	unsigned int 			_y_DIM; // number of voxel columns in y Dimension
	unsigned int 			_z_DIM; // number of voxel depth in z Dimension
	unsigned int			_y_z_DIM; // z_dim*y_dim

	float_used 				_x_min; // minimum x_coordinate of the tissue
	float_used				_y_min; // minimum y_coordinate of the tissue
	float_used 				_z_min; // minimum z_coordinate of the tissue


	// for optimization
	float_used 				_x_max;
	float_used				_y_max;
	float_used				_z_max;

	float_used 				_log_array[NUM_LOGS_USED];
	unsigned int			_num_terminated; //
};



#endif
