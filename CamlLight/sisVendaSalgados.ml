(*Declaracao dos Tipos*)
type utilizador = {id:int; mutable nome:string; nomeUsuario:string; mutable senha:string; mutable tipo:string};;
type salgado= {codigo:int; codE:int; mutable nomeSalgado:string; mutable qtd:int; mutable piri:char; mutable frito:char};;
type encomenda = {codEncomenda: int; mutable nomeCliente:string; mutable lista:salgado list; mutable total:float; mutable estado:string};;

(*Opção 4 do Menu*)
let sobreProg () = print_string "====================================================\n";
				print_string "  Sistema de Gestão de Venda de Salgados v1.0 beta\n";
				print_string "  Desenvolvido por Rosário Pereira Fernandes e\n";
				(*print_string "  Kelven Joaquim Fernandes Rodrigues\n";*)
				print_string "  2017 - ISCTEM (2º Ano Eng. Informática)\n";
				print_string "====================================================\n";;

let rec count_elements = fun () cont (h::t) -> count_elements() (cont+1) t
							| () cont [] -> cont;;

(*Obter o preco de um salgado*)
let getPreco = fun salgado -> if(salgado.frito=`s`) then (float_of_int(salgado.qtd)*.(190.0+.30.0)) else (float_of_int(salgado).qtd*.190.0);;

(*Obter o ID da encomenda a seguir*)
let rec getNextEncom = fun lastId (h::t) -> getNextEncom h.codEncomenda t
						| lastId [] -> (lastId+1);;

(*Guardar os salgado no ficheiro*)
let rec writeSal = fun ce (h::t) -> output_string ce (string_of_int(h.codigo)^"\n"); output_string ce (string_of_int(h.codE)^"\n");
									output_string ce (h.nomeSalgado^"\n"); output_string ce (string_of_int(h.qtd)^"\n");
									output_string ce (string_of_char(h.piri)^"\n"); output_string ce (string_of_char(h.frito)^"\n");
									writeSal ce t
				| ce [] -> close_out ce;;

let abreCe = fun () list -> let cs = open_out("Salgados.txt") in writeSal cs list;;

(*Guardar as Encomendas no ficheiro*)
let rec writeEnc = fun ce (h::t) -> output_string ce (string_of_int(h.codEncomenda)^"\n"); output_string ce (h.nomeCliente^"\n");
									output_string ce (string_of_float(h.total)^"\n"); output_string ce (h.estado^"\n");
									writeEnc ce t
				| ce [] -> close_out ce;;

let abreCeEnc = fun () list -> let cs = open_out("Encomendas.txt") in writeEnc cs list;;

let nomeSal = fun n -> if(n=1) then "Chamussas   " else
					   if(n=2) then "Rissois     " else
					   if(n=3) then "Spring Rolls" else "";;

let rec readSN = fun () -> let r = nth_char (read_line()) 0 in
					   if(r=`s` || r=`n` || r=`S` || r=`N`) then r
					   else begin print_string "Resposta inválida. Por favor, introduza 's' ou 'n':\n"; readSN () end;;

let rec preencheSalgado = fun n codE -> print_string "Quantas dúzias?\n";
							   try
							   let duz = read_int() in 
							   print_string "Com piri-piri?(s/n)\n";
							   let p = readSN() in
							   print_string "Fritos?(s/n)\n";
							   let fri = readSN() in
							   let nome= nomeSal n in
							   let salg = {codigo=n; codE = codE; nomeSalgado=nome; qtd=duz; piri=p;frito=fri}
							   in [salg]
							   with | _ -> print_string "Número de dúzias inválido.\n"; preencheSalgado n codE;;

let rec total_of_listaSal = fun () total (h::t) -> let tot = ((getPreco h)+.total) in total_of_listaSal() tot t
							| () total []-> total;;

let frito_of_char = fun () f -> if(f=`s`) then "Frito    " else "Não frito";;
let piri_of_char = fun () p -> if(p=`s`) then "C/P" else "S/P";;

let rec printSalByEnc = fun () id (h::t) -> if (id=h.codE) then begin print_string ((string_of_int h.codigo)^".   ");
								   print_string (h.nomeSalgado^"   ");
								   print_string ((frito_of_char() h.frito)^" ");
								   print_string ((piri_of_char() h.piri)^"   ");
								   print_string ((string_of_int h.qtd)^"duz   ");
								   print_string ((string_of_float (getPreco h))^"Mtn \n");
								   printSalByEnc () id t
									end else begin printSalByEnc() id t end
					| () id [] -> ();;

