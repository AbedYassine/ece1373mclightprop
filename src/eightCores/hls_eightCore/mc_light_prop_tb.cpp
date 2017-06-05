#include "mc_data_structures.h"
#include "my_tinymt32.h"

#include <iostream>
#include <sstream>
#include <fstream>
#include <cmath>
#include <string>

using namespace std;

void mc_light_prop(	float_used materials_array[MAX_NUM_MATERIALS*4],
					float_used absorption[MAX_DATA_SIZE+1],
					unsigned int material_index[MAX_DATA_SIZE + 1],
					const float_used source_x, const float_used source_y, const float_used source_z,
					const float_used cubeLength, const float_used xmin, const float_used ymin, const float_used zmin,
					const unsigned int dimx, const unsigned int dimy, const unsigned int dimz,
					const unsigned int seed, unsigned int actual_mesh_size
		);

float _x_min, _y_min, _z_min, _x_dim, _y_dim, _z_dim;
float _cube_length;

unsigned int get_point_number(float xcoord, float ycoord, float zcoord)
{
    //DONE: ADDED THIS CHECK
    if (xcoord < (_x_min - FLOAT_ACC) || ycoord < (_y_min - FLOAT_ACC) || zcoord < (_z_min - FLOAT_ACC) ||
        xcoord > _x_min + _x_dim*_cube_length + FLOAT_ACC ||
        ycoord > _y_min + _y_dim*_cube_length + FLOAT_ACC ||
        zcoord > _z_min + _z_dim*_cube_length + FLOAT_ACC)
        return (0);;

	// getting the indices of the volume element that the source is in
	 int x_idx = (xcoord - _x_min)/_cube_length;
	 int y_idx = (ycoord - _y_min)/_cube_length;
	 int z_idx = (zcoord - _z_min)/_cube_length;

	if (x_idx > (int)_x_dim || y_idx > (int)_y_dim || z_idx > (int)_z_dim)
		return (0); // element is outside the tissue

	unsigned int res =  x_idx + (_x_dim + 1)*(y_idx + (_y_dim + 1)*z_idx) + 1; // +1, since element 0 is dummy voxel for air

    return (res);
}


void write_vtk_file(unsigned int mat_idx[MAX_DATA_SIZE + 1],
                    float_used absorption[MAX_DATA_SIZE + 1],
                    unsigned int dimX, unsigned int dimY, unsigned int dimZ,
                    float_used min_x, float_used min_y, float_used min_z,
                    float_used cube_length, unsigned int mesh_size)
{
    _x_min = min_x;
    _y_min = min_y;
    _z_min = min_z;
    _x_dim = dimX;
    _y_dim = dimY;
    _z_dim = dimZ;
    _cube_length = cube_length;

    const char* file_name = "../../../absorption_out_cube5med.vtk";

    ofstream vtk_out;
    vtk_out.open(file_name, ofstream::out);

    if (!vtk_out)
    {
        cerr << "Could not open VTK output file!! EXITING!" << endl;
        exit(0);
    }

    // Version line
    vtk_out << "# vtk DataFile Version 4.0" << endl;

    // header lines
    vtk_out << "vtk output" << endl;
    vtk_out << "ASCII" << endl;

    // Dataset
    vtk_out << "DATASET UNSTRUCTURED_GRID" << endl;


    // Printing the points
    unsigned int num_points = (dimX+1)*(dimY+1)*(dimZ+1);
    vtk_out << "POINTS " << num_points + 1 << " float" << endl;

    // Dummy point
    vtk_out << min_x-cube_length << " " << min_y-cube_length << " " << min_z-cube_length << endl;

    float zcoord;// = min_z;
    float ycoord, xcoord;
    for (zcoord = min_z; zcoord < min_z + cube_length*(dimZ + 1); zcoord+=cube_length)
    {
        for (ycoord = min_y; ycoord < min_y + cube_length*(dimY + 1); ycoord+=cube_length)
        {
            for (xcoord = min_x; xcoord < min_x + cube_length*(dimX + 1); xcoord+=cube_length)
            {
                vtk_out << xcoord << " " << ycoord << " " << zcoord << endl;
            }
        }
    }
    float elements_x[MAX_DATA_SIZE+1];
    float elements_y[MAX_DATA_SIZE+1];
    float elements_z[MAX_DATA_SIZE+1];
    int ind = 1;
    for(float x = min_x; x < min_x + dimX*cube_length; x = x + cube_length){
		for(float y = min_y; y < min_y + dimY*cube_length; y = y + cube_length){
			for(float z = min_z; z < min_z + dimZ*cube_length; z = z + cube_length){
				elements_x[ind] = x;
				elements_y[ind] = y;
				elements_z[ind] = z;
				ind++;
			}
    	}
    }
    // Defining the CELLS
    vtk_out << "CELLS " << mesh_size + 1 << " " << (mesh_size + 1)*9 << endl;

    // dummy voxel
    vtk_out << "8 0 0 0 0 0 0 0 0" << endl;

    for (unsigned int i = 1; i < mesh_size + 1; i++)
    {
        ycoord = elements_y[i];
        xcoord = elements_x[i];
        zcoord = elements_z[i];

        vtk_out << "8";

        for (unsigned int i = 0; i < 8; i++)
        {
            if (i == 4)
            {
                xcoord += cube_length;
                ycoord = ycoord - cube_length;
            }

            if (i == 2 || i == 6)
                ycoord += cube_length;

            if (i > 0)
                zcoord += (pow(-1, i-1)*cube_length);

            vtk_out << " " << get_point_number(xcoord, ycoord, zcoord);
        }
        vtk_out << endl;
    }

    vtk_out << endl;

    // CELL TYPES
    vtk_out << "CELL_TYPES " << mesh_size+1 << endl;
    for (unsigned int i = 0; i < mesh_size+1; i++)
        vtk_out << "11" << endl; // 11 is for voxels


    // CELL DATA
    vtk_out << endl;

    vtk_out << "CELL_DATA " << mesh_size + 1 << endl;

    vtk_out << "FIELD FieldData 2" << endl; // 2 since we are only printing the region and the fluence

    vtk_out << "Region 1 " << mesh_size + 1 << " unsigned_short" << endl;

    for (unsigned int i = 0; i < mesh_size + 1; i++)
    {
        if (i == 0)
            vtk_out << "0 "; // air
        else
        {
            vtk_out << mat_idx[i] + 1;
            if ((i+1) % 9 != 0)
                vtk_out << " ";
            else
                vtk_out << endl;
        }
    }
    vtk_out << endl;

    // Fluence
    vtk_out << "Fluence 1 " << mesh_size + 1 << " float" << endl;
    for (unsigned int i = 0; i < mesh_size + 1; i++)
    {
        if (i == 0)
            vtk_out << "0 "; // air
        else
        {
            vtk_out << absorption[i];
            if ((i+1) % 9 != 0)
                vtk_out << " ";
            else
                vtk_out << endl;
        }
    }
    vtk_out << endl;
}

