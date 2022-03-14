/**
* Name: pessoas
* Author: Leonardo Bittencourt da Silva
*/

model predio

import "../user_model.gaml"

//****************************************************************************//
//*								SPECIES PREDIO	                            *//
//**************************************************************************//

species predio {
	
//*****************************************************************************
//	Action Personalizar o prédio
//	Objetivo: Alterar configurações de exibição dos elementos visuais do prédio
//*****************************************************************************

	int fid;
	rgb color_mesas;
	float altura;
	bool disponivel;
	
	int hora_inicio_cafe <- 6;
	int minuto_inicio_cafe <- 30;
	int hora_fim_cafe <- 8;
	int minuto_fim_cafe <- 0;
	
	int hora_inicio_almoco <- 11;
	int minuto_inicio_almoco <- 0;
	int hora_fim_almoco <- 13;
	int minuto_fim_almoco <- 15;
	
	int hora_inicio_jantar <- 17;
	int minuto_inicio_jantar <- 0;
	int hora_fim_jantar <- 19;
	int minuto_fim_jantar <- 30;
	
	reflex abrir_e_fechar {
//		Café
		if current_date.hour = hora_inicio_cafe and current_date.minute = minuto_inicio_cafe {
//			write "Hora do café";
			disponivel <- true;
			ask pessoas where (each.inativo=true) {
				self.t1_status <- 3;
			}
		}
		if current_date.hour = hora_fim_cafe and current_date.minute = minuto_fim_cafe {
			disponivel <- false;
//			write "Fim da hora do café";
			ask pessoas where (each.inativo=true) {
				self.t1_status <- 0;
			}
		}

//		Almoço		
		if current_date.hour = hora_inicio_almoco and current_date.minute = minuto_inicio_almoco {
//			write "Hora do almoço";
			disponivel <- true;
			ask pessoas {
				self.t1_status <- 3;
			}
		}
		if current_date.hour = hora_fim_almoco and current_date.minute = minuto_fim_almoco {
//			write "Fim da hora do almoço";
			disponivel <- false;
		}

//		Jantar
		if current_date.hour = hora_inicio_jantar and current_date.minute = minuto_inicio_jantar {
//			write "Hora da janta";
			disponivel <- true;
			ask pessoas {
				self.t1_status <- 3;
			}
		}
		if current_date.hour = hora_fim_jantar and current_date.minute = minuto_fim_jantar {
//			write "Fim da hora do almoço";
			disponivel <- false;
		}
	}
	
	reflex permitir_entrada when: disponivel and every(2#cycle){
		try {
			ask one_of(pessoas where (each.location={10.67,19.29,0.0})){
				if pessoas count (each.inativo=false) < 100 {
					self.t1_status <- 1;
				}
			}
		}
	}
	
	action personalizar_predio {
		
//		Filtra tudo o que NÃO for parede
		if (fid >= 44 and fid <= 50) or (fid >= 151 and fid <= 153) {
			
//			Balcão (44 e 45)
			if fid = 44 or fid = 45 {
				color_mesas <- #red - 200;
				altura <- 1.0;
			}
						
//			Mesa dos talheres (46) e comidas (47)
			if fid = 46 or fid = 47 {
				color_mesas <- #red - 200;
				altura <- 1.0;
			}
			
//			Entregar dos talheres (48)
			if fid = 48 {
				color_mesas <- #red;
				altura <- 0.0;
			}
			
//			Entrada (49) e saída (50)
			if fid = 49 or fid = 50 {
				color_mesas <- #red;
				altura <- 0.0;
			}
			
//			Pontos de parada: balcão (151), mesa dos talheres (152) e comidas (153) 
			if fid = 151 or fid = 152 or fid = 153 {
				color_mesas <- #red;
				altura <- 0.0;
			}
		
//		  Personalização das PAREDES
		} else {
			color_mesas <- #grey;
			altura <- 2.5;
		}
	}
	
//*****************************************************************************
	
	aspect base {
		
		draw shape color: color_mesas depth: altura;
					
		if texturas {
			
//			Piso
			draw rectangle(11.8,19.5) at: {5.9,9.8,-0.1} texture: ['../includes/imgs/textura.jpg'];
			
//			Representação dos funcionários
			draw obj_file("../includes/objs/people.obj", 90::{-1,0,0}) at: {7,5,0.7} rotate: 90 size: 0.5 color: #black + 100;
			draw obj_file("../includes/objs/people.obj", 90::{-1,0,0}) at: {7,7,0.7} rotate: 90 size: 0.5 color: #black + 100;
			draw obj_file("../includes/objs/people.obj", 90::{-1,0,0}) at: {11,16.5,0.7} rotate: 90 size: 0.5 color: #black + 100;
			
		} else {
			draw rectangle(11.8,19.5) at: {5.9,9.8,-0.1} color: #white;
		}
	}
}