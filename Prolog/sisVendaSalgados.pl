/**
	Desenvolvido por: Rosário Pereira Fernandes (2016185)
**/
:- dynamic(user/5).
:- dynamic(salgado/7).
:- dynamic(encomenda/4).

%Contadores
:- dynamic(cont_user/1).
:- dynamic(cont_salgado/1).
:- dynamic(cont_encomenda/1).
:- dynamic(ganho/1).
:- dynamic(melhor/2).
:- dynamic(contador_stat/3).

:- set_prolog_flag(unknown, error). 

cont_encomenda(0).
cont_salgado(0).
cont_user(0).

incrementEnc :-
  retract(cont_encomenda(C)),
  succ(C, C1),
  assertz(cont_encomenda(C1)).

setLastEncomenda(C1):- 
  retract(cont_encomenda(C)),
  assertz(cont_encomenda(C1)).

incrementSalgado :-
  retract(cont_salgado(C)),
  succ(C, C1),
  assertz(cont_salgado(C1)).

setLastSalgado(C1):- 
  retract(cont_salgado(C)),
  assertz(cont_salgado(C1)).

incrementUser :-
  retract(cont_user(C)),
  succ(C, C1),
  assertz(cont_user(C1)).

setLastUser(C1):- 
  retract(cont_user(C)),
  assertz(cont_user(C1)).

incrementStat(Id, Qtd) :-
  retract(contador_stat(Id, Nome, C)),
  C1 is C + Qtd,
  assertz(contador_stat(Id, Nome, C1)).

char_resp('s').
char_resp('n').

%Utilities
print_then_run(String, F):- write(String), F.
print_invalid(F):- write('Opção inválida. Tente novamente!\n'), F.

print_concat(STR1, STR2):- write(STR1), write(STR2).
print_concat(STR1, STR2, STR3):- print_concat(STR1, STR2), write(STR3).

if_then_else(P,Q,R):- P, !, Q.
if_then_else(P,Q,R):- R.

soma(0, B, B).
soma(A, B, C):- C is A+B.

%Ler ficheiros
read_user(Stream) :- read(Stream, Id), ( at_end_of_stream(Stream) -> close(Stream);
							read(Stream, Nome), setLastUser(Id), read(Stream, NomeUser), read(Stream, Senha),
							read(Stream, Tipo), assertz(user(Id, Nome, NomeUser, Senha, Tipo)),
       						read_user(Stream)).
lerUsers:- open('Utilizadores.txt', read, Str), read_user(Str).

read_salgado(Stream) :- read(Stream, Id), ( at_end_of_stream(Stream) -> close(Stream);
							read(Stream, IdEnc), read(Stream, NomeSalgado), read(Stream, Qtd),
							read(Stream, Piri), read(Stream, Frito), read(Stream, Total),
							assertz(salgado(Id, IdEnc, NomeSalgado, Qtd, Piri, Frito, Total)),
       						read_salgado(Stream)).
lerSalgados:- open('Salgados.txt', read, Str), read_salgado(Str).

read_stock(Stream) :- read(Stream, Id), ( at_end_of_stream(Stream) -> close(Stream);
						read(Stream, NomeSalgado),setLastSalgado(Id), read(Stream, Preco),
						assertz(salgado(Id, 0, NomeSalgado, 0, '', '', Preco)),
       						read_stock(Stream)).
lerStock:- open('Productos.txt', read, Str), read_stock(Str).

read_enc(Stream) :- read(Stream, Id), ( at_end_of_stream(Stream) -> close(Stream);
							read(Stream, NomeCli), setLastEncomenda(Id), read(Stream, Total), read(Stream, Estado), 
							assertz(encomenda(Id, NomeCli, Total, Estado)),
       						read_enc(Stream)).
lerEncomendas:- open('Encomendas.txt', read, Str), read_enc(Str).

resetAll:- forall(salgado(Id, IdEnc, NomeSalgado, Qtd, Piri, Frito, Total),
			retract(salgado(Id, IdEnc, NomeSalgado, Qtd, Piri, Frito, Total))),
			forall(encomenda(Id, NomeCli, Total, Estado), retract(encomenda(Id, NomeCli, Total, Estado))),
			forall(user(Id, Nome, NomeUser, Senha, Tipo), retract(user(Id, Nome, NomeUser, Senha, Tipo))),
			setLastSalgado(0), setLastEncomenda(0), setLastUser(0).

lerNr(Variavel, Campo, Funcao):- if_then_else(
			catch((read(Variavel), number(Variavel)), error(Err,_Context),
				(write(Campo),write(' inexistente! Tente novamente: \n'), Funcao)), write(''),
			(write(Campo),write(' inexistente! Tente novamente: \n'), Funcao)).

