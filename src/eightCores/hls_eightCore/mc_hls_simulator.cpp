/*
 * \file mc_hls_simulator.cpp \brief implementation of MC kernel methods
 *
 * This files contains the implementation of the main functions of the MC kernel
 *
 * 	@author: Abed Yassine,
 * 	@author: Omar Ismail
 * 	@date_created: April 6th, 2017
 */

#include "mc_data_structures.h"
#include <cmath>
#include "hls_math.h"

using namespace std;

#ifdef VERBOSE
int iter_num = 0;
#endif

Photon  HLS_simulator::launch(int i_photon)
{
#pragma HLS INLINE
	// generating random initial direction
	ftoi_union rand_z_1, rand_pi_2;
	rand_z_1.f = _random_generator.tinymt32_generate_float();
	rand_pi_2.f = PI*_random_generator.tinymt32_generate_float();

	// Multiplying the random number by 2
	rand_z_1.ui += NUM_TO_ADD_UNION;
	rand_pi_2.ui += NUM_TO_ADD_UNION;

	float_used dir3 = num_minus_1(rand_z_1);
	float_used dir3_sqrt = sqrt(1-dir3*dir3);

	float_used dir1 = dir3_sqrt*cos(rand_pi_2.f);//_cos_array[cos_idx];
	float_used dir2 = dir3_sqrt*sin(rand_pi_2.f);//_sin_array[cos_idx];

#ifdef VERBOSE
	cout<<iter_num<<" direction magnitude after norm: "<< sqrt(dir1*dir1 + dir2*dir2 + dir3*dir3)<<endl;
#endif

	Volume_element element = get_voxel_index(_source.get_position());

	// Initialize a photon packet
	Photon photon;
	photon.init_photon(_source.get_position().xcoord,
			_source.get_position().ycoord, _source.get_position().zcoord,
			dir1, dir2, dir3, element,
			MAX_NUM_PHOTONS_PER_PACKET, _source.get_power());
	return photon;
}