let rec validarValor = fun () vpagar -> let valor = read_float() in 
												if(valor<vpagar) then begin 
												print_string "O valor introduzido é menor do que o valor que tem a pagar. Por favor, introduza novamente.";
												validarValor() vpagar end
												else valor;;

let rec calcularTroco = fun () vpagar idEnc listaSal -> printSalByEnc() idEnc listaSal;
														print_string ("\n Total a pagar: "^(string_of_float vpagar)^"Mtn.\n");
														print_string "O valor entregue:\n";
														let valor = validarValor() vpagar in
														let troco = valor-.vpagar in
														print_string ("Troco: "^(string_of_float troco)^"Mtn\n\n Encomenda Efectuada!!\n\n");;

let rec novaEncomenda = fun () listaSal listaEncs nomeUser ->
										let id = (getNextEncom 0 listaEncs) in
										print_string "Escolha os salgados: \n";
			  							print_string "1. Chamussas\n";
			  							print_string "2. Rissois\n";
			  							print_string "3. Spring Rolls\n";
			  							if(listaSal=[]) then
			  								print_string "4. Cancelar\n"
			  							else
			  								print_string "4. Terminar\n";
			  							try
			  							let op = read_int() in if(op<4) then novaEncomenda() (listaSal@(preencheSalgado op id)) listaEncs nomeUser else
			  						 	if(op=4) then begin (*abreCe () listaSal;*)
			  						 	if(listaSal=[]) then listaEncs else
			  						 	begin
			  						 	let tot = total_of_listaSal() 0.0 listaSal in
			  						 	calcularTroco() tot id listaSal;
			  						 	let enc = {codEncomenda=id; nomeCliente=nomeUser; lista=listaSal;total=tot;estado="Pendente"} in
			  						 	listaEncs@[enc] end end else
			  						 	begin print_string "Opção inexistente. Tente novamente.\n"; novaEncomenda () listaSal listaEncs nomeUser end
			  						 	with | _ -> print_string "Opção inexistente. Tente novamente.\n"; novaEncomenda () listaSal listaEncs nomeUser;;


let rec readSN = fun () -> let r = nth_char (read_line()) 0 in
					   if(r=`s` || r=`n` || r=`S` || r=`N`) then r
					   else begin print_string "Resposta inválida. Por favor, introduza 's' ou 'n':\n"; readSN () end;;

let rec getTodosSalgados = fun () (h::t) listaSal-> getTodosSalgados() t (listaSal@h.lista)
						| () [] listaSal -> listaSal;;

let rec verListCli = fun () (h::t) -> if(h.estado!="Cancelada") then begin print_string (string_of_int h.codEncomenda^". ");
								   print_string (h.nomeCliente^" ");
								   print_string ((string_of_float h.total)^"Mtn ");
								   print_string (h.estado^"\n"); verListCli () t end else begin verListCli () t end
					 | () [] -> ();;

let rec levarEnc = fun id (h::t) -> if(id=h.codEncomenda) then h.estado <- "Levantada" else levarEnc id t
					| id [] -> ();;

let rec removEnc = fun id (h::t) lista2 -> if(id=h.codEncomenda) then removEnc id [] t else removEnc id t (lista2@[h])
				  	| id [] lista2 -> lista2;;

let rec cancelarEnc = fun id (h::t) -> if(id=h.codEncomenda) then h.estado <- "Cancelada" else cancelarEnc id t
					| id [] -> ();;

let rec alterarSalgado = fun () salgado -> print_string ("Quantidade ("^(string_of_int salgado.qtd)^"): ");
										let qtd = read_int() in
										print_string ("Piri ("^(string_of_char salgado.piri)^"): ");
										let piri = readSN() in
										print_string ("Frito ("^(string_of_char salgado.frito)^"): ");
										let frito = readSN() in
										salgado.qtd <- qtd; salgado.piri <- piri; salgado.frito<- frito;
										print_string ("Encomenda Alterada com sucesso!\n");;

let rec removSal = fun id (h::t) lista2 -> if(id=h.codigo) then removSal id [] t else removSal id t (lista2@[h])
				  	| id [] lista2 -> lista2;;