ler(Variavel, Campo, Funcao):- if_then_else(
			catch((read(Variavel), (atom(Variavel); number(Variavel))), error(Err,_Context),
				(write(Campo),write(' inexistente! Tente novamente: \n'), Funcao)), write(''),
			(write(Campo),write(' inexistente! Tente novamente: \n'), Funcao)).

readSN(Variavel, Funcao):- if_then_else(
			catch((read(Variavel), atom(Variavel), char_resp(Variavel)), error(Err,_Context),
				(write('Opção inexistente. Por favor introduza s ou n! \n'), Funcao)), write(''),
			(write('Opção inexistente. Por favor introduza s ou n! \n'), Funcao)).

%Principal
login:- write('SISTEMA DE GESTÃO DE VENDA DE SALGADOS\n'),
		resetAll, lerUsers,
		write('Nome de utilizador: '),
		ler(NomeUt, 'Utilizador', login),
		write('Senha: '),
		ler(Senha, 'Senha', login),
		if_then_else(verificarLogin(NomeUt, Senha, U), (lerStock, lerSalgados, lerEncomendas, escolheMenu(U)), retry_login).

verificarLogin(Usuario, Senha, CUser):- user(Id, Nome, Usuario, Senha, Tipo), CUser is Id.
retry_login:- write('Nome do utilizador ou senha incorrecto(s)! Tente novamente.\n\n'), login.

escolheMenu(Id):- user(Id,Nome,NomeU,Senha,Tipo), 
						if_then_else(Tipo='cozinheiro', menuCozinheiro(Id), 
							if_then_else(Tipo='administrador', menuAdmin(Id),
								menu(Id))).

menu(Id):- write('++++++++++Menu+++++++++++\n'),
			  write('1. Nova encomenda\n'),
			  write('2. Ver encomendas\n'),
			  write('3. Ver estatísticas\n'),
			  write('4. Sobre o programa\n'),
			  write('5. Minha conta\n'),
			  write('6. Sair\n'),
			  write('+++++++++++++++++++++++++\n'), 
			  lerNr(OP, 'Opção', menu(Id)),
			  user(Id,Nome,NomeU, Senha, Tipo),
			  if_then_else(OP=1, novaEncomenda(Id),
			  	if_then_else(OP=2, verEncomendas(Id, Nome),
			  	 if_then_else(OP=3, (write('===============Estatísticas===============\n'), verEstatisticas(Id)),
			  	 	if_then_else(OP=4, sobreProg(Id),
			  	 		if_then_else(OP=5, minhaConta(Id),
			  	 			if_then_else(OP=6, sair(Id),
			  	 				print_invalid(menu(Id))
			  )))))).

novaEncomenda(IdU):- user(IdU, Nome, NomeU, Senha, Tipo), incrementEnc,
					 cont_encomenda(C),escolherSalgado(C,Nome, Total),
						if_then_else(Tipo='administrador', menuAdmin(IdU),
							menu(IdU)).

escolherSalgado(IdEncomenda, Nome, Total):- write('Escolha os salgados: \n'),
				  forall(salgado(Id, 0, NomeSal, Qtd, Piri, Frito, Preco), 
				  (if_then_else(salgado(Id, IdEncomenda, N, Q,P,F,Pr), write(''),
				   (write(Id), write('    '), write(NomeSal), write('    '), write(Preco), write('Mtn\n'))))),
				   write('0    Terminar\n'), lerNr(SALG, 'Salgado', escolherSalgado(IdEncomenda, Nome, Total)),
			  	  if_then_else(SALG=0, terminarEncomenda(IdEncomenda, Nome, Total),
			  	  	if_then_else(salgado(SALG, 0, NomeSal, Qtd, Piri, Frito, Preco),
			  	  				 novoSalgado(SALG,IdEncomenda,NomeSal, Nome,  Total),
			  	 				print_invalid(escolherSalgado(IdEncomenda,Nome, Total))
			  	  )).

novoSalgado(ID, IdE, SALG, Nome, Total):- write('Quantas dúzias?\n'), lerNr(D, 'Quantidade', novoSalgado(ID, IdE, SALG, Nome, Total)),
				write('Com piri-piri?(s/n)\n'), readSN(P, novoSalgado(ID, IdE, SALG, Nome, Total)),
				write('Frito?(s/n)\n'), readSN(F, novoSalgado(ID, IdE, SALG, Nome, Total)),
			  salgado(ID, 0, Salg, 0, '', '', Preco), write(Salg),
			  PFinal is (Preco*D), soma(Total, PFinal, Total2),
			  assertz(salgado(ID, IdE, SALG, D, P, F, PFinal)), escolherSalgado(IdE, Nome, Total2).