//DONE: changed return type
bool HLS_simulator::HOP(int i_photon)
{
#pragma HLS INLINE
	/*
	 * This method performs the Hop operation of the algorithm
	 * The method starts by generating a random step and moving the photon
	 * to the new position. After that, one of the following applies:
	 * 		1- if the method stays in the same volume element, we go to the drop function
	 * 		2- if the packet crosses the boundary with:
	 * 			a- same refractive index, then we just calculate the
	 * 				remaining step and perform the Hop again
	 * 			b- different refractive index, we perform calculations to accound for
	 * 				the interface (Fresnel reflection and Snell's law)
	 *
	 *		@author: Abed Yassine
	 *		@date_created: April 6th, 2017
	 */

#ifdef VERBOSE
	iter_num++;
	cout<<iter_num<<" HOP "<<endl;
#endif

	dir_point current_dir = photons[i_photon].get_direction();

	float_used dir_x = current_dir.x_dir;
	float_used dir_y = current_dir.y_dir;
	float_used dir_z = current_dir.z_dir;

	float_used dir_x_inv = 1.0f/current_dir.x_dir;
	float_used dir_y_inv = 1.0f/current_dir.y_dir;
	float_used dir_z_inv = 1.0f/current_dir.z_dir;

	Point current_pos = photons[i_photon].get_coordinate();



	float_used ve_xmin = photons[i_photon].get_current_volume_element().get_xcoord();
	float_used ve_ymin = photons[i_photon].get_current_volume_element().get_ycoord();
	float_used ve_zmin = photons[i_photon].get_current_volume_element().get_zcoord();


	float_used ve_xmax = photons[i_photon].get_current_volume_element().get_xcoord_max();
	float_used ve_ymax = photons[i_photon].get_current_volume_element().get_ycoord_max();
	float_used ve_zmax = photons[i_photon].get_current_volume_element().get_zcoord_max();


	float_used mu_t = _list_of_materials[photons[i_photon].get_current_volume_element()
												 .get_material_index()].mfp; // mean free path

	float_used mu_t_inv = _list_of_materials[photons[i_photon].get_current_volume_element()
														 .get_material_index()].mfp_inv; // mean free path inverted

	Point new_pos;
	///float_used rand_num_idx = _random_generator_hop.tinymt32_generate_float();
	unsigned int rand_num_idx = _random_generator_hop.tinymt32_generate_uint32() & LOG_MASK;
	// Computing the distance to the boundary
	float_used distance_to_boundary;

#ifdef VERBOSE
	cout<<iter_num<<" min vol x: "<<ve_xmin<<" y: "<<ve_ymin<<" z: "<<ve_zmin<<endl;
	cout<<iter_num<<" max vol x: "<<ve_xmax<<" y: "<<ve_ymax<<" z: "<<ve_zmax<<endl;
	cout<<iter_num<<" current position x: "<<current_pos.xcoord<<" y: "<<current_pos.ycoord<<" z: "<<current_pos.zcoord<<endl;
#endif

	float_used dx = MAX_FLOAT_USED,
					dy = MAX_FLOAT_USED,
					dz = MAX_FLOAT_USED;

	if (dir_x > FLOAT_ACC)
	{
		dx = (ve_xmax - current_pos.xcoord)*dir_x_inv;
	}
	else if (dir_x < -FLOAT_ACC)
	{
		dx = (ve_xmin - current_pos.xcoord)*dir_x_inv;
	}

	if (dir_y > FLOAT_ACC)
	{
		dy = (ve_ymax - current_pos.ycoord)*dir_y_inv;
	}
	else if (dir_y < -FLOAT_ACC)
	{
		dy = (ve_ymin - current_pos.ycoord)*dir_y_inv;
	}

	if (dir_z > FLOAT_ACC)
	{
		dz = (ve_zmax - current_pos.zcoord)*dir_z_inv;
	}
	else if (dir_z < -FLOAT_ACC)
	{
		dz = (ve_zmin - current_pos.zcoord)*dir_z_inv;
	}

	short temp_dir;
	if (dz <= dx)
	{
		if (dz <= dy)
		{
			distance_to_boundary = dz;
			temp_dir = 2;
		}
		else
		{
			distance_to_boundary = dy;
			temp_dir = 1;
		}
	}
	else
	{
		if (dx <= dy)
		{
			distance_to_boundary = dx;
			temp_dir = 0;
		}
		else
		{
			distance_to_boundary = dy;
			temp_dir = 1;
		}
	}

	// Generate a random step
	float_used step;
	//float_used temp_step = -hls::logf(rand_num_idx);
	float_used temp_step = _log_array[rand_num_idx];
	if (photons[i_photon].get_remaining_step() < FLOAT_ACC)
	{
#ifdef VERBOSE
		cout<<iter_num<< " if\tphoton#: "<<i_photon<<" step:	";
#endif
		step = temp_step;
	}
	else
	{
		step = photons[i_photon].get_remaining_step();///mu_t;
#ifdef VERBOSE
		cout<<iter_num<<" else\tphoton#"<<i_photon<<" step:	";
#endif
	}

	step = step*mu_t_inv;///= mu_t;

#ifdef VERBOSE
	cout <<step<<endl;
#endif

	float_used temp_remaining_step = (step - distance_to_boundary)*mu_t;

	photons[i_photon].set_remaining_step(0);

#ifdef VERBOSE
	cout<<iter_num<<" dx: "<<dx<<" dy: "<<dy<<" dz: "<< dz <<endl;
#endif

	if (step > distance_to_boundary)
	{
#ifdef VERBOSE
		cout<<iter_num<<" dist to boundary: "<<distance_to_boundary<<endl;
#endif
		photons[i_photon].set_remaining_step(temp_remaining_step);
		step = distance_to_boundary;
		photons[i_photon].increment_num_hits();
	}

	new_pos.xcoord = current_pos.xcoord + step*current_dir.x_dir;
	new_pos.ycoord = current_pos.ycoord + step*current_dir.y_dir;
	new_pos.zcoord = current_pos.zcoord + step*current_dir.z_dir;

#ifdef VERBOSE
	cout<<iter_num<<" dir x: "<<dir_x<<" y: "<<dir_y<<" z: "<<dir_z<<endl;
	cout<<iter_num <<" NUM of hits: "<< photons[i_photon].get_num_hits()<<endl;
	cout<<iter_num<<" New position x: "<<new_pos.xcoord<<" y: "<<new_pos.ycoord<<" z: "<<new_pos.zcoord<<endl;
#endif

	ftoi_union xd, yd, zd, temp;

	xd.f = current_dir.x_dir;
	yd.f = current_dir.y_dir;
	zd.f = current_dir.z_dir;

	temp.f = 0.000001f;

	Point voxel_pos;

	float_used x_temp = new_pos.xcoord - temp.f;
	float_used y_temp = new_pos.ycoord - temp.f;
	float_used z_temp = new_pos.zcoord - temp.f;

	if (xd.ui >> 31 == -1)
	{
		voxel_pos.xcoord = x_temp;
	}
	else
		voxel_pos.xcoord = new_pos.xcoord;

	if (yd.ui >> 31 == -1)
	{
		voxel_pos.ycoord = y_temp;
	}
	else
		voxel_pos.ycoord = new_pos.ycoord;

	if (zd.ui >> 31 == -1)
	{
		voxel_pos.zcoord = z_temp;
	}
	else
		voxel_pos.zcoord = new_pos.zcoord;

#ifdef VERBOSE
	cout<<iter_num<<" xd: "<<xd.f<<" yd: "<<yd.f<<" zd: "<<zd.f<<endl;
	cout<<iter_num<<" xd.ui: "<<(xd.ui >> 31)<<" yd.ui: "<<(yd.ui >> 31)<<" zd.ui "<<(zd.ui >> 31)<<endl;
	cout<<iter_num<<" voxel pos x: "<<voxel_pos.xcoord<<" y: "<<voxel_pos.ycoord<<" z: "<<voxel_pos.zcoord<<endl;
	cout<<endl;
#endif

	Volume_element new_element = get_voxel_index(voxel_pos);

	interface(i_photon, new_element, temp_dir);

	if (photons[i_photon].get_current_volume_element().get_index() == 0)
	{
		return (true);
	}

	if (photons[i_photon].get_remaining_step() < FLOAT_ACC)
	{
		photons[i_photon].set_num_hits(MAX_NUM_HITS_HOP);
	}

	photons[i_photon].set_coordinate(new_pos);

	return (false);

}