let rec verDetSal = fun id sal listaSal -> print_string ((string_of_int sal.codigo)^" ");
									print_string (sal.nomeSalgado^" ");
									print_string ((piri_of_char() sal.piri)^" ");
									print_string ((frito_of_char() sal.frito)^" ");
									print_string ((string_of_int sal.qtd)^" ");
									let total = getPreco sal in
									print_string ((string_of_float total)^" \n");
									print_string "\n\n1.Alterar\n";
								   print_string "2. Remover\n";
								   print_string "0. Voltar\n";
								   try
								   let op = read_int() in if(op=0) then listaSal else
								   						  if(op=1) then begin alterarSalgado() sal; listaSal end else
								   						  if(op=2) then removSal (sal.codigo) listaSal []
								   						  else begin print_string "Opção Inválida. Tente novamente:\n"; verDetSal id sal listaSal end
									with | _ -> print_string "Opção Inválida. Tente novamente:\n"; verDetSal id sal listaSal;;

let rec detalhesSalgado = fun id (h::t) lista2-> if(id=h.codigo) then begin verDetSal id h lista2 end else detalhesSalgado id t lista2
					  | id [] lista2 -> print_string ("Não existe nenhum salgado com o código "^(string_of_int id)^".\n"); lista2;;

let rec alterarEnc = fun () enc -> printSalByEnc() enc.codEncomenda enc.lista;
									print_string "Introduza o ID de um dos salgados para selecioná-lo ou 0 para voltar.\n";
									try
									let op = read_int() in
									if (op=0) then begin () end else
									begin enc.lista <- detalhesSalgado op enc.lista enc.lista;
			  						 	let tot = total_of_listaSal() 0.0 (enc.lista) in enc.total <- tot; () end 
									with
									| _ -> alterarEnc() enc;;

let rec menuDetEnc = fun id lista enc -> print_string ("Cliente: "^ enc.nomeCliente^"\n");
									print_string ("Estado da Encomenda: "^ enc.estado^"\n\nSalgados:\n");
									printSalByEnc() id enc.lista; print_string ("          Total: "^string_of_float(enc.total)^"Mtn\n");
									print_string "\n\n1.Levantar Encomenda\n";
								   print_string "2. Alterar Encomenda\n"; print_string "3. Cancelar Encomenda\n";
								   print_string "0. Voltar\n";
								   try
								   let op = read_int() in if(op=0) then () else
								   						  if(op=1) then levarEnc id lista else
								   						  if(op=2) then alterarEnc() enc else
								   						  if(op=3) then cancelarEnc id lista
								   						  else begin print_string "Opção Inválida. Tente novamente:\n"; menuDetEnc id lista enc end
									with | _ -> print_string "Opção Inválida. Tente novamente:\n"; menuDetEnc id lista enc;;

let rec detalhesEnc = fun id (h::t) -> if(id=h.codEncomenda) then begin menuDetEnc id (h::t) h end else detalhesEnc id t
					  | id [] -> print_string ("Não existe nenhuma encomenda com o código "^(string_of_int id)^".\n");;

let rec menuEnc = fun () listaEncs ->  verListCli() listaEncs;
									print_string "\nIntroduza o Código de uma das encomendas para selecioná-la ou 0 para voltar.\n";
									try let cod = read_int() in if (cod=0) then listaEncs else begin detalhesEnc cod listaEncs; listaEncs end
									with | _ -> listaEncs;;
			 
let rec canalLogin = fun cnl lista ->
	try
		let id = int_of_string(input_line cnl) in
		let nome = input_line cnl in
		let username = input_line cnl in 
		let pass = input_line cnl in
		let tipo = input_line cnl in
		let user = {id=id;nome=nome;nomeUsuario=username;senha=pass;tipo=tipo} in
			canalLogin cnl lista@[user]
	with
	| end_of_file -> lista;;

let rec writeUsers = fun ce (h::t) -> output_string ce (string_of_int(h.id)^"\n"); output_string ce (h.nome^"\n");
									output_string ce (h.nomeUsuario^"\n"); output_string ce (h.senha^"\n");
									output_string ce (h.tipo^"\n");
									writeUsers ce t
				| ce [] -> close_out ce;;

let saveUsers = fun () list -> let cs = open_out("Utilizadores.txt") in writeUsers cs list;;

let rec removeUserById = fun () id (h::t) lista2 -> if(h.id=id) then removeUserById() id t lista2 else removeUserById() id t (lista2@[h])
							| () id [] lista2 -> lista2;;

