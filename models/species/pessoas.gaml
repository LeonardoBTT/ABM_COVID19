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
		
//	status 0 = atividade já realizada | status 1 = concluída | status 2 = sendo realizada| status 3 = pode ser iniciada
	int t1_status <- 0; 
	int t2_status <- 0;
	int t3_status <- 0;
	int t4_status <- 0;
	int t5_status <- 0;
	int t6_status <- 0;
	int t7_status <- 0;
	int t1_minutos <- 0;
	int t2_minutos <- 1;
	int t3_minutos <- 1;
	int t4_minutos <- 1;
	int t5_minutos <- 30;
	int t6_minutos <- 1;
	int t7_minutos <- 1;
	int sleep_time <- -1;						// auxilia o tempo que a pessoa espera
	point t1_local <- {10.67,19.29,0.0};
	point t2_local <- {9.90,16.90,0.0};

	point t3_local <- {5.58,8.64,0.0};
	point t4_local <- {5.70,5.11,0.0};
	point t5_local;
	point t6_local <- {5.07,2.06,0.0};
	point t7_local <- {5.17,19.32,0.0};
	
	point fora_do_local <- {5.30,19.32,0.0};	// fora depois do café da manhã
	bool inativo;
	
//	SEIR
	bool esta_suscetivel <- true;
	
	bool esta_exposto <- false;
    int exposto_minutos <- 0;
	
	bool esta_infectado <- false;
    bool sintomatico;
    bool assintomatico;
    int infectado_minutos <- 0;
    
    bool em_cuidados <- false;
    bool quarentena <- false;
    bool hospitalizado <- false;
    int minutos_em_quarentena <- 0;
    int minutos_hospitalizado <- 0;
    
	bool esta_recuperado <- false;
	bool esta_curado <- false;
	bool esta_morto <- false;
	bool esta_vivo <- true;
    
	point alvo;
	rgb color_pessoas <- #green;
	float beta_individual;
	
    init {
    	
		speed <- 3 #km/#h;
    	location <- t1_local + {1,0,0};

//		Espera até o restaurante abrir
		inativo <- true;
   
   		
   		beta_individual <- flip(prob_vacinado) ? beta * (1-protecao_vacina) : beta;
   		sintomatico <- flip(prob_sintomatico) ? true : false;
   		assintomatico <- sintomatico ? false : true;
		
    	if flip(prob_iniciar_infectado) {
    		esta_infectado <- true;
    		sintomatico <- false;
    		esta_suscetivel <- false;
    		color_pessoas <- #red;
    	}
    }

