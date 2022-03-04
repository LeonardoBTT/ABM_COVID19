/**
* Name: pessoas
* Author: Leonardo Bittencourt da Silva
*/

model covid

import "../user_model.gaml"

//****************************************************************************//
//*								SPECIES MESAS	                            *//
//**************************************************************************//

species mesas {
	
	int fid;
	string tipo;
	rgb color;
	float altura;
	bool cadeira_ocupada;

	init {
		tipo <- fid < 51 ? "mesa" : "cadeira";
		color <- tipo = "mesa" ? #blue : #red;
		altura <- tipo = "mesa" ? 0.8 : 0.4;
		cadeira_ocupada <- false;
	}
	
	aspect base {
		switch tipo {
			match "mesa" {
				if texturas {
					draw obj_file("../includes/objs/mesa.obj", "../includes/objs/mesa.mtl", 90::{-1,0,0}) size: 1.2;
				} else {
					draw shape color: color depth: altura;
				}
			}
			
			match "cadeira" {
				if texturas {
					draw shape color: color depth: altura;
				} else {
					draw shape color: color depth: altura;
				}
			}
		}
	}
}