let updateUser = fun () user -> let cnl = open_in "Utilizadores.txt" in let lstUsers = removeUserById() user.id (canalLogin cnl []) [] in
								 saveUsers() (lstUsers@[user]); ();;

let rec alterarSenha = fun () user-> print_string "Introduza a senha actual:";
									 let actual = read_line() in
									 print_string "Introduza a nova senha:";
									 let nova = read_line() in
									 print_string "Re-introduza a senha:";
									 let renova= read_line() in
									 if(actual=user.senha) then begin
									 	if(nova=renova) then begin
									 		user.senha<-nova;
									 		updateUser() user; print_string "Senha alterada com sucesso!\n"
									 	end else begin print_string "As novas senhas não correspondem!\n"; alterarSenha() user end
									 end
									 else begin print_string "Senha Incorrecta!\n"; alterarSenha() user end;;

let rec menuConta = fun () user -> print_string "1. Alterar Senha\n"; print_string "2. Voltar\n";
							try
							let op = read_int() in if(op=1) then begin alterarSenha() user end else if(op=2) then ()
												else begin print_string "Opção Inválida. Tente novamente:\n"; menuConta() user end
							with | _ -> print_string "Opção Inválida. Tente novamente:\n"; menuConta() user;;

let minhaConta = fun () user -> print_string "\n Minha Conta\n"; print_string (user.tipo^"\n");
							print_string ("Nome: "^user.nome^"\n"); print_string ("Nome de utilizador: "^user.nomeUsuario^"\n");menuConta() user;;

(*Achar todas as encomendas de um cliente*)

let rec encByCliente = fun () (h::t) listaEncs cliente ->if(h.nomeCliente=cliente) then encByCliente() t (listaEncs@[h]) cliente
													else encByCliente() t listaEncs cliente
					| () [] listaEncs cliente -> listaEncs;;

(*Total gasto na loja*)
let rec totalGasto = fun () total (h::t) -> let tot =  total+.h.total in totalGasto() tot t
					| () total [] -> total;;

(*Acumular Salgados de várias encomendas e retornar uma lista de todos salgados*)
let rec joinSalgados = fun () (h::t) listaSal -> listaSal@h.lista
						| () [] listaSal -> listaSal;;

(*Contar chamussas por exemplo*)
let rec contarSalgados = fun () (h::t) nomeSal lista2 cont -> if(h.nomeSalgado= nomeSal) then contarSalgados() t nomeSal (lista2@[h]) (cont+1) else
														 contarSalgados() t nomeSal lista2 cont
							| () [] nomeSal lista2 cont-> lista2;;

let salgadoMaisVendido = fun () listaEncs -> let salgs = joinSalgados() listaEncs [] in
										 let nChamussas = contarSalgados() salgs "Chamussas   " [] 0 in
										 let nRissois = contarSalgados() salgs "Rissois     " [] 0 in
										 let nSpringRolls = contarSalgados() salgs "Spring Rolls" [] 0 in
										 if(nChamussas>nRissois && nChamussas>nSpringRolls) then "Chamussas" else
										 if(nRissois>nChamussas && nRissois>nSpringRolls) then "Rissois" else
										 if(nSpringRolls>nRissois && nSpringRolls>nChamussas) then "Spring Rolls" else
										 "--";;

let imprimirEstatisticas = fun () listaEncs username -> let encs = encByCliente() listaEncs [] username in
													print_string "\n==========Estatísticas==========\n";
													print_string ("Salgado Mais Comprado: "^(salgadoMaisVendido() encs)^"\n");
													print_string ("Total gasto na loja: "^(string_of_float(totalGasto() 0.0 encs))^"Mtn\n");
													print_string ("Encomendas feitas: "^(string_of_int(count_elements() 0 encs))^"\n");
													print_string "================================\n";;

(*listaEncC = Lista de Encomendas Completa*)
let rec menu = fun () listaEnc user -> print_string "++++++++++Menu+++++++++++\n";
			  print_string "1. Nova encomenda\n";
			  print_string "2. Ver encomendas\n";
			  print_string "3. Ver estatísticas\n";
			  print_string "4. Sobre o programa\n";
			  print_string "5. Minha conta\n";
			  print_string "6. Sair\n";
			  print_string "+++++++++++++++++++++++++\n";
			  try
			  let op = read_int() in if (op=1) then begin menu() (novaEncomenda() [] listaEnc user.nome) user end else 
														if (op=2) then begin print_string "\n Lista de Encomendas\n"; 
															menu() (menuEnc () (encByCliente() listaEnc [] user.nome)) user end else
														if (op=3) then begin imprimirEstatisticas() listaEnc user.nome; menu() listaEnc user end else
														if (op=4) then begin sobreProg(); menu() listaEnc user end else 
														if (op=5) then begin minhaConta() user; menu() listaEnc user end else
														if (op=6) then begin
														print_string ("Adeus "^user.nome^"! \nAté breve :)\n\n"); listaEnc end else
														begin print_string "Opção inválida\n"; menu() listaEnc user end
			  with | _ -> print_string "Opção inválida\n"; menu() listaEnc user;;