terminarEncomenda(IdEncomenda, Nome, Total):- if_then_else(salgado(Id, IdEncomenda, NomeSal, Qtd, Piri, Frito, Preco), 
												(assertz(encomenda(IdEncomenda, Nome, Total,'Pendente')), 
													write('\n Total a pagar: '), write(Total), write('Mtn.\n Valor Entregue(Mtn):'),
													lerNr(Valor, 'Valor',terminarEncomenda(IdEncomenda, Nome, Total)),
													Troco is Valor-Total, write(' Troco: '), write(Troco), write('Mtn.'),
													 write('\n\nEncomenda Efectuada!\n')),
												write('Encomenda Cancelada!\n')).

verSalgados:- forall(salgado(Id,IdE,NomeSal,Qtd,Piri,Frito,Preco), print_salgado(Id,IdE,NomeSal,Qtd)).

verEncomendas(IdU, Nome):- if_then_else(encomenda(Id, Nome, Total, Estado),
					mostrarEncomendasCli(Nome),
					write('Ainda não fez nenhuma encomenda.\n')), menu(IdU).

verEncomendas(IdU):- if_then_else(encomenda(Id, Nome, Total, Estado), mostrarEncomendas,
					write('Ainda não fez nenhuma encomenda.\n')), menuAdmin(IdU).

print_salgado(X, Y, Z, V):- write(X), write(Y), write(Z), write(V).

mostrarEncomendasCli(Nome):- forall(encomenda(Id, Nome, Total, Estado), print_encomenda(Id, Nome, Total, Estado)), 
					write('\nIntroduza o Código de uma das encomendas para selecioná-la ou 0 para voltar.\n'), 
					lerNr(OpEncomenda, 'Encomenda',mostrarEncomendasCli(Nome)),
					if_then_else(OpEncomenda=0, write(''), selectEncomenda(OpEncomenda)).

selectEncomenda(Id):- if_then_else(encomenda(Id, Nome, Total, Estado), detalhesEncomenda(Id), 
						print_then_run('Não foi encontrada nenhuma encomenda com este ID.\n', mostrarEncomendas)).

printSalgadoByEnc(IdEnc):- forall(salgado(Id, IdEnc, NomeSal, Qtd, Piri, Frito, Preco), 
								(write(Id), write(' '), write(NomeSal), write(' '), write(Frito), write(' '),
									write(Piri), write(' '), write(Qtd), write(' '), write(Preco), write('Mtn\n'))).

detalhesEncomenda(IdEnc):- encomenda(IdEnc, Nome, Total, Estado), write('Cliente: '), write(Nome), write('\n'),
						write('Estado da Encomenda: '), write(Estado), write('\n\nSalgados:\n'),
						printSalgadoByEnc(IdEnc), write('          Total: '), write(Total), write('Mtn\n'),
						write('\n\n1. Levantar Encomenda\n'),write('2. Alterar Encomenda\n'),
						write('3. Cancelar Encomenda\n'),write('0. Voltar\n'), 
						lerNr(OpEnc, 'Opção',detalhesEncomenda(IdEnc)),
						if_then_else(OpEnc=1, (alterarEstado(IdEnc, 'Levantada'), detalhesEncomenda(IdEnc)), 
							if_then_else(OpEnc=2, alterarEncomenda(IdEnc),
								if_then_else(OpEnc=3, (alterarEstado(IdEnc, 'Cancelada'), detalhesEncomenda(IdEnc)),
									if_then_else(OpEnc=0, write(''), 
										print_invalid(detalhesEncomenda(IdEnc)))))).

		%Operações com Encomendas
print_encomenda(Id, NomeCli, Total, Estado):- write(Id),write('    '), write(NomeCli),write('    '),
											 write(Total),write('Mtn    '), write(Estado), write('\n').

alterarEncomenda(IdEnc):- printSalgadoByEnc(IdEnc), write('Introduza o ID de um dos salgados para selecioná-lo ou 0 para voltar.\n'),
							lerNr(IdSal,'Salgado',alterarEncomenda(IdEnc)), 
							if_then_else(IdSal=0, detalhesEncomenda(IdEnc), selectEncSal(IdEnc, IdSal)).

