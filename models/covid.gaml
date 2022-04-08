/**
* Name: covid
* Based on the internal empty template. 
* Author: Leonardo Bittencourt da Silva
* Tags: covid, sir
**/

model covid

import "user_model.gaml"
import "experiment.experiment"

//****************************************************************************//
//*							CONFIGURAÇÕES GLOBAIS                           *//
//**************************************************************************//

global {

	file shape_file_predio <- file("../includes/shapes/predio.shp");
	file shape_file_mesas <- file("../includes/shapes/mesas.shp");
	file shape_file_caminhos <- file("../includes/shapes/caminho.shp");

	geometry shape <- envelope(shape_file_predio);

	bool texturas <- false;

//	Definindo variáveis que controlam o tempo do modelo
	float step <- 1 #mn;
	date starting_date <- date("2022-01-01 00:00:00");

//	Definindo uma variável que será usada futuramente para que o agente ande sobre os caminhos
	graph caminho_de_pedestres;

//	Parâmetro epidemiológico: beta = prob. infecção | sigma = dias de incubação | gamma = dias para se recuperar 
	float beta <- 0.025;
	int sigma <- 5;
	int gamma <- 7;
	
	float distancia_infeccao <- 1 #m;
	
	float prob_vacinado <- 1.0;
	float protecao_vacina <- 0.80336; //0.80336
	float prob_iniciar_infectado <- 0.05; //3588/11080000 = 0.00032382671 // média 7d infectados 15-05 no paraná / populução do paraná
	float prob_sintomatico <- 0.75; //importante
	float prob_quarentena <- 1.0;
	float prob_respeitar_cuidados <- 1.0;
	float prob_hospitalizado_apos_quarentena <- 0.0;
	float prob_curado_apos_cuidados <- 0.0;
	float prob_morte_hosp <- 0.0;
	int dias_quarentena <- 7;
	int dias_hospitalizado <- 0;
	
	string nome_arquivo_saida <- "teste";
		
	init {
				
		create predio from: shape_file_predio with: [fid:float(read("fid"))] {
			do personalizar_predio;
		}
		
		create mesas from: shape_file_mesas with: [fid:int(read("fid"))];

		create caminho from: shape_file_caminhos;
		caminho_de_pedestres <- as_edge_graph(caminho);

		create pessoas number: 409;		
	}
	
	 reflex toto when: current_date.day = 1 and current_date.month = 2 {
        do pause;
        write cycle;
        write time;
    }
}