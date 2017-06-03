/*
 * Gestao.cpp
 *
 *  Created on: May 30, 2017
 *      Author: rosariopfernandes
 */

#include "Gestao.h"
#include "Utilizador.h"
#include "Salgado.h"
#include "Encomenda.h"
#include <stdlib.h>
#include <iostream>
#include <fstream>
#include <string>

using namespace std;

Gestao::Gestao(){
}

//Utilitários
vector <string> Gestao::dividir(char text[])
{
	vector <string> linhas;
	char* linha = (char *) calloc(256, sizeof(linha));
	int tamanho = ((string) text).length();
	linha = text;
	char* palavra = (char *) calloc(256, sizeof(palavra));
	int indicePalavra = 0;

	char caracter;
	for(int i = 0; i< tamanho;i++)
	{
		caracter = linha[i];
		if(caracter == '#')
		{
			linhas.push_back(palavra);
			indicePalavra = 0;
			palavra = (char *) calloc(256, sizeof(palavra));
		}
		else
		{
			palavra[indicePalavra] = caracter;
			indicePalavra++;
		}
	}
	linhas.push_back(palavra);
	indicePalavra = 0;
	free(palavra);

	return linhas;
}

//VALIDACOES
string validarString(string msg)
{
	string texto;
	char linha[256];
	do
	{
		cout << msg << endl;
		cin.getline(linha, sizeof(linha));
		texto = linha;
		cout << "Linha:" << linha<< endl;
		if(sizeof(texto)<3)
			cout << "Ocorreu um erro. Por favor, re-introduza." << endl;
	}
	while(sizeof(texto)<3);
	return texto;
}

char Gestao::validarSN(string msg)
{
	char resp;
	do
	{
		cout << msg;
		cin >> resp;
		resp = tolower(resp);
		if(resp!='n' && resp!='s')
			cout << "Resposta inválida. Por favor introduza S ou N.";
	}
	while(resp!='n' && resp!='s');
	return resp;
}

int Gestao::validarNR(string msg, int min, int max)
{
	int resp;
	do
	{
		cout << msg << endl;
		cin >> resp;
		if(resp<min)
			cout << "Resposta inválida. Por favor introduza um número superior a " << min;
		if(resp>max)
			cout << "Resposta inválida. Por favor introduza um número inferior a " << max;
	}
	while(resp<min || resp>max);
	return resp;
}

char Gestao::validarABC(string msg)
{
	char resp;
	do
	{
		cout << msg;
		cin >> resp;
		resp = tolower(resp);
		if(resp!='a' && resp!='b' && resp!='c')
			cout << "Resposta inválida. Por favor introduza a, b ou c.";
	}
	while(resp!='a' && resp!='b' && resp!='c');
	return resp;
}

//UTILIZADORES

int Gestao::getNextUtilizador()
{
	int maiorId = -1;
	for(int i = 0; i< utilizadores.size(); i++)
	{
		if(utilizadores[i].getId()>maiorId)
			maiorId = utilizadores[i].getId();
	}
	return (maiorId+1);
}

void Gestao::lerUtilizadores()
{
	utilizadores.clear();
	char linha[256];
	int id;
	string nome, nomeUser, senha, tipo;
    ifstream is("Utilizadores.txt");
    if(!is)
    {
    	adicionarUtilizador(1, "Administrador do Sistema", "admin", "admin", "Administrador");
    	cout << "Obrigado por instalar o nosso sistema! :)"<< endl;
    	cout << "Para utilizar o sistema pela primeira vez, utilize o username admin e a senha admin."<< endl;
    	is.close();
    	return;
    }
    while(is.getline(linha, sizeof(linha)))
	{
    	vector <string> palavras = dividir(linha);
    	id = atoi(palavras[0].c_str());
    	nome = palavras[1];
    	nomeUser = palavras[2];
    	senha = palavras[3];
    	tipo = palavras[4];
    	adicionarUtilizador(id, nome, nomeUser, senha, tipo);
    }
    is.close();
}