selectEncSal(IdEnc, IdSal):- if_then_else(salgado(IdSal, IdEnc, NomeSal, Qtd, Piri, Frito, Preco),
						(write(IdSal), write(' '), write(NomeSal), write(' '), write(Frito), write(' '),
									write(Piri), write(' '), write(Qtd), write(' '), write(Preco), write('Mtn\n'),
						write('1. Alterar\n'), write('2. Remover\n'), write('0. Voltar\n'), 
							lerNr(Op, 'Opção',selectEncSal(IdEnc, IdSal)),
							if_then_else(Op=1, alterarEncSal(IdEnc, IdSal), 
								if_then_else(Op=2, removerEncSal(IdEnc, IdSal), 
									if_then_else(Op=0, alterarEncomenda(IdEnc), print_invalid(selectEncSal(IdEnc, IdSal)))))),
						print_then_run('Não foi encontrado nenhum salgado com este ID.\n', alterarEncomenda(IdEnc))).

alterarEncSal(IdEnc, IdSal):- salgado(IdSal, IdEnc, NomeSal, Qtd, Piri, Frito, Preco), 
						write('Quantidade ('), write(Qtd), write('): '), lerNr(QtdN, 'Quantidade', alterarEncSal(IdEnc, IdSal)), 
						write('Piri ('), write(Piri), write('): '), readSN(PiriN,alterarEncSal(IdEnc, IdSal)),
						write('Frito ('), write(Frito), write('): '), readSN(FritoN, alterarEncSal(IdEnc, IdSal)),
						retract(salgado(IdSal, IdEnc, NomeSal, Qtd, Piri, Frito, Preco)),
						salgado(IdSal, 0, NomeSal, 0, P, F, Pr), PFinal is (Pr*QtdN),
						assertz(salgado(IdSal, IdEnc, NomeSal, QtdN, PiriN, FritoN, PFinal)),
						write('Encomenda alterada com sucesso!\n'),
						alterarEncomenda(IdEnc).

removerEncSal(IdEnc, IdSal):- write('Tem a certeza que pretende remover este salgado?'),
						readSN(Resp, removerEncSal(IdEnc, IdSal)),
						if_then_else(Resp='s', 
						(retract(salgado(IdSal, IdEnc, NomeSal, Qtd, Piri, Frito, Preco)),write('Encomenda alterada com sucesso!\n')),
						write('')),
						alterarEncomenda(IdEnc).

alterarEstado(Id, NovoEstado):- retract(encomenda(Id, Nome,Total, Estado)),
								assertz(encomenda(Id, Nome, Total, NovoEstado)).

%Ver Estatisticas
verEstatisticasAdmin(IdU):- totalGanho, encomendasFeitas, acharMaior, acharMenor, 
						write('==========================================\n'), menuAdmin(IdU).

verEstatisticas(IdU):- user(IdU, Nome, N, S, T),totalGasto(Nome), encomendasFeitas(Nome), acharMaior(Nome), acharMenor(Nome), 
						write('==========================================\n'), menu(IdU).

ganho(0).
addGanho(C):- ganho(G), NG is G+C, retract(ganho(G)), assertz(ganho(NG)).
resetGanho:- retract(ganho(G)), assertz(ganho(0)).

totalGanho:- forall(encomenda(Id, Nome, Total, Estado), addGanho(Total)), write(' Total ganho pela loja: '),
				  ganho(Tot), write(Tot), write('Mtn.'), resetGanho.

totalGasto(Nome):- forall(encomenda(Id, Nome, Total, Estado), addGanho(Total)), write(' Total gasto na loja: '),
				  ganho(Tot), write(Tot), write('Mtn.'), resetGanho.

encomendasByCliente(IdU):- user(IdU, Nome, NomeU, Senha, Tipo),
							forall(encomenda(Id, Nome, Total, Estado), salgadosByEncomenda(Id)). %Para Todas encomendas do cliente IdU, 

salgadosByEncomenda(IdE):- forall(salgado(Id, IdE, Nome, Qtd, Piri, Frito,Preco),
							 (write(Nome), soma(Total, Preco, Total2))), write(Total2). %Para Todos Salgados da encomenda IdE

inicializarStats:- forall(salgado(Id, IdEnc, Nome, Qtd, Piri, Frito, Preco), if_then_else(IdEnc =\= 0, 
					if_then_else(contador_stat(Id, Nome, _), write(''), assertz(contador_stat(Id, Nome, 0))),
					write('')) ).

resetContadores:- forall(contador_stat(Id,Nome,C), retract(contador_stat(Id,Nome,C))).

salgadoMaisComprado:- inicializarStats, forall(salgado(Id, IdE, Nome, Qtd, Piri, Frito, Preco),
					if_then_else(IdE =\= 0, incrementStat(Id, Qtd), write(''))).

salgadoMaisComprado(Cliente):- inicializarStats, forall(salgado(Id, IdE, Nome, Qtd, Piri, Frito, Preco),
					if_then_else((IdE =\= 0, encomenda(IdE, Cliente,_,_)), incrementStat(Id, Qtd), write(''))).

