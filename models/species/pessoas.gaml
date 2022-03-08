/**
* Name: pessoas
* Author: Leonardo Bittencourt da Silva
*/

model pessoas

import "../user_model.gaml"

//****************************************************************************//
//*								SPECIES PESSOAS	                            *//
//**************************************************************************//

species pessoas skills:[moving] {
		
//	status 0 = inativa | status 1 = feita | status 2 = sendo feita | status 3 = pode ser iniciada
	int t1_status; 
	int t2_status;
	int t3_status;
	int t4_status;
	int t5_status;
	int t6_status;
	int t7_status;
	int t1_minutos;
	int t2_minutos <- 1;
	int t3_minutos <- 1;
	int t4_minutos <- 1;
	int t5_minutos <- 30;
	int t6_minutos <- 1;
	int t7_minutos <- 1;
	int sleep_time <- -1; // auxilia o tempo que a pessoa espera
	point t1_local <- {10.67,19.29,0.0};
	point t2_local <- {9.90,16.90,0.0};
	point t3_local <- {5.58,8.64,0.0};
	point t4_local <- {5.70,5.11,0.0};
	point t5_local;
	point t6_local <- {5.07,2.06,0.0};
	point t7_local <- {5.17,19.32,0.0};
	
	point fora_1;		// fora depois do café da manhã
	point fora_2;		// fora depois do almoço
	point fora_3;		// fora depois do jantar
	int fora_1_minutos;
	int fora_2_minutos;
	int fora_3_minutos;
	
//	SEIR variáveis
	bool esta_suscetivel;
	bool esta_exposto;
	bool esta_infectado;
	bool esta_recuperado;
	
	point infectado_x;
	point infectado_y;
	
	point alvo;
	rgb color_pessoas;
	
    bool is_susceptible;
    bool is_exposed <- false;
    bool is_infected <- false;
    bool is_recovered <- false;
	
	string objetivo_atual;
	
    init {
    	
    	location <- t1_local + {1,0,0};
		t1_status <- 3;
		speed <- 3 #km/#h;
		color_pessoas <- #green;
		
    	if flip (0.1) {
    		is_infected <- true;
    		color_pessoas <- #red;
    		is_susceptible <- false;
    	}
    	
//		location <- texturas ? (origem + {0,0,0.75}) : origem;
    }

//*****************************************************************************
//	Reflex chegar ao restaurante
//	Objetivo: posicionar a pessoa na porta do restaurante
//*****************************************************************************

	reflex chegar when: t1_status > 0 {
		
		if alvo = nil and location != t1_local {
			alvo <- t1_local;
		}
		
		if location = alvo {
			alvo <- nil;
			t1_status <- 2;
		}
		
		if t1_status = 2 {
			do esperar;
		}
		
		if t1_status = 1 {
			t1_status <- 0;
			t2_status <- 3;
			do escolher_atividade;
		}
	}
	
//*****************************************************************************
//	Reflex PAGAR
//	Objetivo: Realiza o pagamento do restaurante
//*****************************************************************************
	
	reflex pagar when: t2_status > 0 {
		
		if alvo = nil and location != t2_local {
			alvo <- t2_local;
		}
		
		if location = alvo {
			is_susceptible <- true;
			alvo <- nil;
			t2_status <- 2;
		}
		
		if t2_status = 2 {
			do esperar;
		}
		
		if t2_status = 1 {
			t2_status <- 0;
			t3_status <- 3;
			do escolher_atividade;
		}
	}
	
//*****************************************************************************
//	Reflex PEGAR OS TALHERES
//	Objetivo: Pega os talheres
//*****************************************************************************

	reflex pegar_talher when: t3_status > 0 {
		
		if alvo = nil and location != t3_local {
			alvo <- t3_local;
		}
		
		if location = alvo {
			alvo <- nil;
			t3_status <- 2;
		}
		
		if t3_status = 2 {
			do esperar;
		}
		
		if t3_status = 1 {
			t3_status <- 0;
			t4_status <- 3;
			do escolher_atividade;
		}
	}
	
//*****************************************************************************
//	Reflex SE SERVIR
//	Objetivo: Coloca comida no prato
//*****************************************************************************
 
	reflex pegar_comida when: t4_status > 0 {
		
		if alvo = nil and location != t4_local {
			alvo <- t4_local;
		}
		
		if location = alvo {
			alvo <- nil;
			t4_status <- 2;
		}
		
		if t4_status = 2 {
			do esperar;
		}
		
		if t4_status = 1 {
			t4_status <- 0;
			t5_status <- 3;
			do escolher_atividade;
		}
	}

//*****************************************************************************
//	Reflex COMER
//	Objetivo: Escolhe uma cadeira vazia e consome a refeição
//***************************************************************************** 

	reflex comer when: t5_status > 0 {
		
		if alvo = nil and location != t5_local {
			do escolher_cadeira;
			alvo <- t5_local;
		}
		
		if alvo != nil and location != alvo {
			do verificar_disponibilidade;
		}
		
		if location = alvo {
			alvo <- nil;
			t5_status <- 2;
			do ocupar_cadeira;
		}
		
		if t5_status = 2 {
			do esperar;
		}
		
		if t5_status = 1 {
			do desocupar_cadeira;
			t5_status <- 0;
			t6_status <- 3;
			do escolher_atividade;
		
		}
	}

//*****************************************************************************
//	Reflex ENTREGAR TALHERES
//	Objetivo: Realiza a entrega dos talheres utilizados na refeição
//*****************************************************************************

	reflex entregar_talheres when: t6_status > 0 {
		
		if alvo = nil and location != t6_local {
			alvo <- t6_local;
		}

		if location = alvo {
			alvo <- nil;
			t6_status <- 2;
		}
		
		if t6_status = 2 {
			do esperar;
		}
		
		if t6_status = 1 {
			t6_status <- 0;
			t7_status <- 3;
			do escolher_atividade;
		}
	}
	
//*****************************************************************************
//	Reflex PARTIR
//	Objetivo: Vai embora do prédio e some
//*****************************************************************************

	reflex ir_embora when: t7_status > 0 {
		
		if alvo = nil {
			alvo <- t7_local;
		}
		if alvo = location {
			do die;
		}
	}

//*****************************************************************************
//	Action escolher uma atividade
//	Objetivo: controla a escolha de uma atividade com base na sua dependência
//*****************************************************************************

	action escolher_atividade {
		
		if t1_status = 1 {
			t2_status <- 3;
		}

		if t2_status = 1 and t1_status = 1 {
			t3_status <- 3;
		}

		if t3_status = 1 and t2_status = 1 and t1_status = 1 {
			t4_status <- 3;
		}
		
		if t4_status = 1 and t3_status = 1 and t2_status = 1 and t1_status = 1 {
			t5_status <- 3;
		}
		
		if t5_status = 1 and t4_status = 1 and t3_status = 1 and t2_status = 1 and t1_status = 1 {
			t6_status <- 3;
		}
		
		if t6_status = 1 and t5_status = 1 and t4_status = 1 and t3_status = 1 and t2_status = 1 and t1_status = 1 {
			t7_status <- 3;
		} 
	}
	
//*****************************************************************************
//	Action Escolher cadeira
//	Objetivo: Escolhe o número de uma cadeira vazia no local
//*****************************************************************************

	action escolher_cadeira {
		t5_local <- one_of(where(mesas, each.cadeira_ocupada = false and each.tipo = "cadeira")).location;
	}
	
//*****************************************************************************
//	Action confirmar ocupação da cadeira
//	Objetivo: Verifica se a cadeira ainda está disponível
//*****************************************************************************

	action verificar_disponibilidade {
		
		ask mesas where (each.location=alvo) {
			if self.cadeira_ocupada {
				myself.alvo <- nil;
			}
		}
	}

//*****************************************************************************
//	Action ocupar cadeira
//	Objetivo: Marcar a cadeira como ocupada
//*****************************************************************************

	action ocupar_cadeira {
		ask mesas where (each.location=alvo) {
			cadeira_ocupada <- true;
		}
	}

//*****************************************************************************
//	Action desocupar cadeira
//	Objetivo: Marcar a cadeira como disponivel
//*****************************************************************************

	action desocupar_cadeira {
		ask mesas where (each.location=alvo) {
			cadeira_ocupada <- false;
		}
	}
			

//   	float infected_x;
//   	float infected_y;
//   	float infected_z;
//   	int infective_minute;
//   	int infective_day;

//*****************************************************************************
//	Reflex suscetivel para exposto
//	Objetivo: mudar o estado da pessoa para exposto
//*****************************************************************************

    int ngb_infected_number function: pessoas at_distance 1 #m count(each.is_infected);

	reflex s_to_e when: is_susceptible and (time mod 60.0) = 0 {
		if flip(1-(1-beta)^ngb_infected_number) {
			is_susceptible <- false;
			is_exposed <- true;
			color_pessoas <- #yellow;
			save [self.name,self.location.x, self.location.y,time] to: "../outputs/transmissao.csv" type: "csv" rewrite: false;
//			geometry var1 <- {self.location.x, self.location.y, self.location.z}  CRS_transform("EPSG:27700");
//			infected_x <- var1.location.x;
//			infected_y <- var1.location.y;
//			infected_z <- var1.location.z;
//			infective_minute <- current_date.minute_of_day;
//			infective_day <- current_date.day_of_year;
		}
	}
	

//*****************************************************************************
//	Reflex colisao com pessoas
//	Objetivo: identificar outras pessoas e criar colisões
//*****************************************************************************

//	reflex colisao_com_pessoas {
//		write agents_inside(self) where (each.name contains "pessoas");
//		ask pessoas at_distance 1 #m {
//			if self.location in myself.location{
//				write "pojas";
//			}
//		}
//	}

	reflex e_to_i when: is_exposed {
		
	}
	
	reflex i_to_r when: is_infected {
		
	}

	
//*****************************************************************************
//	Move
//	Objetivo: Realiza o movimento da pessoas quando ela tem um alvo
//*****************************************************************************
	
	reflex move when: alvo != nil {
		
		do goto target:alvo on:caminho_de_pedestres;
	
	}
	
//*****************************************************************************
//	Esperar
//	Objetivo: a pessoa espera um determinado tempo quando chega no seu alvo 
//*****************************************************************************

	action esperar {
		if t1_status = 2 {
			if sleep_time = -1 {
				sleep_time <- t1_minutos;
			}
			if sleep_time > -1 {
				if sleep_time = 0 {
					t1_status <- 1;
					sleep_time <- sleep_time - 1;
				} else {
					sleep_time <- sleep_time - 1;	
				}
			}
		}

		if t2_status = 2 {
			if sleep_time = -1 {
				sleep_time <- t2_minutos;
			}
			if sleep_time > -1 {
				if sleep_time = 0 {
					t2_status <- 1;
					sleep_time <- sleep_time - 1;
				} else {
					sleep_time <- sleep_time - 1;	
				}
			}
		}
		
		if t3_status = 2 {
			if sleep_time = -1 {
				sleep_time <- t3_minutos;
			}
			if sleep_time > -1 {
				if sleep_time = 0 {
					t3_status <- 1;
					sleep_time <- sleep_time - 1;
				} else {
					sleep_time <- sleep_time - 1;	
				}
			}
		}
					
		if t4_status = 2 {
			if sleep_time = -1 {
				sleep_time <- t4_minutos;
			}
			if sleep_time > -1 {
				if sleep_time = 0 {
					t4_status <- 1;
					sleep_time <- sleep_time - 1;
				} else {
					sleep_time <- sleep_time - 1;	
				}
			}
		}
		
		if t5_status = 2 {
			if sleep_time = -1 {
				sleep_time <- t5_minutos;
			}
			if sleep_time > -1 {
				if sleep_time = 0 {
					t5_status <- 1;
					sleep_time <- sleep_time - 1;
				} else {
					sleep_time <- sleep_time - 1;	
				}
			}
		}
					
		if t6_status = 2 {
			if sleep_time = -1 {
				sleep_time <- t6_minutos;
			}
			if sleep_time > -1 {
				if sleep_time = 0 {
					t6_status <- 1;
					sleep_time <- sleep_time - 1;
				} else {
					sleep_time <- sleep_time - 1;	
				}
			}
		}
								
		if t7_status = 2 {
			if sleep_time = -1 {
				sleep_time <- t7_minutos;
			}
			if sleep_time > -1 {
				if sleep_time = 0 {
					t7_status <- 1;
					sleep_time <- sleep_time - 1;
				} else {
					sleep_time <- sleep_time - 1;	
				}
			}
		}
	}
		
//*****************************************************************************

    aspect base {
		if texturas {
			draw obj_file("../includes/objs/people.obj", 90::{-1,0,0}) size: 0.5 color: color_pessoas;
		} else {
			draw circle(0.25) color: color_pessoas depth: 1.75;
		}
	}
}