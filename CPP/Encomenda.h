/*
 * Encomenda.h
 *
 *  Created on: May 30, 2017
 *      Author: rosariopfernandes
 */

#ifndef ENCOMENDA_H_
#define ENCOMENDA_H_

#include <iostream>
#include <string>
#include <vector>
#include "Salgado.h"

using namespace std;

class Encomenda {
	int idEncomenda;
	string nomeCliente;
	float total;
	vector <Salgado> lista;
	string estado;

public:
	Encomenda();
	Encomenda(int idEncomenda, string nomeCliente, vector <Salgado> lista, float total, string estado);

	int getId();
	string getNomeCliente();
	float getTotal();
	vector <Salgado> getLista();
	string getEstado();

	void setNomeCliente(string nomeCliente);
	void setTotal(float total);
	void setLista(vector <Salgado> lista);
	void setEstado(string estado);

	string toString();
};

#endif /* ENCOMENDA_H_ */