melhor('nenhum', 0).
setMelhor(Nome, C):- retract(melhor(_, _)), assertz(melhor(Nome, C)).

acharMaior:- salgadoMaisComprado,  forall(contador_stat(Id, NomeS, Qtd),
 			(melhor(Nome, Maior), if_then_else(Qtd > Maior, setMelhor(NomeS, Qtd), write('')))),
			melhor(NomeS, Qtd), write('\n Salgado mais comprado: '), write(NomeS), write(' ('), write(Qtd), write(')'),
			setMelhor(nenhum, 0), resetContadores.

acharMaior(Cliente):- salgadoMaisComprado(Cliente),  forall(contador_stat(Id, NomeS, Qtd),
 			(melhor(Nome, Maior), if_then_else(Qtd > Maior, setMelhor(NomeS, Qtd), write('')))),
			melhor(NomeS, Qtd), write('\n Salgado mais comprado: '), write(NomeS), write(' ('), write(Qtd), write(')'),
			setMelhor(nenhum, 0), resetContadores.

acharMenor:- setMelhor(nenhum, 9999), salgadoMaisComprado, forall(contador_stat(Id, NomeS, Qtd),
 			(melhor(Nome, Menor), if_then_else((Qtd < Menor, Qtd>0), setMelhor(NomeS, Qtd), write('')))),
			melhor(NomeS, Qtd), write('\n Salgado menos comprado: '), write(NomeS), write(' ('), write(Qtd), write(')\n'),
			setMelhor(nenhum, 0), resetContadores.

acharMenor(Cliente):- setMelhor(nenhum, 9999), salgadoMaisComprado(Cliente), forall(contador_stat(Id, NomeS, Qtd),
 			(melhor(Nome, Menor), if_then_else((Qtd < Menor, Qtd>0), setMelhor(NomeS, Qtd), write('')))),
			melhor(NomeS, Qtd), write('\n Salgado menos comprado: '), write(NomeS), write(' ('), write(Qtd), write(')\n'),
			setMelhor(nenhum, 0), resetContadores.

encomendasFeitas:- forall(encomenda(Id, Nome, Total, Estado), addGanho(1)), write('\n Encomendas Feitas: '),
						ganho(Encs), write(Encs), resetGanho.

encomendasFeitas(Nome):- forall(encomenda(Id, Nome, Total, Estado), addGanho(1)), write('\n Encomendas Feitas: '),
						ganho(Encs), write(Encs), resetGanho.

%Sobre o Programa
sobreProg(User):- write('====================================================\n'),
			write('  Sistema de Gestão de Venda de Salgados v1.1 beta\n'),
			write('  Desenvolvido por Rosário Pereira Fernandes\n'),
			write('  2017 - ISCTEM (2º Ano Eng. Informática)\n'),
			write('====================================================\n'),
			user(User, N, NU, S, Tipo),
			if_then_else(Tipo='cozinheiro', menuCozinheiro(User), 
				if_then_else(Tipo='administrador', menuAdmin(User),
						menu(User))).

%Minha Conta
minhaConta(IdU):- user(IdU, Nome, NomeU, Senha, Tipo), write('\n Minha Conta\n'), write(Tipo), write('\n'),
				 write('Nome: '), write(Nome), write('\n'), write('Nome de utilizador: '), write(NomeU),
				 write('\n'), menuConta(IdU).

menuConta(IdU):- write('1. Alterar Senha\n'), write('2. Voltar\n'), user(IdU, Nome, NomeU, Senha, Tipo),
				ler(Op,'Opção',menuConta(IdU)), if_then_else(Op=1, alterarSenha(IdU), 
							if_then_else(Op=2, if_then_else(Tipo='cozinheiro', menuCozinheiro(IdU),
												if_then_else(Tipo='administrador', menuAdmin(IdU),
												menu(IdU))),
							 print_invalid(menuConta(IdU)))).

alterarSenha(IdU):- write('Introduza a senha actual:'), ler(Actual, 'Opção',alterarSenha(IdU)), write('Introduza a nova senha:'),
					ler(Nova, 'Opção',alterarSenha(IdU)), write('Re-introduza a senha:'), ler(Renova, 'Opção',alterarSenha(IdU)),
					if_then_else(Nova=Renova, verificaNovaSenha(IdU, Actual, Nova), 
					print_then_run('As novas senhas não correspondem!\n', alterarSenha(idU))).

verificaNovaSenha(IdU, Senha, Nova):- if_then_else(user(IdU, Nome, NomeU, Senha, Tipo), guardaNovaSenha(IdU, Senha, Nova),
								print_then_run('Senha Incorrecta!\n', alterarSenha(IdU))).