void HLS_simulator::interface(int i_photon, Volume_element new_elem,
		short inter_dir)
{
#pragma HLS INLINE
	/*
	 * In this function, we first check Snell's law for total internal reflection
	 * And Fresnel's reflection
	 * If not reflected, we transport the photon to the new_element
	 */
	// Snell's Law
#ifdef VERBOSE
	cout<<iter_num<<" INTERFACE "<<endl;
#endif

	float_used ni = _list_of_materials[photons[i_photon].
						get_current_volume_element().get_material_index()].n;
	float_used nt = _list_of_materials[new_elem.get_material_index()].n;

	float_used ni_inv = _list_of_materials[photons[i_photon].
							get_current_volume_element().get_material_index()].n_inv;
	float_used nt_inv = _list_of_materials[new_elem.get_material_index()].n_inv;

	ftoi_union nni, nnt;
	nni.f = ni; nnt.f = nt;

	if (nni.ui == nnt.ui)
	{
		photons[i_photon].set_current_element(new_elem);
		return;
	}

	float_used cos_theta_i= MAX_FLOAT_USED;

	if (inter_dir == 0) // intersection is in x-dir
		cos_theta_i = photons[i_photon].get_direction().x_dir;
	else if (inter_dir == 1) // intersection is in y-dir
		cos_theta_i = photons[i_photon].get_direction().y_dir;
	else
		cos_theta_i = photons[i_photon].get_direction().z_dir;

	ftoi_union cos_theta_i_1;
	cos_theta_i_1.f = cos_theta_i;

	float_used abs_cos_theta_i = abs(cos_theta_i);

	float_used ni_over_nt = ni*nt_inv;///nt;
	float_used nt_over_ni = nt*ni_inv;///ni;
	float_used nt_over_ni_sq = nt_over_ni*nt_over_ni;
	float_used temp_ntni_o_nint = (nt - ni)/(nt + ni);

	float_used sin_theta_i = /*sqrt(*/1 - (cos_theta_i*cos_theta_i);//);//DONE



	ftoi_union cos_theta_t;
	cos_theta_t.f = MAX_FLOAT_USED;// 1 - (sin_theta_t*sin_theta_t);

	float_used sin_theta_t = ni_over_nt*ni_over_nt*sin_theta_i;
	float_used temp_cos_theta_t = sqrt(1 - /*(sin_theta_t * */ sin_theta_t);//); // DONE

	float_used nici = ni*abs_cos_theta_i;//cos_theta_i;
	float_used ntct = nt*temp_cos_theta_t;
	float_used nict = ni*temp_cos_theta_t;
	float_used ntci = nt*abs_cos_theta_i;//cos_theta_i;
	float_used cimct = nici - ntct;
	float_used cipct = nici + ntct;
	float_used nictmntci = nict - ntci;
	float_used nictpntci = nict + ntci;

	float_used nici_o_nici = cimct/cipct;
	float_used nict_o_nict = nictmntci/nictpntci;

	float_used ref_prob; // reflection probability
#ifdef VERBOSE
	cout<<iter_num<<" cos theta i: "<<cos_theta_i<<endl;
#endif
	if (sin_theta_i >= nt_over_ni_sq)
	{
		ref_prob = 1; // total internal reflection
		cos_theta_t.f = 0;
	}
	else // Frensel's Reflection
	{

		if (abs_cos_theta_i > COSZERO)  // normal incidence (cos(theta_i) = 1 ==> theta_i = 0)
		{
			ref_prob = temp_ntni_o_nint;//(nt - ni)/(nt + ni);
			ref_prob *= ref_prob;
			cos_theta_t.f = cos_theta_i;
		}
		else if (abs_cos_theta_i < FLOAT_ACC) // perpendicular incidence
		{
			ref_prob = 1;
			cos_theta_t.f = 0;
		}
		else
		{

			cos_theta_t.f = temp_cos_theta_t; //sqrt(1 - /*(sin_theta_t * */ sin_theta_t);//); // DONE
			cos_theta_t.ui = cos_theta_t.ui | (cos_theta_i_1.ui & 0x80000000);

			ftoi_union ref_un;
			ref_un.f = (nici_o_nici*nici_o_nici + nict_o_nict*nict_o_nict);

			ref_un.ui -= NUM_TO_ADD_UNION;

			ref_prob = ref_un.f;
#ifdef VERBOSE
			cout<<iter_num<<" cos_theta t "<<cos_theta_t.f<<endl;
			cout<<iter_num<<" reflection union: "<<ref_un.f<<endl;
#endif
		}

	}

	float_used rand_num = _random_generator_interface.tinymt32_generate_float();

	dir_point dir = photons[i_photon].get_direction();

#ifdef VERBOSE
	cout<<iter_num<<" reflection probability: "<< ref_prob<<endl;
#endif

	if (rand_num > ref_prob) // no reflection
	{
		photons[i_photon].set_current_element(new_elem);


		if (inter_dir == 0)
		{
			dir.x_dir = cos_theta_t.f;
			dir.y_dir *= ni_over_nt;
			dir.z_dir *= ni_over_nt;
		}
		else if (inter_dir == 1)
		{
			dir.y_dir = cos_theta_t.f;
			dir.x_dir *= ni_over_nt;
			dir.z_dir *= ni_over_nt;

		}
		else
		{
			dir.z_dir = cos_theta_t.f;
			dir.y_dir *= ni_over_nt;
			dir.x_dir *= ni_over_nt;
		}
	}
	else // total reflection
	{
		if (inter_dir == 0)
		{
			dir.x_dir *= -1;
		}
		else if (inter_dir == 1)
		{
			dir.y_dir *= -1;
		}
		else
		{
			dir.z_dir *= -1;
		}
	}
	photons[i_photon].set_direction(dir);
#ifdef VERBOSE
	cout<<iter_num<<" direction interface x: "<<dir.x_dir<<" y: "<<dir.y_dir<<" z: "<<dir.z_dir<<endl;
	cout<<iter_num<<" direction magnitude interface: "<< sqrt(dir.x_dir*dir.x_dir + dir.y_dir*dir.y_dir + dir.z_dir*dir.z_dir)<<endl;
	cout<<endl;
#endif
}

