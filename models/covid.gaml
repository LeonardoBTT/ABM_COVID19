/**
* Name: covid
* Based on the internal empty template. 
* Author: Leonardo Bittencourt da Silva
* Tags: covid, sir, 
*/

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

	int n_pessoas <- 100;
	point origem <- {10.67,19.29,0};
	bool texturas <- false;
	
//	Definindo variáveis que controlam o tempo do modelo
	float step <- 1 #s;
	date starting_date <- date("2022-01-01 06:00:00");
		
//	Definindo uma variável que será usada futuramente para que o agente ande sobre os caminhos
	graph caminho_de_pedestres;
	
//	Lista dos objetivos dentro do restaurante, tempos individuais e fid de cada objeto (para que o agente identifique a localização)
	list<string> objetivos_nome <- 	["pagar","pegar_os_talheres","se_servir","comer","entregar_talheres","partir"];
	list<float> objetivos_tempos <- [5.0,5.0,5.0,5.0,5.0,5.0];
	list<int> objetivos_objetos_predio <- [151,152,153,0,48,50];
	
//	Parâmetro epidemiológico: beta = prob. infecção | sigma = dias de incubação | gamma = dias para se recuperar 
	float beta <- 0.025;
	int sigma <- 5;
	int gamma <- 7;
		
	init {
				
		create predio from: shape_file_predio with: [fid:float(read("fid"))] {
			do personalizar_predio;
		}
		
		create mesas from: shape_file_mesas with: [fid:int(read("fid"))];

		create caminho from: shape_file_caminhos;
		caminho_de_pedestres <- as_edge_graph(caminho);

		create pessoas;
	}
	
	int students_E_initial <- 0;
	int nb_E_students <- students_E_initial update: pessoas count (each.is_exposed);
	
	int students_I_initial <- 2;
	int nb_I_students <- students_I_initial update: pessoas count (each.is_infected ); 
		
	int students_R_initial <- 0;
	int nb_R_students <- students_R_initial update: pessoas count (each.is_recovered);
	
	int nb_S_students -> n_pessoas - nb_E_students - nb_I_students - nb_R_students;
}