void Gestao::escreverUtilizadores()
{
    ofstream os("Utilizadores.txt");
    for(int i = 0; i< utilizadores.size(); i++)
    {
    	os << utilizadores[i].getId() << "#"
		<< utilizadores[i].getNome() << "#"
		<< utilizadores[i].getNomeUtilizador() <<"#"
		<< utilizadores[i].getSenha() <<"#"
		<< utilizadores[i].getTipo() << "\n";
    }
    os.close();
}

void Gestao::novoUtilizador()
{
	int id = getNextUtilizador();
	string nome, nomeUser, tipo;
	cout << "Introduza o nome completo do utilizador: \n";
	cin >> nome;
	cout << "Introduza o nome de utilizador: \n";
	cin >> nomeUser;
	cout << "Introduza o tipo do utilizador: \n";
	cin >> tipo;
	adicionarUtilizador(id, nome, nomeUser, "isctem", tipo);
}

void Gestao::adicionarUtilizador(int id, string nome, string nomeUser,string senha, string tipo)
{
	Utilizador user(id, nome, nomeUser, senha, tipo);
	utilizadores.push_back(user);
}

Utilizador Gestao::login(string nomeUser, string senha)
{
	for (int i = 0; i < utilizadores.size(); ++i) {
		if(utilizadores[i].getNomeUtilizador()==nomeUser &&
				utilizadores[i].getSenha() == senha)
			return utilizadores[i];
	}
	Utilizador u;
	return u;
}

void Gestao::verUtilizadores()
{
	printf("%6s | %16s | %14s | %14s \n", "Cód.",
			"Nome Completo", "Nome no sistema", "Tipo");
	for (int i = 0; i < utilizadores.size(); ++i)
	{
		printf("%6d | %16s | %14s | %14s \n", utilizadores[i].getId(),
				utilizadores[i].getNome().c_str(), utilizadores[i].getNomeUtilizador().c_str(),
				utilizadores[i].getTipo().c_str());
	}
	int id;
	cout << endl << "Introduza o Código de um dos utilizadores para selecioná-lo ou 0 para voltar." <<endl;
	cin >> id;
	verUtilizador(id);
}

void Gestao::verUtilizador(int id)
{
	Utilizador util;
	bool existe = false;
	for(int i = 0; i < utilizadores.size();i++)
	{
		if(utilizadores[i].getId() == id)
		{
			util = utilizadores[i];
			existe = true;
			break;
		}
	}
	if(!existe)
	{
		cout << "Não existe nenhum utilizador com esse código."  << endl;
		return;
	}
	menuUtilizador(id);
}

void Gestao::menuUtilizador(int id)
{
	int op;
	Utilizador user;
	int pos = 0;
	do
	{
		do
		{
			cout << "1. Alterar" << endl;
			cout << "2. Remover" << endl;
			cout << "0. Voltar" << endl;
			cin >> op;
			if(op<0 || op>2)
				cout << "Opção inválida. Por favor, re-introduza:" << endl;
		}
		while(op<0 || op>2);
		for(int i = 0; i< utilizadores.size(); i++)
		{
			if(utilizadores[i].getId() == id)
			{
				user = utilizadores[i];
				pos = i;
			}
		}
		switch(op)
		{
			case 0: break;
			case 1:
//				alterarUtilizador(id);
				break;
			case 2:
	//			removerUtilizador(id);
				break;
		}
	}
	while(op!=0);
}


void Gestao::alterarUtilizador(int id)
{
	Salgado sal;
	//Utilizador
	int pos = 0;
	for(int i = 0 ; i < stock.size(); i++)
	{
		if(stock[i].getId() == id)
		{
			sal = stock[i];
			pos = i;
		}
	}
	string nome;
	float preco;
	cout << "Nome do Salgado:"<< endl;
	cin >> nome;
	cout << "Preço:"<< endl;
	cin >> preco;

	sal.setNomeSalgado(nome);
	sal.setPreco(preco);
	stock[pos] = sal;
	cout << "Alterado com sucesso!" << endl ;
}