float_used HLS_simulator::get_albedo(int i_photon)
{
#pragma HLS INLINE
	Volume_element ve = photons[i_photon].get_current_volume_element();
	float_used albedo = _list_of_materials[ve.get_material_index()].albedo;//mu_s/(mu_s+mu_a);
	return (albedo);
}

bool HLS_simulator::russian_roulette(int i_photon)
{
#pragma HLS INLINE
	// This section has a RNG 
	float temp1 = _random_generator_drop.tinymt32_generate_float();
	if(temp1 > ROULETTE_PR_WIN){
		return (true);
	}
	else{
		float_used curr_weight = photons[i_photon].get_weight();
		photons[i_photon].set_weight(curr_weight*ROULETTE_SCALE);
		return (false);
	}
}

bool HLS_simulator::DROP(int i_photon)
{
#pragma HLS INLINE
#ifdef VERBOSE
	cout<<iter_num<<" DROP "<<endl;
#endif
	Volume_element ve = photons[i_photon].get_current_volume_element();

	float_used ve_xmin = photons[i_photon].get_current_volume_element().get_xcoord();
	float_used ve_ymin = photons[i_photon].get_current_volume_element().get_ycoord();
	float_used ve_zmin = photons[i_photon].get_current_volume_element().get_zcoord();

	float_used albedo = get_albedo(i_photon);

	float_used new_weight = photons[i_photon].get_weight()*albedo;
	float_used delta_weight = photons[i_photon].get_weight() - new_weight;//photon->get_weight()*(1 - albedo);

	add_absorption(delta_weight, ve.get_index(), i_photon);

#ifdef VERBOSE
	cout<<iter_num<<" absorption added: "<<delta_weight<<endl;
	cout<<iter_num<<" min vol x: "<<ve_xmin<<" y: "<<ve_ymin<<" z: "<<ve_zmin<<endl;
	cout<<iter_num<<" vol index: "<<ve.get_index()<<endl;
	cout<<endl;
#endif

	photons[i_photon].set_weight(new_weight);
	
	if(new_weight < ROULETTE_W_MIN){
		if(russian_roulette(i_photon)){
			terminate();
			return (true);
		}
	}
	return (false);
}

