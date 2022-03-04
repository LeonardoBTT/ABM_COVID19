/**
* Name: pessoas
* Author: Leonardo Bittencourt da Silva
*/

model caminho

import "../user_model.gaml"

//****************************************************************************//
//*								SPECIES CAMINHO	                            *//
//**************************************************************************//

species caminho {
	
	rgb color;
	
	init {
		color <- #red;
	}
	
	aspect base {
		
		draw shape color: color;
		
		if texturas and self.location.z != 0.75 {
			location <- location + {0,0,0.75};
		}
	}
}