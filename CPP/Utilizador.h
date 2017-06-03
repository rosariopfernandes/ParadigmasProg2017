/*
 * Utilizador.h
 *
 *  Created on: May 30, 2017
 *      Author: rosariopfernandes
 */

#include <iostream>
#include <string>

#ifndef Utilizador_H_
#define Utilizador_H_

using namespace std;

class Utilizador {

private:
	int id;
	string nome, nomeUtilizador, senha, tipo;

public:
	Utilizador();
	Utilizador(int id,string nome,string nomeUtilizador,string senha,string tipo);
	
	int getId();
	string getNome();
	string getNomeUtilizador();
	string getSenha();
	string getTipo();

	void setNome(string tipo);
	void setNomeUtilizador(string nomeUtilizador);
	void setSenha(string senha);
	void setTipo(string tipo);

	string toString();
};


#endif /*Utilizador_H_ */