void Gestao::removerUtilizador(int id)
{
	Salgado sal;
	int pos = 0;
	for(int i = 0 ; i < stock.size(); i++)
	{
		if(stock[i].getId() == id)
			pos = i;
	}
	stock[pos] = sal;
	cout << "Removido com sucesso!" << endl ;
}

void Gestao::minhaConta(int id)
{
	int op;
	Utilizador user;
	do
	{
		do
		{
			user = utilizadorById(id);
			cout <<  " Minha Conta" << endl;
			cout <<  user.getTipo() << endl;
			cout <<  "Nome:" << user.getNome() << endl;
			cout <<  "Nome de utilizador:" << user.getNomeUtilizador() << endl;
			cout << "1. Alterar Senha" << endl;
			cout << "2. Alterar Nome" << endl;
			cout << "0. Voltar" << endl;
			cin >> op;
			if(op<0 || op>2)
				cout << "Opção inválida. Tente novamente." << endl;
		}while(op<0 || op>2);
		switch(op)
		{
			case 0:
				break;
			case 1: alterarSenha(user);
				break;
			case 2:
				alterarNome(user);
				break;
		}
	}while(op!=0);
	verUtilizadores();
}

Utilizador Gestao::utilizadorById(int id)
{
	Utilizador a;
	for(int i = 0;i< utilizadores.size(); i++)
	{
		if(utilizadores[i].getId() == id)
			return utilizadores[i];
	}
	return a;
}

void Gestao::alterarSenha(Utilizador user)
{
	string actual, nova, reNova;
	cout << "Introduza a senha actual:"<< endl;
	cin >> actual;
	if(actual == user.getSenha())
	{
		cout << "Introduza a nova senha:" << endl;
		cin >> nova;
		cout << "Re-introduza a nova senha:" << endl;
		cin >> reNova;
		if(nova == reNova)
		{
			for(int i = 0; i< utilizadores.size(); i++)
			{
				if(utilizadores[i].getId() == user.getId())
				{
					utilizadores[i].setSenha(nova);
					cout << "Senha alterada com sucesso!"<< endl;
				}
			}
		}
		else
		{
			cout << "As novas senhas não correspondem!"<< endl;
		}
	}
	else
	{
		cout << "Senha incorrecta!"<< endl;
	}
}

void Gestao::alterarNome(Utilizador user)
{
	string nome;
	cout << "Introduza o novo nome:"<< endl;
	cin >> nome;
	for(int i = 0; i< utilizadores.size(); i++)
	{
		if(utilizadores[i].getId() == user.getId())
		{
			utilizadores[i].setNome(nome);
			cout << "Nome alterado com sucesso!" << endl;
		}
	}
}

//STOCK
int Gestao::getNextStock()
{
	int maiorId = -1;
	for(int i = 0; i< stock.size(); i++)
	{
		if(stock[i].getId()>maiorId)
			maiorId = stock[i].getId();
	}
	return (maiorId+1);
}

void Gestao::lerStock()
{
	stock.clear();
	char linha[256];
	int id;
	string nome;
	float preco;
    ifstream is("Stock.txt");
    if(!is)
    {
    	/*cout << "Você ainda não adicionou nenhum salgado para encomenda."<< endl;
    	cout << "Para fazer isso, entre com a sua conta de administrador e escolha 'Novo Salgado'."
    			<< endl << endl;*/
    	adicionarStock(1, "Chamussas", 190);
    	adicionarStock(2, "Rissois", 190);
    	adicionarStock(3, "Spring rolls", 190);
    	is.close();
    	return;
    }
    while(is.getline(linha, sizeof(linha)))
	{
    	vector <string> palavras = dividir(linha);
    	id = atoi(palavras[0].c_str());
    	nome = palavras[1];
    	preco = atof(palavras[2].c_str());
    	adicionarStock(id, nome, preco);
    }
    is.close();
}