float_used HLS_simulator::spintheta(float_used g)
{
#pragma HLS INLINE
	float_used cost;
	float_used rand_num = _random_generator_spin.tinymt32_generate_float();
	ftoi_union rr;

	rr.f = rand_num;
	rr.ui += NUM_TO_ADD_UNION;

	ftoi_union g_un;
	g_un.f = g;
	g_un.ui += NUM_TO_ADD_UNION;

	float_used g_sq = g*g;
	float_used temp = (1.0f-g_sq)/(1.0f-g + g_un.f*rand_num);

	float_used temp_sq = temp*temp;
	float_used temp_cost = (1.0f+g_sq - temp_sq)/(g_un.f);

	if(g < FLOAT_ACC)
	{
		cost = num_minus_1(rr);
	}
	else
	{
		cost = temp_cost;
	}
	return(cost);

}

void  HLS_simulator::SPIN(int i_photon)
{
#pragma HLS INLINE

#ifdef VERBOSE
	cout<<iter_num<<" SPIN "<<endl;
#endif

	float_used cost, sint;

	float_used cosp, sinp;

	float_used ux = photons[i_photon].get_direction().x_dir;
	float_used uy = photons[i_photon].get_direction().y_dir;
	float_used uz = photons[i_photon].get_direction().z_dir;

	float_used psi;

	cost = spintheta( _list_of_materials[photons[i_photon].get_current_volume_element().get_material_index()].g);

	sint = sqrt((float_used)(1.0 - cost*cost));
	if(cost > COSZERO){
		sint = 0.0f;
	}

	ftoi_union ppsi;
	ppsi.f = _random_generator_spin.tinymt32_generate_float();
	ppsi.ui += NUM_TO_ADD_UNION;

	psi = PI*ppsi.f;

	cosp = cos(psi);
	sinp = sin(psi);

	dir_point new_dir;

	float_used temp = sqrt((float_used)(1.0f - uz*uz));
	float_used temp11 = sint/temp;

	float_used sintcosp = sint*cosp;
	float_used sintsinp = sint*sinp;

	float_used uzcosp = uz*cosp;
	float_used uxuzcosp = ux*uzcosp;
	float_used uyuzcosp = uy*uzcosp;

	float_used uysinp = uy*sinp;
	float_used uxsinp = ux*sinp;

	float_used uxcost = ux*cost;
	float_used uycost = uy*cost;
	float_used uzcost = uz*cost;

	float_used uxuzcosp_uysinp = uxuzcosp - uysinp;
	float_used uyuzcosp_uxsinp = uyuzcosp + uxsinp;

	float_used temp_x = temp11*(uxuzcosp_uysinp);
	float_used temp_y = temp11*(uyuzcosp_uxsinp);
	float_used temp_z = -sintcosp*temp;
	float_used temp_x_dir = temp_x + uxcost;
	float_used temp_y_dir = temp_y + uycost;
	float_used temp_z_dir =  temp_z + uzcost;

	if(fabs(uz) > COSZERO)
	{ /* normal incident. */
		new_dir.x_dir = sintcosp;
		new_dir.y_dir = sintsinp;
		if(uz >= 0)
			new_dir.z_dir = cost*1;
		else
			new_dir.z_dir = cost*-1;
	}
	else
	{ /* regular incident. */
		new_dir.x_dir = temp_x_dir;
		new_dir.y_dir = temp_y_dir;
		new_dir.z_dir = temp_z_dir;
	}
#ifdef VERBOSE
	cout<<iter_num<<" new dir x: "<<new_dir.x_dir<<" y "<<new_dir.y_dir<<" z "<<new_dir.z_dir<<endl;
	cout<<iter_num<<" direction magnitude: "<< sqrt(new_dir.x_dir*new_dir.x_dir + new_dir.y_dir*new_dir.y_dir + new_dir.z_dir*new_dir.z_dir)<<endl;
	cout<<endl;
#endif

	photons[i_photon].set_direction(new_dir);
}