//*****************************************************************************
//	Reflex chegar ao restaurante
//	Objetivo: posicionar a pessoa na porta do restaurante
//*****************************************************************************

	reflex chegar when: t1_status > 0 and !(em_cuidados) {
		
		if alvo = nil and location != t1_local {
			alvo <- t1_local;
		}
		
		if location = alvo {
			alvo <- nil;
		}
		
		if t1_status = 1 {
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
			alvo <- nil;
			t2_status <- 2;
		}
		
		if t2_status = 2 {
			inativo <- false;
			do esperar;
		}
		
		if t2_status = 1 {
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
		
		if alvo != nil {
			do verificar_disponibilidade;
		}
		
		if location = alvo {
//			Teste para descobrir se duas pessoas ocupam a mesma cadeira
//			ask mesas where (each.location=alvo) {
//				if self.cadeira_ocupada {
//					write "Sentei em uma cadeira já ocupada!";
//				}
//			}
			alvo <- nil;
			do ocupar_cadeira;
			t5_status <- 2;
		}
		
		if t5_status = 2 {
			do esperar;
		}
		
		if t5_status = 1 {
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
			alvo <- nil;
			inativo <- true;
		}
	}

//*****************************************************************************
//	Action escolher uma atividade
//	Objetivo: controla a escolha de uma atividade com base na sua dependência
//*****************************************************************************

	action escolher_atividade {
		
		if t1_status = 1 {
			t1_status <- 0;
			t2_status <- 3;
		}

		if t2_status = 1 and t1_status = 0 {
			t2_status <- 0;
			t3_status <- 3;
		}

		if t3_status = 1 and t2_status = 0 and t1_status = 0 {
			t3_status <- 0;
			t4_status <- 3;
		}
	
		if t4_status = 1 and t3_status = 0 and t2_status = 0 and t1_status = 0 {
			t4_status <- 0;
			t5_status <- 3;
		}
		
		if t5_status = 1 and t4_status = 0 and t3_status = 0 and t2_status = 0 and t1_status = 0 {
			t5_status <- 0;
			t6_status <- 3;
		}
		
		if t6_status = 1 and t5_status = 0 and t4_status = 0 and t3_status = 0 and t2_status = 0 and t1_status = 0 {
			t6_status <- 0;
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

//*****************************************************************************
//	Reflex suscetivel para exposto
//	Objetivo: mudar o estado da pessoa para exposto
//*****************************************************************************

//    int ngb_infected_number function: pessoas at_distance distancia_infeccao count(each.esta_infectado);
	int ngb_infected_number <- 0;
	
	reflex s_to_e when: esta_suscetivel and !(inativo) and !(esta_curado) {
		if pessoas at_distance distancia_infeccao count(each.esta_infectado) > 0 {
			ngb_infected_number <- 1;
		}
		
		if flip(1-(1-beta_individual)^ngb_infected_number) {
			ngb_infected_number <- 0;
			esta_suscetivel <- false;
			esta_exposto <- true;
			color_pessoas <- #yellow;
			geometry home_geom_CRS <- {self.location.x, self.location.y, self.location.z}  CRS_transform("EPSG:3857");
			save [self.name,home_geom_CRS.location.x,home_geom_CRS.location.y,time] to: "../outputs/transmissao.csv" type: "csv" rewrite: false;
		}
	}

//*****************************************************************************
//	Reflex exposto para infectado 
//	Objetivo: mudar o estado da pessoa para infectado
//*****************************************************************************

	reflex e_to_i when: esta_exposto {
		if name = "pessoas14" {
//			write "Estou exposto a:" + int(exposto_minutos/(24)) + " dias";
		}
		exposto_minutos <- exposto_minutos + 1;
		if int(sigma/(exposto_minutos/(24*60))) = 1 {
			exposto_minutos <- 0;
			esta_exposto <- false;
			if assintomatico {
				esta_infectado <- true;
				color_pessoas <- #red;
			} else {
				em_cuidados <- true;
			}
		}
	}
	
//*****************************************************************************
//	Reflex infectado para tomando cuidados (quarentena/hospitalização) 
//	Objetivo: gerenciar o tempo da quarentena/hospitalização, considerar morte
//	após hospitalização, possibilidade de estar curado e da possibilidade de as
//	pessoas não respeitar os cuidados. 
//*****************************************************************************

	reflex i_to_cuidados when: em_cuidados {
		
		if flip(prob_respeitar_cuidados) {
			if !(quarentena and hospitalizado) {
				quarentena <- flip(prob_quarentena) ? true: false;
				hospitalizado <- quarentena ? false : true;
			}
			
			if quarentena {
				minutos_em_quarentena <- minutos_em_quarentena + 1;
				if int(dias_quarentena/(minutos_em_quarentena/(24*60))) = 1 {
					minutos_em_quarentena <- 0;
					quarentena <- false;
					if !(flip(prob_hospitalizado_apos_quarentena)) {
						em_cuidados <- false;
						esta_recuperado <- true;
						esta_curado <- flip(prob_curado_apos_cuidados) ? true : false;
					} else {
						hospitalizado <- true;
					}
				}
			}
			
			if hospitalizado {
				minutos_hospitalizado <- minutos_hospitalizado + 1;
				if int(dias_hospitalizado/(minutos_hospitalizado/(24*60))) = 1 {
					minutos_hospitalizado <- 0;
					if !(flip(prob_morte_hosp)) {
						quarentena <- false;
						em_cuidados <- false;
						esta_recuperado <- true;
						esta_curado <- flip(prob_curado_apos_cuidados) ? true : false;
					} else {
						esta_recuperado <- true;
						esta_vivo <- false;
						esta_morto <- true;
					}
				}
			}
			
		} else {
			esta_infectado <- true;
			em_cuidados <- false;
		}
	}
	
//*****************************************************************************
//	Reflex infectado para recuperado
//	Objetivo: gerencia o tempo que a pessoas está infectada e muda o estado dela
//	para recuperada, considerando a possibilidade de estar curada.
//*****************************************************************************

	reflex i_to_r when: esta_infectado {
		infectado_minutos <- infectado_minutos + 1;
		if int(gamma/(infectado_minutos/(24*60))) = 1 {
			infectado_minutos <- 0;
			esta_infectado <- false;
			esta_suscetivel <- true;
			color_pessoas <- #green;
		}
	}
	
//*****************************************************************************
//	Reflex recuperado para suscetivel
//	Objetivo: muda o estado da pessoa para suscetivel se estiver viva,
//	elimina o agente se tiver morto
//*****************************************************************************

	reflex r_to_s when: esta_recuperado {

		color_pessoas <- #green;
		
		if esta_curado {
//			write "curado pela vacina";
		}

		if esta_morto {
			do die;
		}
		
		if esta_vivo {
			esta_suscetivel <- true;
			esta_recuperado <- false;
		}
	}

//*****************************************************************************
//	Move
//	Objetivo: Realiza o movimento das pessoas quando ela tem um alvo
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
				write sleep_time;
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
		} 
		
		if !(inativo) {
			draw circle(0.25) color: color_pessoas depth: 1.75;
		}
	}
}