void Gestao::escreverStock()
{
    ofstream os("Stock.txt");
    for(int i = 0; i< stock.size(); i++)
    {
    	if(stock[i].getId() != 0)
    		os << stock[i].getId() <<"#"<< stock[i].getNomeSalgado() << "#" <<stock[i].getPreco() << "\n";
    }
    os.close();
}

void Gestao::novoStock()
{
	int id = getNextStock();
	float preco;
	string nome;
	//cout << ;
	//cin >> nome;
	nome = validarString("Introduza o nome do salgado: \n");
	cout << "Introduza o preco do salgado: \n";
	cin >> preco;
	adicionarStock(id, nome, preco);
}

void Gestao::adicionarStock(int id, string nome, float preco)
{
	Salgado salgado(id, nome, preco);
	stock.push_back(salgado);
}

Salgado Gestao::getStockById(int id)
{
	for (int i = 0; i < stock.size(); ++i) {
		if(stock[i].getId() == id)
			return stock[i];
	}
	Salgado a;
	return a;
}

void Gestao::menuStock(int idStock)
{
	int op;
	Salgado salgado;
	int pos = 0;
	do
	{
		do
		{
			cout << "1. Alterar" << endl;
			cout << "2. Remover" << endl;
			cout << "0. Voltar" << endl;
			cin >> op;
			if(op<0 || op>2)
				cout << "Opção inválida. Por favor, re-introduza:" << endl;
		}
		while(op<0 || op>2);
		for(int i = 0; i< stock.size(); i++)
		{
			if(stock[i].getId() == idStock)
			{
				salgado = stock[i];
				pos = i;
			}
		}
		switch(op)
		{
			case 0: break;
			case 1: alterarStock(idStock);
				break;
			case 2: removerStock(idStock);
				break;
		}
	}
	while(op!=0);
}

void Gestao::alterarStock(int id)
{
	Salgado sal;
	int pos = 0;
	for(int i = 0 ; i < stock.size(); i++)
	{
		if(stock[i].getId() == id)
		{
			sal = stock[i];
			pos = i;
		}
	}
	string nome;
	float preco;
	cout << "Nome do Salgado:"<< endl;
	cin >> nome;
	cout << "Preço:"<< endl;
	cin >> preco;

	sal.setNomeSalgado(nome);
	sal.setPreco(preco);
	stock[pos] = sal;
	cout << "Alterado com sucesso!" << endl ;
}

void Gestao::removerStock(int id)
{
	Salgado sal;
	int pos = 0;
	for(int i = 0 ; i < stock.size(); i++)
	{
		if(stock[i].getId() == id)
			pos = i;
	}
	stock[pos] = sal;
	cout << "Removido com sucesso!" << endl ;
}

void Gestao::verStock()
{
	printf("%6s | %16s | %12s \n","Cód", "Salgado", "Preço(Mtn)");
	for (int i = 0; i < stock.size(); ++i) {
		printf("%5d | %16s | %12.2f \n", stock[i].getId(),
				stock[i].getNomeSalgado().c_str(), stock[i].getPreco());
	}
}

//ENCOMENDAS

int Gestao::getNextEncomenda()
{
	int maiorId = 0;
	for(int i = 0; i< encomendas.size(); i++)
	{
		if(encomendas[i].getId()>maiorId)
			maiorId = encomendas[i].getId();
	}
	return (maiorId+1);
}

void Gestao::lerEncomendas()
{
	encomendas.clear();
	int id;
	char linha[256];
	string nomeCliente, estado;
	float total;
	vector <Salgado> todosSal = lerSalgados();
    ifstream is("Encomendas.txt");
    while(is.getline(linha, sizeof(linha)))
	{
    	vector <string> palavras = dividir(linha);
    	id = atoi(palavras[0].c_str());
    	nomeCliente = palavras[1];
    	total = atof(palavras[2].c_str());
    	estado = palavras[3];
    	vector <Salgado> lista = getSalgadosByEnc(id, todosSal);
    	adicionarEncomenda(id, nomeCliente, lista, total, estado);
    }
    is.close();
}