(*Cozinheiro*)
let rec verListCoz = fun () (h::t) -> if(h.estado=="Pendente") then begin print_string (string_of_int h.codEncomenda^". ");
								   print_string (h.nomeCliente^" ");
								   print_string ((string_of_float h.total)^"Mtn ");
								   print_string (h.estado^"\n"); verListCoz () t end else begin verListCoz () t end
					 | () [] -> ();;

let rec prontoEnc = fun id (h::t) -> if(id=h.codEncomenda) then h.estado <- "Pronta" else prontoEnc id t
					| id [] -> ();;

let rec menuDetEncC = fun id lista enc -> print_string ("Cliente: "^enc.nomeCliente^"\n");
									print_string ("Estado da Encomenda: "^enc.estado^"\n\nSalgados:\n");
									printSalByEnc() id enc.lista;
									print_string "\n\n1.Encomenda Pronta\n";
								   print_string "0. Voltar\n";
								   try
								   let op = read_int() in if(op=0) then () else
								   						  if(op=1) then prontoEnc id lista
								   						  else begin print_string "Opção Inválida. Tente novamente:\n"; menuDetEncC id lista enc end
									with | _ -> print_string "Opção Inválida. Tente novamente:\n"; menuDetEncC id lista enc;;

let rec detalhesEncC = fun id (h::t) -> if(id=h.codEncomenda) then begin menuDetEncC id (h::t) h end else detalhesEncC id t
					  | id [] -> print_string ("Não existe nenhuma encomenda com o código "^(string_of_int id)^".\n");;

let rec menuEncC = fun () listaEncs ->  verListCoz() listaEncs;
									print_string "\nIntroduza o Código de uma das encomendas para selecioná-la ou 0 para voltar.\n";
									try
									 let cod = read_int() in if (cod=0) then listaEncs else begin detalhesEncC cod listaEncs; listaEncs end
									with | _ -> listaEncs;;

let rec encCozinheiro = fun () (h::t) listaEncs cliente ->if(h.estado="Pendente") then encCozinheiro() t (listaEncs@[h]) cliente
													else encCozinheiro() t listaEncs cliente
					| () [] listaEncs cliente -> listaEncs;;

let rec menuCozinheiro = fun () listaEnc user -> print_string "++++++++++Menu+++++++++++\n";
			  print_string "1. Ver encomendas\n";
			  print_string "2. Sobre o programa\n";
			  print_string "3. Minha conta\n";
			  print_string "4. Sair\n";
			  print_string "+++++++++++++++++++++++++\n";
			  try
			  let op = read_int() in if (op=1) then begin print_string "\n Lista de Encomendas\n"; 
															menuCozinheiro() (menuEncC () (encCozinheiro() listaEnc [] user.nome)) user end else 
														if (op=2) then begin sobreProg(); menuCozinheiro() listaEnc user end else
														if (op=3) then begin minhaConta() user; menuCozinheiro() listaEnc user end else
														if (op=4) then begin
														print_string ("Adeus "^user.nome^"! \nAté breve :)\n\n"); listaEnc end else
														begin print_string "Opção inválida\n"; menuCozinheiro() listaEnc user end
			  with | _ -> print_string "Opção inválida\n"; menuCozinheiro() listaEnc user;;

(*Administrador*)

(*type utilizador = {id:int; mutable nome:string; nomeUsuario:string; mutable senha:string; mutable tipo:string};;*)
let rec getNextUser = fun lastId (h::t) -> getNextUser h.id t
						| lastId [] -> (lastId+1);;

let rec readABC = fun () -> let r = nth_char (read_line()) 0 in
					   if(r=`a` || r=`A`) then "Administrador" else
					   if(r=`b` || r=`B`) then "Cliente" else
					   if(r=`c` || r=`C`) then "Cozinheiro"
					   else begin print_string "Resposta inválida. Por favor, introduza 'a', 'b' ou 'c':\n"; readABC () end;;

