/*
 * Salgado.cpp
 *
 *  Created on: May 30, 2017
 *      Author: rosariopfernandes
 */

#include "Salgado.h"
#include <iostream>

//using namespace std;

Salgado::Salgado()
{
	this->id = 0;
	this->idEncomenda = 0;
	this->nomeSalgado = "";
	this->qtd = 0;
	this->frito = ' ';
	this->piri = ' ';
	this->preco = 0.0f;
}

Salgado::Salgado(int id,int idEncomenda,string nomeSalgado,int qtd,char piri,char frito, float preco)
{
	this->id = id;
	this->idEncomenda = idEncomenda;
	this->nomeSalgado = nomeSalgado;
	this->qtd = qtd;
	this->frito = frito;
	this->piri = piri;
	this->preco = preco;
	if(frito)
		preco+=30;
}

Salgado::Salgado(int id,string nomeSalgado,float preco)
{
	this->id = id;
	this->idEncomenda = 0;
	this->nomeSalgado = nomeSalgado;
	this->qtd = 0;
	this->frito = 'n';
	this->piri = 'n';
	this->preco = preco;
}

int Salgado::getId()
{
	return id;
}

int Salgado::getIdEncomenda()
{
	return idEncomenda;
}

string Salgado::getNomeSalgado()
{
	return nomeSalgado;
}

int Salgado::getQtd()
{
	return qtd;
}

char Salgado::getFrito()
{
	return frito;
}

char Salgado::getPiri()
{
	return piri;
}

float Salgado::getPreco()
{
	return preco;
}

void Salgado::setIdEncomenda(int iE){
	idEncomenda = iE;
}

void Salgado::setNomeSalgado(string n){
	nomeSalgado = n;
}

void Salgado::setQtd(int q){
	qtd = q;
}

void Salgado::setFrito(char f){
	frito = f;
}

void Salgado::setPiri(char p){
	piri = p;
}

void Salgado::setPreco(float preco){
	this->preco = preco;
	if(frito)
		preco+=30;
}

string Salgado::toString()
{
	//TODO: Concatenar string com int
	//string precoTxt = preco+"";
	return id+" "+nomeSalgado+" "+piri+" "+frito;//+" "+precoTxt;//"#"+"#"+nomeSalgado+"#"+nomeSalgado;// id+ "#" + idEncomenda+"#"; //+ nomeSalgado ; //"#" + qtd + "#"+ piri* +"#"+frito;
}