guardaNovaSenha(IdU, Senha, Nova):- retract(user(IdU, Nome, NomeU, Senha, Tipo)),
								 assertz(user(IdU, Nome, NomeU, Nova, Tipo)),
								 write('Senha alterada com sucesso!\n'), menu(IdU).

%Sair
sair(Id):- user(Id, Nome, NomeU, Senha, Tipo), escreveUsers, escreveSalgados, escreveEncomendas, escreveStock, 
			print_concat('Adeus ',Nome,'! \nAté breve :)\n\n'), login.

writeStr(Stream, Variable):- write(Stream, '\''), write(Stream, Variable), write(Stream, '\''), write(Stream, '.'), nl(Stream).
writeInt(Stream, Variable):- write(Stream, Variable), write(Stream, '.'), nl(Stream).

escreveUsers :- open('Utilizadores.txt', write, Stream),
    forall(user(Id,Nome,NomeU,Senha,Tipo), 
    	(writeInt(Stream,Id),
    		writeStr(Stream, Nome),
    		writeStr(Stream, NomeU),
    		writeStr(Stream, Senha), 
    		writeStr(Stream, Tipo))),
    close(Stream).

escreveSalgados :- open('Salgados.txt', write, Stream),
	forall(salgado(Id,IdEnc,NomeSal,Qtd, Piri, Frito, Total), 
	    if_then_else(IdEnc>0,(writeInt(Stream,Id),
    		writeInt(Stream, IdEnc),
    		writeStr(Stream, NomeSal),
    		writeInt(Stream, Qtd),
    		writeStr(Stream, Piri),
    		writeStr(Stream, Frito),
    		writeInt(Stream, Total)), write(''))),
  	close(Stream).

escreveStock :- open('Productos.txt', write, Stream),
	forall(salgado(Id,0,NomeSal,Qtd, Piri, Frito, Total), 
	    (writeInt(Stream,Id),
    		writeStr(Stream, NomeSal),
    		writeInt(Stream, Total))),
  	close(Stream).

escreveEncomendas :- open('Encomendas.txt', write, Stream),
	forall(encomenda(Id,NomeCli, Total, Estado), 
	    (writeInt(Stream,Id),
    		writeStr(Stream, NomeCli),
    		writeInt(Stream, Total),
    		writeStr(Stream, Estado))),
  	close(Stream).

%Cozinheiro
menuCozinheiro(Id):- write('++++++++++Menu+++++++++++\n'),
			  write('1. Ver encomendas\n'),
			  write('2. Sobre o programa\n'),
			  write('3. Minha conta\n'),
			  write('4. Sair\n'),
			  write('+++++++++++++++++++++++++\n'),
			  lerNr(OP, 'Opção', menuCozinheiro(Id)),
			  if_then_else(OP=1, verEncomendasCoz(Id),
			  	 	if_then_else(OP=2, sobreProg(Id),
			  	 		if_then_else(OP=3, minhaConta(Id),
			  	 			if_then_else(OP=4, sair(Id),
			  	 				print_invalid(menuCozinheiro(Id))
			  )))).

verEncomendasCoz(IdU):- if_then_else((encomenda(Id, Nome, Total, 'Pendente'); encomenda(Id, Nome, Total, 'Pronta')),
					mostrarEncomendasCoz,
					write('Ainda não existe nenhuma encomenda.\n')), menuCozinheiro(IdU).

print_salgado(X, Y, Z, V):- write(X), write(Y), write(Z), write(V).

mostrarEncomendas(Estado):- forall(encomenda(Id, Nome, Total, Estado), print_encomenda(Id, Nome, Total, Estado)), 
					write('\nIntroduza o Código de uma das encomendas para selecioná-la ou 0 para voltar.\n'), 
					lerNr(OpEncomenda, 'Opção', mostrarEncomendas(Estado)),
					if_then_else(OpEncomenda=0, write(''), selectEncomenda(OpEncomenda)).

selectEncomendaCoz(Id):- if_then_else(encomenda(Id, Nome, Total, Estado), detalhesEncomendaCoz(Id), 
						print_then_run('Não foi encontrada nenhuma encomenda com este ID.\n', mostrarEncomendas)).