let rec novoUser = fun () listaUsers -> let uid = getNextUser 0 listaUsers in
									 print_string "Introduza o nome real do novo utilizador:";
									 let nomeR = read_line() in
									 print_string "Introduza o nome de utilizador (ele usará este nome para acessar ao sistema):";
									 let nomeUser = read_line() in
									 print_string "Este utilizador é administrador(a), cliente(b) ou cozinheiro(c)? (a/b/c)";
									 let tipoU= readABC() in
									 let novoUser = {id=uid; nome=nomeR; nomeUsuario=nomeUser; senha="isctem"; tipo=tipoU} in
									 print_string ("Utilizador adicionado com sucesso!\n");
									 listaUsers@[novoUser];;

let rec verUsers = fun () (h::t) -> print_string (string_of_int h.id^".   ");
								   print_string (h.nome^"   ");
								   print_string (h.nomeUsuario^"   ");
								   print_string (h.tipo^"\n"); verUsers () t
					 | () [] -> ();;

let rec alterarNome = fun () user -> print_string("Introduza o novo nome: "); let novoNome = read_line() in
									 user.nome<-novoNome; updateUser() user; print_string ("Nome alterado com sucesso!\n");;

let rec reporSenha = fun () user-> print_string ("Tem a certeza que pretende repor a senha? (s/n)");
									let resp = readSN() in if(resp==`s` || resp==`S`) then
									begin user.senha<-"isctem"; updateUser() user; print_string "Senha reposta com sucesso!\n" end
									else ();;

let rec verDetUser = fun id user -> print_string (user.tipo^"\n");
									print_string ("Nome: "^user.nome^"\n");
									print_string ("Nome de utilizador: "^user.nomeUsuario);
									print_string "\n\n1.Alterar o nome\n";
								   print_string "2. Repor Senha\n";
								   print_string "0. Voltar\n";
								   try
								   let op = read_int() in if(op=0) then () else
								   						  if(op=1) then alterarNome() user else
								   						  if(op=2) then reporSenha() user
								   						  else begin print_string "Opção Inválida. Tente novamente:\n"; verDetUser id user end
									with | _ -> print_string "Opção Inválida. Tente novamente:\n"; verDetUser id user;;

let rec detalhesUser = fun id (h::t) -> if(id=h.id) then begin verDetUser id h end else detalhesUser id t
					  | id [] -> print_string ("Não existe nenhum utilizador com o código "^(string_of_int id)^".\n");;

let rec menuUsers = fun () listaUsers ->  verUsers() listaUsers;
									print_string "\nIntroduza o Código de um dos utilizadores para selecioná-lo ou 0 para voltar.\n";
									try
									 let cod = read_int() in if (cod=0) then listaUsers else begin detalhesUser cod listaUsers; listaUsers end
									with | _ -> listaUsers;;

let rec gerirUtilizadores = fun() listaUsers -> print_string "1. Adicionar Utilizador\n"; print_string "2. Ver Utilizadores\n";
							print_string "0. Voltar\n"; try
								let op = read_int() in if(op=1) then begin gerirUtilizadores() (novoUser() listaUsers) end else
													   if(op=2) then begin gerirUtilizadores() (menuUsers() listaUsers) end else
													   if(op=0) then listaUsers else
													   		begin print_string "Opção inválida\n"; gerirUtilizadores() listaUsers end 
							with
							| _ -> print_string "Opção inválida\n"; gerirUtilizadores() listaUsers;;