void HLS_simulator::terminate()
{
#pragma HLS INLINE
	_num_terminated++;
}

void HLS_simulator::set_photon_i_num_of_hits(int i_photon, int value)
{
#pragma HLS INLINE
	photons[i_photon].set_num_hits(value);
}

void HLS_simulator::set_photon_i_remaining_step(int i_photon, int value)
{
#pragma HLS INLINE
	photons[i_photon].set_remaining_step(value);
}

unsigned int HLS_simulator::get_photon_i_num_hits(int i_photon)
{
#pragma HLS INLINE
	return (photons[i_photon].get_num_hits());
}

Volume_element HLS_simulator::get_voxel_index(Point position)
{
#pragma HLS INLINE

#ifdef VERBOSE
	cout<<iter_num<<" GET VOXEL ELEMENT"<<endl;
#endif
	Volume_element ve0;
	ve0.init_volume_element(0, 0, 0, 0, 0, 0);
	if (float_a_less_b(position.xcoord, _x_min) ||
		float_a_less_b(position.ycoord, _y_min) ||
		float_a_less_b(position.zcoord, _z_min) ||
		float_a_less_b(_x_max, position.xcoord) ||
		float_a_less_b(_y_max, position.ycoord) ||
		float_a_less_b(_z_max, position.zcoord))
	    	return (ve0);

	 float_used xid = (position.xcoord - _x_min)*_cube_length_inv;
	 float_used yid = (position.ycoord - _y_min)*_cube_length_inv;
	 float_used zid = (position.zcoord - _z_min)*_cube_length_inv;


	 int x_idx = get_int_from_float(xid);
	 int y_idx = get_int_from_float(yid);
	 int z_idx = get_int_from_float(zid);

	float_used x_coord = x_idx*_cube_length + _x_min;
	float_used y_coord = y_idx*_cube_length + _y_min;
	float_used z_coord = z_idx*_cube_length + _z_min;

#ifdef VERBOSE
	cout<<iter_num<<" idx_1 x: "<<xid<<" y: "<<yid<<" z: "<< zid<<endl;
	 cout<<iter_num<<" idx x: "<<x_idx<<" y: "<<y_idx<<" z: "<< z_idx<<endl;
	 cout<<iter_num<<" coord x: "<<x_coord<<" y: "<<y_coord<<" z: "<< z_coord<<endl;
#endif

	 if (x_idx >= _x_DIM || y_idx >= _y_DIM || z_idx >= _z_DIM)
		return (ve0); // element is outside the tissue

	unsigned int res =  z_idx + _z_DIM*(y_idx + _y_DIM*x_idx) + 1;

	Volume_element ve;
	ve.init_volume_element(x_coord, y_coord, z_coord,
					res, _material_index[res], _cube_length);
    return (ve);

}

