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
	
	//	MANUTENÇÃO
	
    bool is_susceptible <- true;
    bool is_exposed <- false;
    bool is_infected <- false;
    bool is_recovered <- false;
	
	rgb color_pessoas;
	string objetivo_atual;
	
    init {
    	color_pessoas <- #green;
    	if flip (0.1) {
    		is_infected <- true;
    		color_pessoas <- #red;
    		is_susceptible <- false;
    	}
    	speed <- 3 #km/#h;
		objetivo_atual <- "pagar";
		n_pessoas <- n_pessoas - 1;
		location <- texturas ? (origem + {0,0,0.75}) : origem;
    }

//*****************************************************************************
//	Move
//	Objetivo: Realiza o movimento da pessoas quando ela tem um alvo
//*****************************************************************************

	point alvo;

	reflex move when: alvo != nil and alvo != location {
		do goto target:alvo on:caminho_de_pedestres;
	}

//*****************************************************************************
//	Reflex PAGAR
//	Objetivo: Realiza o pagamento do restaurante
//*****************************************************************************
	
	reflex pagar when: objetivo_atual = "pagar" {
		
		if alvo = nil {
			alvo <- definir_alvo(objetivo_atual, predio);
		}
		
		if alvo = location and sleep_confirmacao = false {
			do sleep(5.0 #s);
		}
		
		if sleep_confirmacao {
			alvo <- nil;
			sleep_confirmacao <- false;
			if n_pessoas > 0 {
				create pessoas;
			}
			objetivo_atual <- "pegar_os_talheres";
		}
	}
	
//*****************************************************************************
//	Reflex PEGAR OS TALHERES
//	Objetivo: Pega os talheres
//*****************************************************************************

	reflex pegar_talher when: objetivo_atual = "pegar_os_talheres" {
		
		if alvo = nil {
			alvo <- definir_alvo(objetivo_atual, predio);	
		}
		
		if alvo = location and sleep_confirmacao = false {
			do sleep(5.0 #s);
		}
		
		if sleep_confirmacao {
			alvo <- nil;
			sleep_confirmacao <- false;
			objetivo_atual <- "se_servir";
		}
	}

//*****************************************************************************
//	Reflex SE SERVIR
//	Objetivo: Coloca comida no prato
//*****************************************************************************
 
	reflex pegar_comida when: objetivo_atual = "se_servir" {
		
		if alvo = nil {
			alvo <- definir_alvo(objetivo_atual, predio);	
		}
		
		if alvo = location and sleep_confirmacao = false {
			do sleep(5.0 #s);
		}
		
		if sleep_confirmacao {
			alvo <- nil;
			sleep_confirmacao <- false;
			objetivo_atual <- "comer";
		}
	}
	
//*****************************************************************************
//	Reflex COMER
//	Objetivo: Escolhe uma cadeira vazia e consome a refeição
//***************************************************************************** 

	int cadeira_escolhida <- 0;

	reflex comer when: objetivo_atual = "comer" {
		
		if cadeira_escolhida = 0 {
			cadeira_escolhida <- escolher_cadeira();
			alvo <- definir_alvo(cadeira_escolhida, mesas);
		}
		
		if cadeira_escolhida != 0 and sleep_confirmacao = false {
			if cadeira_disponivel(cadeira_escolhida) = false {
				alvo <- nil;
				cadeira_escolhida <- 0;
			}
		}
		
		if alvo = location and sleep_confirmacao = false {
			do ocupacao_cadeira(cadeira_escolhida);
			do sleep(15 #mn);
		}
		
		if sleep_confirmacao {
			alvo <- nil;
			sleep_confirmacao <- false;
			do ocupacao_cadeira(cadeira_escolhida);
			objetivo_atual <- "entregar_talheres";
		}
	}

//*****************************************************************************
//	Reflex ENTREGAR TALHERES
//	Objetivo: Realiza a entrega dos talheres utilizados na refeição
//*****************************************************************************

	reflex entregar_talheres when: objetivo_atual = "entregar_talheres" {

		if alvo = nil {
			alvo <- definir_alvo(objetivo_atual, predio);
		}
		
		if alvo = location and sleep_confirmacao = false {
			do sleep(5.0 #s);
		}
		
		if sleep_confirmacao {
			alvo <- nil;
			sleep_confirmacao <- false;
			objetivo_atual <- "partir";
		}
	}
	
//*****************************************************************************
//	Reflex PARTIR
//	Objetivo: Vai embora do prédio e some
//*****************************************************************************

	reflex ir_embora when: objetivo_atual = "partir" {
		
		if alvo = nil {
			alvo <- definir_alvo(objetivo_atual, predio);
		}
		if alvo = location {
			do die;
		}
	}
	
//*****************************************************************************
//	Escolher cadeira
//	Objetivo: Escolhe o número de uma cadeira vazia no local
//*****************************************************************************

	int escolher_cadeira {
	
		int cadeira;

		cadeira <- one_of(where(mesas, each.cadeira_ocupada = false and each.tipo = "cadeira")).fid;
		
		return cadeira;
	}
	
//*****************************************************************************
//	BOOL confirmar ocupação da cadeira
//	Objetivo: Verifica se a cadeira ainda está disponível
//*****************************************************************************

	bool cadeira_disponivel(int cadeira) {
		
		bool situacao;

		ask mesas where (each.fid=cadeira) {
			situacao <- self.cadeira_ocupada ? false : true;
		}
		
		return situacao;
	}

//*****************************************************************************
//	Action ocupar cadeira
//	Objetivo: Marcar a cadeira como ocupada/disponivel
//*****************************************************************************

	action ocupacao_cadeira (int cadeira) {
		ask mesas where (each.fid=cadeira) {
			cadeira_ocupada <- cadeira_ocupada ? false : true;
		}
	}
		
//*****************************************************************************
//	Define um ALVO (point)
//  Objetivo: definir um ponto com base na coleção escolhida
//*****************************************************************************

    point definir_alvo (unknown obj, container colecao_escolhida) {
    	
    	int id_obj;
     	geometry geometria_alvo;    	
    	point ponto_alvo;
    	point ajuste_altura;
    	
    	switch colecao_escolhida {
    		match predio {
    			id_obj <- objetivos_nome index_of string(obj);
    			id_obj <- objetivos_objetos_predio[id_obj];
    			geometria_alvo <- one_of(predio where (each.fid=id_obj));
    		}
    		match mesas {
    			id_obj <- int(obj);
    			geometria_alvo <- one_of(mesas where (each.fid=id_obj));
    		}
    	}
		
	 	ajuste_altura <- texturas ? {0,0,0.75} : {0,0,0};	
		ponto_alvo <- geometria_alvo.location + ajuste_altura;

    	return ponto_alvo;
	}

//*****************************************************************************
//	Controle do sleep
//  Objetivo: fazer a pessoa esperar um determinado tempo (parada)
//*****************************************************************************

	float sleep_time <- 0.0;
	string sleep_objetivo <- nil;
	bool sleep_confirmacao <- false;

	action sleep(float tempo) {
		sleep_time <- tempo;
		sleep_objetivo <- objetivo_atual;
		objetivo_atual <- "sleep";
	}
	 
	reflex sleep when: objetivo_atual = "sleep" {
		sleep_time <- sleep_time - 1;
		if sleep_time <= 0 {
			objetivo_atual <- sleep_objetivo;
			sleep_confirmacao <- true;
		}
	}
	
//*****************************************************************************
//	
//  Objetivo: 
//*****************************************************************************

//	MANUTENÇÃO

   	float infected_x;
   	float infected_y;
   	float infected_z;
   	int infective_minute;
   	int infective_day;

	
	list testando;

    int ngb_infected_number function: pessoas at_distance 1 #m count(each.is_infected);

	reflex s_to_e when: is_susceptible and (time mod 60.0) = 0 {
		if flip(1-(1-beta)^ngb_infected_number) {
			is_susceptible <- false;
			is_exposed <- true;
			color_pessoas <- #yellow;
			save [self.name,self.location.x, self.location.y,time] to: "../outputs/transmissao.csv" type: "csv" rewrite: false;
			
			geometry var1 <- {self.location.x, self.location.y, self.location.z}  CRS_transform("EPSG:27700");
			infected_x <- var1.location.x;
			infected_y <- var1.location.y;
			infected_z <- var1.location.z;
			infective_minute <- current_date.minute_of_day;
			infective_day <- current_date.day_of_year;
		}
	}
	
	
	reflex jioasdjsioajd {
		write agents_inside(self) where (each.name contains "pessoas");
//		ask pessoas at_distance 1 #m {
//			if self.location in myself.location{
//				write "pojas";
//			}
//		}
	}
	
	reflex e_to_i when: is_exposed {
		
	}
	
	reflex i_to_r when: is_infected {
		
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