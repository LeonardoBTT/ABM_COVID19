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

	bool texturas <- false;
	
//	Definindo variáveis que controlam o tempo do modelo
	float step <- 60 #s;
	date starting_date <- date("2022-01-01 05:30:00");
		
//	Definindo uma variável que será usada futuramente para que o agente ande sobre os caminhos
	graph caminho_de_pedestres;

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

		create pessoas number: 100;		
	}
}