// This function is used to deduct one from a random floating point number
// in the range of 0 to 2
// without paying 8 cycles
float_used HLS_simulator::num_minus_1(ftoi_union ff)
{
#pragma HLS INLINE
	if (ff.f < 1)
	{
		ff.ui |= 0x80000000;
		return (ff.f);
	}
	else
	{
		int i = ff.ui;

		int mantissa = i & 0x007fffff;

		unsigned int num_to_shift = msb(mantissa);

		mantissa = mantissa << num_to_shift;
		mantissa = mantissa & 0x007fffff;
		int exponent = 127 - num_to_shift;

		ff.ui = (exponent << 23) | mantissa;

		return ff.f;
	}
}


// This function is used to find the most significant bit of the mantissa
// of a float number
// The position it returns is the bit number from the left of a 23-bits long number
unsigned int HLS_simulator::msb(unsigned int num)
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

bool HLS_simulator::float_a_less_b(float_used a, float_used b)
{
#pragma HLS INLINE
	ftoi_union a1, b1;
	a1.f = a;
	b1.f = b;

	int sign_a = (a1.ui >> 31);
	int sign_b = (b1.ui >> 31);

	if (sign_a == 0 && sign_b == -1) // a > 0 && b < 0
		return false;
	else if (sign_a == -1 && sign_b == 0) // a < 0 && b << 0
		return true;

	if (sign_a == 0) // both of them positive
	{
		return (a1.ui < b1.ui);
	}
	else // both of them negative
	{
		return (a1.ui > b1.ui);
	}
}

// This method returns the integer part of a float efficiently
int HLS_simulator::get_int_from_float(float a)
{
#pragma HLS INLINE
    ftoi_union a1;
    a1.f = a;

    long long exponent = (a1.ui & 0x7f800000) >> 23;

	long long mantissa = a1.ui & 0x007fffff;
	long long e = exponent - 118;

	if (e < 0)
		e = 0;

	long long i = mantissa | 0x00800000;

	return (int)(((i << e) & 0xffffffff00000000) >> 32);
}