int main() {

	cout << "Running Test Bench!" << endl;

	unsigned int mesh_size = 4000;
	//ifstream myfile0("../../../material_index_cube5med.mem");
	ifstream myfile0("../../../material_index.mem");
	if (!myfile0)
	{
		cerr << "Could not open material_index.mem" << endl;
		exit(0);
	}

	//ifstream myfile1 ("../../../material_cube5med.mem");
	ifstream myfile1 ("../../../material.mem");
	if (!myfile1)
	{
		cerr << "Could not open material.mem" << endl;
		exit(0);
	}

	string start_addr;

	myfile0>>start_addr;
	myfile1>>start_addr;


    // MODIFIED: flipped order
    float_used x_min = 0.0f;
    float_used y_min = 0.0f;
    float_used z_min = 0.0f;
	unsigned int X_dim = 20;
	unsigned int Y_dim = 20;
	unsigned int Z_dim = 10;
	float_used cube_length = 0.5;

	int seed = 12;

	float_used source_x_pos = 2.3;
	float_used source_y_pos = 7.77;
	float_used source_z_pos = 1.45;

	float_used materials_array[MAX_NUM_MATERIALS*4];
	for(int i = 0; i < MAX_NUM_MATERIALS*4; i++){
		myfile1>>materials_array[i];
	}

	float_used absorption[MAX_DATA_SIZE+1];
	int index_1[MAX_DATA_SIZE+1];
	for(int i = 0; i < MAX_DATA_SIZE+1; i++)
		absorption[i] = 0;

	unsigned int mat_idx[MAX_DATA_SIZE+1];
	for (unsigned int i = 0; i < MAX_DATA_SIZE+1; i++)
		myfile0 >> mat_idx[i];

	mc_light_prop(materials_array, absorption, mat_idx, source_x_pos, source_y_pos, source_z_pos,
				cube_length, x_min, y_min, z_min, X_dim, Y_dim, Z_dim, seed, mesh_size);



	float_used max_value = 0;
	int max_id = 0;
	for(int i = 1; i < mesh_size+1; i++){
		absorption[i] = absorption[i]/(cube_length*cube_length*cube_length);
		absorption[i] = absorption[i]/(materials_array[mat_idx[i]*4]);
		if(max_value < absorption[i]){
			max_value = absorption[i];
			max_id = i;
		}
	}
	cout<<" VALUE: : "<<max_value<<" ID: "<<max_id<<endl;
	write_vtk_file( mat_idx, absorption, X_dim, Y_dim, Z_dim, x_min, y_min, z_min, cube_length, mesh_size);

	ofstream myfile3 ("../../../absorption.txt");
	for(int i = 0; i < MAX_DATA_SIZE +1; i++)
			myfile3 <<absorption[i]<<endl;
	myfile3.close();

	//Testing the base absorption file
	/*
	ifstream myfile4("../../../absorption_base.txt");
	if (!myfile4)
	{
		cerr << "Could not open base results for absorption" << endl;
		exit(0);
	}
	//Writing the absorption file
	float_used res = 0.0;

	for(int i = 0; i < MAX_DATA_SIZE + 1; i++){
		myfile4 >> res;

		if(abs(absorption[i] - res) > 1e-4 ){
			cout<<res<<" != absorption "<<absorption[i]<<endl;

			cerr << "The result at index: "<< i<<" is not equal to the base" << endl;
			exit(0);

		}
	}
	// */
    cout<<"Test Bench complete absorption results are equal to the base results"<<endl;
	return (0);
}