detalhesEncomendaCoz(IdEnc):- encomenda(IdEnc, Nome, Total, Estado), write('Cliente: '), write(Nome), write('\n'),
						write('Estado da Encomenda: '), write(Estado), write('\n\nSalgados:\n'),
						printSalgadoByEnc(IdEnc), write('1. Encomenda Pronta\n'),
						write('0. Voltar\n'), ler(OpEnc, 'Opção', detalhesEncomendaCoz(IdEnc)),
						if_then_else(OpEnc=1, (alterarEstado(IdEnc, 'Pronta'), detalhesEncomendaCoz(IdEnc)),
							if_then_else(OpEnc=0, write(''), 
								print_invalid(detalhesEncomendaCoz(IdEnc)))).

mostrarEncomendasCoz:- forall(encomenda(Id, Nome, Total, Estado),
						if_then_else((Estado = 'Pendente' ; Estado = 'Pronta'), print_encomenda(Id, Nome, Total, Estado), write(''))),
						write('\nIntroduza o Código de uma das encomendas para selecioná-la ou 0 para voltar.\n'), 
						lerNr(OpEncomenda, 'Código', mostrarEncomendasCoz),
						if_then_else(OpEncomenda=0, write(''), selectEncomendaCoz(OpEncomenda)).

%Administrador
menuAdmin(Id):- write('++++++++++Menu+++++++++++\n'),
			  write('1. Novo Salgado\n'),
			  write('2. Ver Salgados\n'),
			  write('3. Nova encomenda\n'),
			  write('4. Ver encomendas\n'),
			  write('5. Gerir Utilizadores\n'),
			  write('6. Ver estatísticas\n'),
			  write('7. Sobre o programa\n'),
			  write('8. Minha conta\n'),
			  write('9. Sair\n'),
			  write('+++++++++++++++++++++++++\n'),
			  lerNr(OP, 'Opcao', menuAdmin(Id)),
			  if_then_else(OP=1, insertSalgado(Id),
			  	if_then_else(OP=2, readSalgados(Id),
			  		if_then_else(OP=3, novaEncomenda(Id),
			  			if_then_else(OP=4, verEncomendas(Id),
			  				if_then_else(OP=5, (gerirUsers(Id), menuAdmin(Id)),
			  	 				if_then_else(OP=6, (write('===============Estatísticas===============\n'), verEstatisticasAdmin(Id)),
			  	 					if_then_else(OP=7, sobreProg(Id),
			  	 						if_then_else(OP=8, minhaConta(Id),
			  	 							if_then_else(OP=9, sair(Id),
			  	 								print_invalid(menuAdmin(Id))
			  ))))))))).

insertSalgado(IdU):- incrementSalgado, cont_salgado(ID), write('Nome do Salgado:'), 
				ler(NomeNovoSal, 'Nome', insertSalgado(IdU)), write('Preço:'),
				lerNr(Preco, 'Preço',insertSalgado(IdU)), assertz(salgado(ID, 0, NomeNovoSal, 0, '', '', Preco)), 
				write('Salgado adicionado com sucesso!\n'), menuAdmin(IdU).

readSalgados(IdU):- write('Salgados disponíveis \n'),forall(salgado(Id, 0, NomeSal, 0, '', '', Preco), 
					(write(Id), write('    '), write(NomeSal), write('    '), write(Preco), write('Mtn\n'))),
					write('Introduza o ID de um dos salgados para selecioná-lo ou 0 para voltar.\n'), 
					lerNr(Sal, 'ID', readSalgados(IdU)),
					if_then_else(Sal=0, menuAdmin(IdU), selectSalgado(Sal, IdU)).

selectSalgado(Id, IdU):- if_then_else(salgado(Id, 0, NomeSal, 0, '', '', Preco),
						(write('Nome: '), write(NomeSal), write('\nPreço: '), write(Preco), menuSalgados(Id, IdU)),
						print_then_run('Não foi encontrado nenhum salgado com este ID.\n', readSalgados(IdU))).

menuSalgados(Id, IdU):- write('\n1. Alterar o nome\n'), write('2. Alterar o preço\n'), write('3. Eliminar\n'), write('0. Voltar\n'),
					lerNr(Op, 'Opção',menuSalgados(Id, IdU)), if_then_else(Op=1, alterarNomeSal(Id, IdU), 
								if_then_else(Op=2, alterarPrecoSal(Id, IdU),
									if_then_else(Op=3, removerSal(Id, IdU),
										if_then_else(Op=0, write(''),
											print_invalid(gerirUser(IdU)))))).

alterarNomeSal(Id, IdU):- write('Introduza o novo nome:'), ler(Nome,'Nome',alterarNomeSal(Id, IdU)),
							retract(salgado(Id, 0, NomeSal, 0, '', '', Preco)),
							assertz(salgado(Id, 0, Nome, 0, '', '', Preco)), write('Nome do salgado actualizado! \n'),
							readSalgados(IdU).