void Gestao::escreverEncomendas()
{
    ofstream os("Encomendas.txt");
    for(int i = 0; i< encomendas.size(); i++)
    {
    	if(encomendas[i].getId()!=0)
    	{
    		os << encomendas[i].getId() << "#"
    				<< encomendas[i].getNomeCliente() << "#"
					<< encomendas[i].getTotal() <<"#"
					<< encomendas[i].getEstado() << "\n";
    		escreverSalgados(encomendas[i].getLista());
    	}
    }
    os.close();
}

void Gestao::novaEncomenda(string cliente)
{
	int idEncomenda, op;
	float total = 0;
	Encomenda encomenda;
	vector <Salgado> lista;
	idEncomenda = getNextEncomenda();
	do
	{
		verStock();
		if(lista.empty())
			cout << "Introduza 0 para Cancelar a encomenda."<<endl;
		else
			cout << "Introduza 0 Terminar."<<endl;
		cin >> op;
		if(op==0)
		{
			if(lista.empty())
				cout << "Encomenda Cancelada." << endl;
			else
			{
				adicionarEncomenda(idEncomenda, cliente, lista, total, "Pendente");
				calcularTroco(total);
				cout << "Encomenda Efectuada com sucesso!" << endl;
			}
		}
		else
		{
			Salgado stock = getStockById(op);
			if(stock.getId()==0)
				cout << "Não existe nenhum salgado com esse ID."<<endl;
			else
			{
				Salgado novo = novoSalgado(stock, idEncomenda);
				total+=novo.getPreco();
				lista.push_back(novo);
			}
		}
	}
	while(op!=0);
}

void Gestao::calcularTroco(float total)
{
	float valor, troco;
	cout << "Valor a pagar: "<< total <<"Mtn."<< endl;
	do
	{
		cout << "Valor entregue: " << endl;
		cin >> valor;
		if(valor < total)
			cout << "O valor não pode ser menor que o valor a pagar." << endl;
	}while(valor< total);
	troco = valor - total;
	cout << "Troco: " << troco <<"Mtn."<< endl;
}

void Gestao::adicionarEncomenda(int id, string cliente, vector<Salgado> lista,
		float total, string estado)
{
	Encomenda encomenda(id, cliente, lista, total, estado);
	encomendas.push_back(encomenda);
}

void Gestao::verEncomendas()
{
	if(encomendas.empty())
	{
		cout << "Ainda não existe nenhuma encomenda.";
		return;
	}
	printf("%6s | %24s | %12s \n", "Cód.",
			"Nome do Cliente", "Total(Mtn)");
	for (int i = 0; i < encomendas.size(); ++i) {
		printf("%5d | %25s | %12.2f \n", encomendas[i].getId(),
				encomendas[i].getNomeCliente().c_str(), encomendas[i].getTotal());
	}
	int id;
	cout<< "Introduza o código de uma das encomendas para selecioná-la ou 0 para voltar."<< endl;
	cin >> id;
	verEncomenda(id, "Administrador");
}

void Gestao::verEncomenda(int idEncomenda, string tipo)
{
	Encomenda enc;
	bool existe = false;
	for(int i = 0; i < encomendas.size();i++)
	{
		if(encomendas[i].getId() == idEncomenda)
		{
			enc = encomendas[i];
			existe = true;
			break;
		}
	}
	if(!existe)
	{
		cout << "Não existe nenhuma encomenda com esse código."  << endl;
		return;
	}
	cout << "Nome do Cliente: " << enc.getNomeCliente().c_str() << endl;
	verSalgados(idEncomenda);
	printf("%10s Total: %6.2f \n"," ", enc.getTotal());
	if(tipo =="Administrador")
		menuEncomendaAdmin(idEncomenda);
	else
		if(tipo== "Cozinheiro")
			menuEncomendaCoz(idEncomenda);
		else
			menuEncomenda(idEncomenda);
}

