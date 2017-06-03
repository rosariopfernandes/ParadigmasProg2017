/*
 * Salgado.h
 *
 *  Created on: May 30, 2017
 *      Author: rosariopfernandes
 */

#ifndef SALGADO_H_
#define SALGADO_H_

#include <iostream>
#include <string>

using namespace std;

class Salgado {

	int id, idEncomenda, qtd;
	string nomeSalgado;
	char frito, piri;
	float preco;

public:
	Salgado();
	Salgado(int id, int idEncomenda, string nomeSalgado, int qtd, char frito, char piri, float preco);
	Salgado(int id, string nomeSalgado, float preco);

	int getId();
	int getIdEncomenda();
	string getNomeSalgado();
	int getQtd();
	char getFrito();
	char getPiri();
	float getPreco();

	void setIdEncomenda(int i);
	void setNomeSalgado(string n);
	void setQtd(int q);
	void setFrito(char f);
	void setPiri(char p);
	void setPreco(float preco);

	string toString();
};

#endif /* SALGADO_H_ */