let rec menuAdministrador = fun () listaEnc listaUsers user -> print_string "++++++++++Menu+++++++++++\n";
			  print_string "1. Nova encomenda\n";
			  print_string "2. Ver encomendas\n";
			  print_string "3. Gerir utilizadores\n";
			  print_string "4. Ver estatísticas\n";
			  print_string "5. Sobre o programa\n";
			  print_string "6. Minha conta\n";
			  print_string "7. Sair\n";
			  print_string "+++++++++++++++++++++++++\n";
			  try
			  let op = read_int() in if (op=1) then begin menuAdministrador() (novaEncomenda() [] listaEnc user.nome) listaUsers user end else 
														if (op=2) then begin print_string "\n Lista de Encomendas\n"; 
															menuAdministrador() (menuEnc () listaEnc) listaUsers user end else
														if (op=3) then begin menuAdministrador() listaEnc (gerirUtilizadores() listaUsers) user end else
														if (op=4) then begin imprimirEstatisticas() listaEnc user.nome; menuAdministrador() listaEnc listaUsers user end else
														if (op=5) then begin sobreProg(); menuAdministrador() listaEnc listaUsers user end else 
														if (op=6) then begin minhaConta() user; menuAdministrador() listaEnc listaUsers user end else
														if (op=7) then begin
														print_string ("Adeus "^user.nome^"! \nAté breve :)\n\n");listaEnc end else
														begin print_string "Opção inválida\n"; menuAdministrador() listaEnc listaUsers user end 
			  with | _ ->  print_string "Opção inválida!\n"; menuAdministrador() listaEnc listaUsers user;;

let rec existeNaLista = fun () elem (h::t) -> if(h.codEncomenda=elem.codEncomenda) then true else existeNaLista() elem t
							| () elem [] -> false;;

let rec concatEnc_noRepeat = fun () (h::t) lista2 -> if (existeNaLista() h lista2) then concatEnc_noRepeat() t lista2 else concatEnc_noRepeat() t (lista2@[h])
								| () [] lista2 -> lista2;;

let rec lerSal = fun cnl lista ->
	try
		let cod = int_of_string(input_line cnl) in
		let codE = int_of_string(input_line cnl) in
		let nome = input_line cnl in
		let qtd = int_of_string(input_line cnl) in
		let piri = nth_char (input_line cnl) 0 in
		let frito = nth_char (input_line cnl) 0 in
		let salgado = {codigo=cod;codE=codE;nomeSalgado=nome;qtd=qtd;piri=piri;frito=frito} in
			lerSal cnl (lista@[salgado])
	with
	| end_of_file -> lista;;

let rec getSalByEnc = fun idEnc (h::t) lista -> if(h.codE=idEnc) then getSalByEnc idEnc t lista@[h] else getSalByEnc idEnc t lista
				  | idEnc [] lista -> lista;;

let rec lerEnc = fun cnl lista listaSal ->
	try
		let cod = int_of_string(input_line cnl) in
		let nome = input_line cnl in
		let lst = (getSalByEnc cod listaSal []) in
		let total = float_of_string(input_line cnl) in
		let estado = input_line cnl in
		let encomenda = {codEncomenda=cod;nomeCliente=nome;lista=lst;total=total;estado=estado} in
			lerEnc cnl (lista@[encomenda]) listaSal
	with
	| end_of_file -> lista;;

let rec existeUser = fun username password (h::t) -> if(h.nomeUsuario = username && h.senha=password) then h 
													else existeUser username password t
					 | username password [] -> {id=0;nome="nome";nomeUsuario="username";senha="pass";tipo="tipo"};;

let rec login () = print_string "SISTEMA DE GESTÃO DE VENDA DE SALGADOS\n";
			print_string "Nome de utilizador: ";
			let nome = read_line() in
			print_string "Senha: ";
			let senha = read_line() in
			let canalLog = open_in "Utilizadores.txt" in 
			let users = canalLogin canalLog [] in
			let currentUser = existeUser nome senha users in
			let canalSal = open_in "Salgados.txt" in
			let listaSal = lerSal canalSal [] in
			let canalEnc = open_in "Encomendas.txt" in
			let listaEnc = lerEnc canalEnc [] listaSal in
			if(currentUser.id!=0) then begin print_string ("\nSeja Bem-vindo "^currentUser.nome^"!\n");
			if(currentUser.tipo="Administrador") then begin let lstComplet = concatEnc_noRepeat() (listaEnc@(menuAdministrador () listaEnc users currentUser)) [] in abreCeEnc() lstComplet; abreCe() (getTodosSalgados() lstComplet []) end else
			if(currentUser.tipo="Cozinheiro") then begin let lstE = (listaEnc@(menuCozinheiro () listaEnc currentUser)) in abreCeEnc() lstE; abreCe() (getTodosSalgados() lstE []) end else begin
			let lstE = menu () listaEnc currentUser in let listaFinal = concatEnc_noRepeat() lstE listaEnc in abreCeEnc() (listaFinal); abreCe() (getTodosSalgados() (listaFinal) []) end; login () 
			 end
			else begin print_string "Nome do utilizador ou senha incorrecto(s)! Tente novamente.\n\n";login() end;;
login();;