void Gestao::menuEncomenda(int idEncomenda)
{
	int op;
	Encomenda encomenda;
	int pos = 0;
	do
	{
		do
		{
			cout << "1. Levantar Encomenda" << endl;
			cout << "2. Cancelar Encomenda" << endl;
			cout << "0. Voltar" << endl;
			cin >> op;
			if(op<0 || op>2)
				cout << "Opção inválida. Por favor, re-introduza:" << endl;
		}
		while(op<0 || op>2);
		for(int i = 0; i< encomendas.size(); i++)
		{
			if(encomendas[i].getId() == idEncomenda)
			{
				encomenda = encomendas[i];
				pos = i;
			}
		}
		switch(op)
		{
			case 0: break;
			case 1:
				if(encomenda.getEstado()!="Pronta")
				{
					cout << "Não pode levantar esta encomenda porque ainda não está pronta." << endl;
				}
				else
				{
					encomendas[pos] = alterarEstado(encomenda, "Levantada");
					cout << "Encomenda levantada!" << endl;
				}
				break;
			case 2:
				encomendas[pos] = alterarEstado(encomenda, "Cancelada");
				cout << "Encomenda cancelada!" << endl;
				break;
		}
	}
	while(op!=0);
}

void Gestao::menuEncomendaAdmin(int idEncomenda)
{
	int op;
	Encomenda encomenda;
	int pos = 0;
	do
	{
		do
		{
			cout << "1. Levantar Encomenda" << endl;
			cout << "2. Cancelar Encomenda" << endl;
			cout << "3. Encomenda Pronta" << endl;
			cout << "4. Aprovar Encomenda" << endl;
			cout << "5. Remover Encomenda" << endl;
			cout << "0. Voltar" << endl;
			cin >> op;
			if(op<0 || op>5)
				cout << "Opção inválida. Por favor, re-introduza:" << endl;
		}
		while(op<0 || op>5);
		for(int i = 0; i< encomendas.size(); i++)
		{
			if(encomendas[i].getId() == idEncomenda)
			{
				encomenda = encomendas[i];
				pos = i;
			}
		}
		switch(op)
		{
			case 0: break;
			case 1:
				encomendas[pos] = alterarEstado(encomenda, "Levantada");
				cout << "Encomenda levantada!" << endl;
				break;
			case 2:
				encomendas[pos] = alterarEstado(encomenda, "Cancelada");
				cout << "Encomenda cancelada!" << endl;
				break;
			case 3:
				encomendas[pos] = alterarEstado(encomenda, "Pronta");
				cout << "Encomenda pronta!" << endl;
				break;
			case 4:
				if(encomenda.getEstado() != "Pendente")
				{
					cout <<  "Não pode aprovar esta encomenda porque já foi "<< encomenda.getEstado()
							<< "." << endl;
				}
				else
				{
					encomendas[pos] = alterarEstado(encomenda, "Aprovada");
					cout << "Encomenda aprovada!" << endl;
				}
				break;
			case 5:
				Encomenda encomenda;
				encomendas[pos] = encomenda;
				cout << "Encomenda Removida!" << endl;
				break;
		}
	}
	while(op!=0);
}

void Gestao::menuEncomendaCoz(int idEncomenda)
{
	int op;
	Encomenda encomenda;
	int pos = 0;
	do
	{
		do
		{
			cout << "1. Encomenda Pronta" << endl;
			cout << "0. Voltar" << endl;
			cin >> op;
			if(op<0 || op>1)
				cout << "Opção inválida. Por favor, re-introduza:" << endl;
		}
		while(op<0 || op>1);
		for(int i = 0; i< encomendas.size(); i++)
		{
			if(encomendas[i].getId() == idEncomenda)
			{
				encomenda = encomendas[i];
				pos = i;
			}
		}
		switch(op)
		{
			case 0: break;
			case 1:
				if(encomenda.getEstado()!="Aprovada")
				{
					cout << "Não pode aprontar esta encomenda porque ainda não foi aprovada." << endl;
				}
				else
				{
					encomendas[pos] = alterarEstado(encomenda, "Pronta");
					cout << "Encomenda Pronta!" << endl;
				}
				break;
		}
	}
	while(op!=0);
}

