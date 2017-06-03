/*
 * Menu.h
 *
 *  Created on: May 31, 2017
 *      Author: rosariopfernandes
 */

#ifndef MENU_H_
#define MENU_H_

#include "Gestao.h"

using namespace std;

class Menu {
	Gestao gestao;

public:
	Menu();

	void entrar();

	void menuAdministrador(int utilizador);
	void menuGerirUsers(/*int utilizador*/);

	void menuCliente(int utilizador);

	void menuCozinheiro(int utilizador);


};

#endif /* MENU_H_ */
