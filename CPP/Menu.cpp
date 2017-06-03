/*
 * Menu.cpp
 *
 *  Created on: May 31, 2017
 *      Author: rosariopfernandes
 */

#include "Menu.h"
#include "Utilizador.h"
#include <iostream>

Menu::Menu()
{
	entrar();
}

void Menu::entrar()
{
	bool existe;
	Utilizador utilizador;
	string username, senha;
	do
	{
		gestao.carregarDados();
		cout << "SISTEMA DE GESTÃO DE VENDA DE SALGADOS"<<endl;
		cout << "Nome de utilizador:"<<endl;
		cin >> username;
		cout << "Senha:"<<endl;
		cin >> senha;
		utilizador = gestao.login(username, senha);
		if(utilizador.getId()!=0)
		{
			if(utilizador.getTipo()=="Administrador")
				menuAdministrador(utilizador.getId());
			else
				if(utilizador.getTipo()=="Cozinheiro")
					menuCozinheiro(utilizador.getId());
				else
					menuCliente(utilizador.getId());
		}
		else
			cout << "Nome do utilizador ou senha incorrecto(s)! Tente novamente." << endl;
	}
	while(utilizador.getId()==0);
}

void Menu::menuAdministrador(int utilizador)
{
	int op;
	Utilizador user;
	do
	{
		do
		{
			cout << "++++++++++Menu+++++++++++" << endl;
			cout << "1. Novo Salgado" << endl;
			cout << "2. Ver Salgados" << endl;
			cout << "3. Nova encomenda" << endl;
			cout << "4. Ver encomendas" << endl;
			cout << "5. Gerir Utilizadores" << endl;
			cout << "6. Ver estatísticas" << endl;
			cout << "7. Sobre o programa" << endl;
			cout << "8. Minha conta" << endl;
			cout << "9. Sair" << endl;
			cout << "+++++++++++++++++++++++++" << endl;
			cin >> op;
			if( op < 1 || op > 9)
				cout << "Opção inválida. Tente novamente." << endl;
		}
		while(op<1 || op>9);
		user = gestao.utilizadorById(utilizador);
		switch(op)
		{
			case 1:
				gestao.novoStock();
				break;
			case 2:
				gestao.verStock();
				break;
			case 3:
				gestao.novaEncomenda(user.getNome());
				break;
			case 4:
				gestao.verEncomendas();
				break;
			case 5:
				menuGerirUsers();
				break;
			case 6:
				gestao.verEstatisticas();
				break;
			case 7:
				gestao.sobreProg();
				break;
			case 8:
				gestao.minhaConta(user.getId());
				break;
			case 9:
				gestao.salvarDados();
				cout << "Adeus "+user.getNome()+"! \nAté breve :)\n\n";
				entrar();
				break;
		}
	}
	while(op!=9);
}

void Menu::menuCliente(int id)
{
	int op;
	Utilizador utilizador;
	do
	{
		do
		{
			utilizador = gestao.utilizadorById(id);
			cout << "++++++++++Menu+++++++++++" << endl;
			cout << "1. Nova encomenda" << endl;
			cout << "2. Ver encomendas" << endl;
			cout << "3. Ver estatísticas" << endl;
			cout << "4. Sobre o programa" << endl;
			cout << "5. Minha conta" << endl;
			cout << "6. Sair" << endl;
			cout << "+++++++++++++++++++++++++" << endl;
			cin >> op;
			if( op < 1 || op > 6)
				cout << "Opção inválida. Tente novamente." << endl;
		}
		while(op<1 || op>6);
		switch(op)
		{
			case 1:
				gestao.novaEncomenda(utilizador.getNome());
				break;
			case 2:
				gestao.verEncomendasCliente(utilizador.getNome());
				break;
			case 3:
				gestao.verEstatisticasCli(utilizador.getNome());
				break;
			case 4:
				gestao.sobreProg();
				break;
			case 5:
				gestao.minhaConta(utilizador.getId());
				break;
			case 6:
				gestao.salvarDados();
				cout << "Adeus "+utilizador.getNome()+"! \nAté breve :)\n\n";
				entrar();
				break;
		}
	}
	while(op!=6);
}

void Menu::menuCozinheiro(int id)
{
	int op;
	Utilizador utilizador;
	do
	{
		do
		{
			utilizador = gestao.utilizadorById(id);
			cout << "++++++++++Menu+++++++++++" << endl;
			cout << "1. Ver encomendas" << endl;
			cout << "2. Sobre o programa" << endl;
			cout << "3. Minha conta" << endl;
			cout << "4. Sair" << endl;
			cout << "+++++++++++++++++++++++++" << endl;
			cin >> op;
			if( op < 1 || op > 4)
				cout << "Opção inválida. Tente novamente." << endl;
		}
		while(op<1 || op>4);
		switch(op)
		{
			case 1:
				gestao.verEncomendasCozinheiro();
				break;
			case 2:
				gestao.sobreProg();
				break;
			case 3:
				gestao.minhaConta(utilizador.getId());
				break;
			case 4:
				gestao.salvarDados();
				cout << "Adeus "+utilizador.getNome()+"! \nAté breve :)\n\n";
				entrar();
				break;
		}
	}
	while(op!=4);
}

void Menu::menuGerirUsers()
{
	int op;
	do
	{
		do
		{
			cout << "1. Adicionar utilizador" << endl;
			cout << "2. Ver utilizadores" << endl;
			cout << "0. Voltar" << endl;
			cin >> op;
			if( op < 0 || op > 2)
				cout << "Opção inválida. Tente novamente." << endl;
		}
		while( op < 0 || op > 2);
		switch(op)
		{
			case 0:
				break;
			case 1:
				gestao.novoUtilizador();
				break;
			case 2:
				gestao.verUtilizadores();
				break;
		}
	}
	while(op!=0);
}
