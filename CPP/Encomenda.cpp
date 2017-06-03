/*
 * Encomenda.cpp
 *
 *  Created on: May 30, 2017
 *      Author: rosariopfernandes
 */

#include "Encomenda.h"

Encomenda::Encomenda(){

}

Encomenda::Encomenda(int i, string n,vector <Salgado> li, float tot, string e)
{
	idEncomenda = i;
	nomeCliente = n;
	total = tot;
	lista = li;
	estado = e;
}

int Encomenda::getId()
{
	return idEncomenda;
}

string Encomenda::getNomeCliente()
{
	return nomeCliente;
}

float Encomenda::getTotal()
{
	return total;
}

vector <Salgado> Encomenda::getLista()
{
	return lista;
}

string Encomenda::getEstado()
{
	return estado;
}

void Encomenda::setNomeCliente(string n){
	nomeCliente = n;
}

void Encomenda::setTotal(float tot){
	total = tot;
}

void Encomenda::setLista(vector <Salgado> lis){
	lista = lis;
}

void Encomenda::setEstado(string e){
	estado = e;
}

string Encomenda::toString()
{
	return "";//id+"#"+nomeCliente+"#"+total+"#"+estado;
}