Encomenda Gestao::alterarEstado(Encomenda enc, string estado)
{
	enc.setEstado(estado);
	return enc;
}

void Gestao::verEstatisticas()
{
	if(encomendas.empty())
	{
		cout << "Ainda não existe nenhuma encomenda.";
		return;
	}
	float totalGanho = 0.0f;
	int encomendasFeitas = 0;

	for (int i = 0; i < encomendas.size(); ++i)
	{
		totalGanho+=encomendas[i].getTotal();
		encomendasFeitas++;
	}

	cout << "Total ganho pela loja: "<<totalGanho<<"Mtn."<<endl;
	cout << "Encomendas Feitas: "<<encomendasFeitas<<endl;
	/*cout << "Salgado mais comprado:"<<endl;
	cout << "Salgado menos comprado:"<<endl;*/
}

void Gestao::verEstatisticasCli(string nomeCliente)
{
	if(encomendas.empty())
	{
		cout << "Ainda não existe nenhuma encomenda.";
		return;
	}
	float totalGanho = 0.0f;
	int encomendasFeitas = 0;

	for (int i = 0; i < encomendas.size(); ++i)
	{
		if(encomendas[i].getNomeCliente() == nomeCliente)
		{
			totalGanho+=encomendas[i].getTotal();
			encomendasFeitas++;
		}
	}

	cout << "Total ganho pela loja: "<<totalGanho<<"Mtn."<<endl;
	cout << "Encomendas Feitas: "<<encomendasFeitas<<endl;
	/*cout << "Salgado mais comprado:"<<endl;
	cout << "Salgado menos comprado:"<<endl;*/
}

void Gestao::verEncomendasCozinheiro()
{
	if(encomendas.empty())
	{
		cout << "Ainda não existe nenhuma encomenda.";
		return;
	}
	printf("%6s | %24s | %12s \n", "Cód.",
			"Nome do Cliente", "Estado");
	for (int i = 0; i < encomendas.size(); ++i) {
		if(encomendas[i].getEstado() == "Aprovada")
		{
			printf("%5d | %25s | %12s \n", encomendas[i].getId(),
				encomendas[i].getNomeCliente().c_str(), encomendas[i].getEstado().c_str());
		}
	}
	int id;
	cout<< "Introduza o código de uma das encomendas para selecioná-la ou 0 para voltar."<< endl;
	cin >> id;
	verEncomenda(id, "Cozinheiro");
}

void Gestao::verEncomendasCliente(string nomeCliente)
{
	if(encomendas.empty())
	{
		cout << "Ainda não existe nenhuma encomenda.";
		return;
	}
	printf("%6s | %24s | %12s | %12s \n", "Cód.",
			"Nome do Cliente", "Total(Mtn)", "Estado");
	for (int i = 0; i < encomendas.size(); ++i) {
		if(encomendas[i].getNomeCliente() == nomeCliente)
		{
			printf("%5d | %26s | %12.2f | %12s \n", encomendas[i].getId(),
					encomendas[i].getNomeCliente().c_str(), encomendas[i].getTotal(),
					encomendas[i].getEstado().c_str());
		}
	}
	int id;
	cout<< "Introduza o código de uma das encomendas para selecioná-la ou 0 para voltar."<< endl;
	cin >> id;
	verEncomenda(id, "Cliente");
}

//SALGADOS
Salgado Gestao::novoSalgado(Salgado stock, int idEncomenda)
{
	int  qtd;
	float preco = stock.getPreco();
	char piri, frito;
	cout << "Quantas dúzias? \n";
	cin >> qtd;
	piri = validarSN("Com piri-piri?(s/n) \n");
	frito = validarSN("Frito?(s/n) \n");
	preco*=qtd;
	Salgado salgado(stock.getId(), idEncomenda, stock.getNomeSalgado(), qtd, piri, frito, preco);
	return salgado;
}

