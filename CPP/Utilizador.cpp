/*
 * Utilizador.cpp
 *
 *  Created on: May 30, 2017
 *      Author: rosariopfernandes
 */

#include "Utilizador.h"

#include <iostream>

using namespace std;

Utilizador::Utilizador()
{
	this->id=0;
	this->nome="";
	this->nomeUtilizador="";
	this->senha="";
	this->tipo="";
}


Utilizador::Utilizador(int id,string nome,string nomeUtilizador,string senha,string tipo)
{
	this->id=id;
	this->nome=nome;
	this->nomeUtilizador=nomeUtilizador;
	this->senha=senha;
	this->tipo=tipo;
}

int Utilizador::getId()
{
	return id;
}

string Utilizador::getNome()
{
	return nome;
}

string Utilizador::getNomeUtilizador()
{
	return nomeUtilizador;
}

string Utilizador::getSenha()
{
	return senha;
}

string Utilizador::getTipo()
{
	return tipo;
}

void Utilizador::setNome(string nome)
{
	this->nome = nome;
}
void Utilizador::setNomeUtilizador(string nomeUtilizador)
{
	this->nomeUtilizador = nomeUtilizador;
}
void Utilizador::setSenha(string senha)
{
	this->senha = senha;
}

void Utilizador::setTipo(string tipo)
{
	this->tipo = tipo;
}

string Utilizador::toString()
{
	return id+" "+nome+" "+nomeUtilizador+" "+senha+" "+tipo;
}