alterarPrecoSal(Id, IdU):- write('Introduza o novo preco:'), ler(PrecoN, 'Preço',alterarPrecoSal(Id, IdU)),
							retract(salgado(Id, 0, NomeSal, 0, '', '', Preco)),
							assertz(salgado(Id, 0, NomeSal, 0, '', '', PrecoN)), write('Preço do salgado actualizado! \n'),
							readSalgados(IdU).

removerSal(Id, IdU):- write('Tem a certeza que pretende remover este salgado?\n'), 
							readSN(Resp, removerSal(Id, IdU)), 
							if_then_else(Resp='s', (retract(salgado(Id, 0, NomeSal, 0, '', '', Preco)),
													 write(NomeSal), write('Salgado removido com sucesso.\n')),
							 write('') ), readSalgados(IdU).

mostrarEncomendas:- forall(encomenda(Id, Nome, Total, Estado), print_encomenda(Id, Nome, Total, Estado)), 
					write('\nIntroduza o Código de uma das encomendas para selecioná-la ou 0 para voltar.\n'), 
					ler(OpEncomenda, 'Código', mostrarEncomendas),
					if_then_else(OpEncomenda=0, write(''), selectEncomenda(OpEncomenda)).

%Gerir Utilizadores
gerirUsers(IdU):- write('1. Adicionar utilizador\n'), write('2. Ver Utilizadores\n'), write('0. Voltar\n'), 
						ler(Op, 'Opção', gerirUsers(IdU)),
						if_then_else(Op=1, adicionarUser(IdU), 
							if_then_else(Op=2, verUsers(IdU),
									if_then_else(Op=0, write(''),
										print_invalid(gerirUser(IdU))))).

adicionarUser(IdU):- write('Introduza o nome real do novo utilizador:'), ler(Nome, 'Nome',adicionarUser(IdU)), 
						write('Introduza o nome de utilizador (ele usará este nome para acessar ao sistema):\n'),
						 ler(NomeU, 'Nome de Utilizador',adicionarUser(IdU)),
						write('Este utilizador é administrador, cliente ou cozinheiro?\n'), 
						ler(Tipo, 'Tipo',adicionarUser(IdU)),
						incrementUser, cont_user(Id),
						assertz(user(Id, Nome, NomeU, 'isctem', Tipo)), write('utilizador adicionado com sucesso!\n'),
						verUsers(IdU), menuAdmin(IdU).

verUsers(IdU):- forall(user(Id, Nome, NomeU, Senha, Tipo), print_user(Id)), 
				write('\nIntroduza o Código de um dos utilizadores para selecioná-lo ou 0 para voltar.\n'), 
				lerNr(UserEsc, 'Código',verUsers(IdU)),
				if_then_else(UserEsc=0, write(''), selectUser(UserEsc, IdU)).

print_user(Id):- user(Id, Nome, NomeU, Senha, Tipo), write(Id), write('   '), write(Nome), write('   '), write(NomeU), write('   '),
				write(Tipo), write('\n').

selectUser(Id, IdU):- if_then_else(user(Id, Nome, NomeU, Senha, Tipo), detalhesUser(Id),
						print_then_run('Não foi encontrado nenhum utilizador com este ID.\n', verUsers(IdU))).

detalhesUser(Id):- user(Id, Nome, NomeU, Senha, Tipo), write(Tipo), write('\n'),
						write('Nome: '), write(Nome), write('\n'),
						write('Nome de utilizador: '), write(NomeU),
						write('\n\n1. Alterar o nome\n'),write('2. Repor Senha \n'),
						write('0. Voltar\n'), 
						lerNr(Op, 'Opção', detalhesUser(Id)),
						if_then_else(Op=1, alterarNome(Id), 
							if_then_else(Op=2, resetPassword(Id),
									if_then_else(Op=0, write(''), 
										print_invalid(detalhesUser(Id))))).

alterarNome(Id):- write('Introduza o novo nome: '), 
				  lerNr(NovoNome, 'Nome',alterarNome(Id)), retract(user(Id, Nome, NomeU, Senha, Tipo)),
				  assertz(user(Id, NovoNome, NomeU, Senha, Tipo)), write('Nome alterado com sucesso!\n'), detalhesUser(Id).

resetPassword(Id):- write('Tem a certeza que pretende repor a senha deste utilizador?(s/n)'),
					readSN(Resp, resetPassword(Id)),
				  if_then_else(Resp='s', 
				  (retract(user(Id, Nome, NomeU, Senha, Tipo)),
				  assertz(user(Id, Nome, NomeU, 'isctem', Tipo)),
				  write('Senha reposta!\n')),write('')),
				  detalhesUser(Id).

:-initialization(login).