void Gestao:: verSalgados(int idEncomenda)
{
	Encomenda enc;
	for(int i = 0; i < encomendas.size();i++)
	{
		if(encomendas[i].getId() == idEncomenda)
		{
			enc = encomendas[i];
			break;
		}
	}
	if(enc.getId() == 0)
	{
		cout << "Não há nenhum salgado nesta encomenda."  << endl;
		return;
	}
	printf("%6s | %24s | %5s | %6s | %6s | %6s \n", "Cód.",
			"Nome do Salgado", "Qtd", "Piri", "Frito", "Preço");
	vector <Salgado> lista = enc.getLista();
	for(int i = 0; i < lista.size(); i++)
	{
		printf("%5d | %24s | %5d | %6s | %6s | %6.2f \n", lista[i].getId(),
				lista[i].getNomeSalgado().c_str(), lista[i].getQtd(), lista[i].getPiri(),
				lista[i].getFrito(), lista[i].getPreco());
	}
}

vector <Salgado> Gestao::lerSalgados()
{
	vector <Salgado> lista;
	char linha[256];
	int id, idEncomenda, qtd;
	string nomeSal;
	float preco;
	char piri, frito;
    ifstream is("Salgados.txt");
    while(is.getline(linha, sizeof(linha)))
	{
    	vector <string> palavras = dividir(linha);
    	id = atoi(palavras[0].c_str());
    	idEncomenda = atoi(palavras[1].c_str());
    	nomeSal= palavras[2];
    	qtd = atoi(palavras[3].c_str());
    	piri = atoi(palavras[4].c_str());
    	frito = atoi(palavras[5].c_str()); //TODO change this in case of bugs
    	preco = atof(palavras[6].c_str());
    	Salgado salgado(id, idEncomenda, nomeSal, qtd, piri, frito, preco);
    	lista.push_back(salgado);
    }
    is.close();
    return lista;
}

void Gestao::escreverSalgados(vector <Salgado> salgados)
{
    ofstream os("Salgados.txt");
    string a, b;
	char* carac = (char *) calloc(1, sizeof(carac));

    for(int i = 0; i< salgados.size(); i++)
    {
    	a[0] = salgados[i].getPiri();
    	b[0] = salgados[i].getFrito();
    	cout << salgados[i].getPiri() <<","<< salgados[i].getFrito()<<endl;
    	os << salgados[i].getId() <<"#"
    	<< salgados[i].getIdEncomenda() <<"#"
		<< salgados[i].getNomeSalgado() <<"#"
		<< salgados[i].getQtd() <<"#"
		<< a.c_str() <<"#"
		<< b.c_str() <<"#"
		<< salgados[i].getPreco() << "\n";
    }
    os.close();
}

vector <Salgado> Gestao::getSalgadosByEnc(int idEncomenda, vector <Salgado> todosSal){
	vector <Salgado> salgados;
	for (int i = 0; i< todosSal.size(); i++)
	{
		if(todosSal[i].getId() == idEncomenda)
			salgados.push_back(todosSal[i]);
	}
	return salgados;
}

void Gestao::carregarDados()
{
	lerUtilizadores();
	lerEncomendas();
	lerStock();
}

void Gestao::salvarDados()
{
	escreverUtilizadores();
	escreverEncomendas();
	escreverStock();
}

void Gestao::sobreProg()
{
	cout << "==============================================="<< endl ;
	cout << "  Sistema de Gestão de Venda de Salgados v2.0 "<< endl ;
	cout << "  Desenvolvido por Rosário Pereira Fernandes"<< endl ;
	cout << "  2017 - ISCTEM (2º Ano Eng. Informática)"<< endl ;
	cout << "==============================================="<< endl ;
}
