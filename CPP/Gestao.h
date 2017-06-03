/*
 * Gestao.h
 *
 *  Created on: May 30, 2017
 *      Author: rosariopfernandes
 */

#include <iostream>
#include <string>
#include <vector>
#include "Salgado.h"
#include "Utilizador.h"
#include "Encomenda.h"

#ifndef Gestao_H_
#define Gestao_H_

using namespace std;

class Gestao {

	vector <Utilizador> utilizadores;
	vector <Encomenda> encomendas;
	vector <Salgado> stock;

	//Utilitários
	vector <string> dividir(char text[]);

	//Validacoes
	char validarSN(string msg);
	int validarNR(string msg, int min, int max);
	char validarABC(string msg);

	//Utilizadores
	int getNextUtilizador();
	void lerUtilizadores();
	void escreverUtilizadores();
	void adicionarUtilizador(int id, string nome, string nomeUser, string senha, string tipo);
	void alterarSenha(Utilizador user);
	void alterarNome(Utilizador user);
	void verUtilizador(int id);
	void menuUtilizador(int id);
	void alterarUtilizador(int id);
	void removerUtilizador(int id);

	//Stock
	int getNextStock();
	void lerStock();
	void escreverStock();
	void adicionarStock(int id, string nome, float preco);
	void menuStock(int id);
	Salgado getStockById(int idSalgado);
	void alterarStock(int idSalgado);
	void removerStock(int idSalgado);

	//Encomendas
	int getNextEncomenda();
	void lerEncomendas();
	void escreverEncomendas();
	void adicionarEncomenda(int id, string nomeCliente, vector<Salgado> lista,
			float total, string estado);
	void calcularTroco(float valor);
	void verEncomenda(int idEncomenda, string tipoUser);
	void menuEncomenda(int idEnc);
	void menuEncomendaAdmin(int idEnc);
	void menuEncomendaCoz(int idEnc);
	Encomenda alterarEstado(Encomenda enc, string estado);

	//Salgados
	vector <Salgado> lerSalgados();
	void verSalgados(int idEncomenda);
	void escreverSalgados(vector <Salgado> salgados);
	Salgado novoSalgado(Salgado stock, int idEncomenda);
	vector <Salgado> getSalgadosByEnc(int idEncomenda, vector <Salgado> todosSal);

public:
	Gestao();

	void novoUtilizador();
	void verUtilizadores();
	Utilizador login(string nomeUser, string senha);
	void minhaConta(int idUtilizador);
	Utilizador utilizadorById(int utilizador);

	void novoStock();
	void verStock();

	void verSalgado();

	void novaEncomenda(string cliente);
	void verEncomendas();
	void verEstatisticas();
	void verEstatisticasCli(string cliente);
	void verEncomendasCozinheiro();
	void verEncomendasCliente(string cliente);

	void carregarDados();
	void salvarDados();
	void sobreProg();
};

#endif
