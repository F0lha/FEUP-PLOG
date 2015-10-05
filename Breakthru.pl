

:-use_module(library(lists)).

initial_board(
	[[0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,1,1,1,1,1,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0],
	[0,1,0,0,2,2,2,0,0,1,0],	
	[0,1,0,2,0,0,0,2,0,1,0],
	[0,1,0,2,0,5,0,2,0,1,0],	
	[0,1,0,2,0,0,0,2,0,1,0],
	[0,1,0,0,2,2,2,0,0,1,0],
	[0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,1,1,1,1,1,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0]]).
	

init:-
write('BEM-VINDO AO BREAKTHRU'),
initial_board(Board), %%% Declare Board as the Board Variable
visualiza_estado(Board),
findElem(4,Board).


%%%%%%%%%%%%%%%%%%% Validacao de Jogadas %%%%%%%%%%%%%%%%%%%%%%%

findElem(Elem,[Elem|_]).

findElem(Elem,[X|Rest]):- is_list(X),findElem(Elem,X);findElem(Elem,Rest).

findElem(Elem,[X|Rest]):- \+(is_list(X)),findElem(Elem,Rest).

%%%%%%%%%%%%%%%%%% Movimentação de Peças %%%%%%%%%%%%%%%%%%%%%%%%

on(Item,[Item|Rest]).

on(Item,[DisregardHead|Tail]):- on(Item,Tail).

%%%%%%%%%%%%%%%%%%%%%% COPIADO CARALHO CUIDADO %%%%%%%%%%%%%%%%%%%%%%
%visualiza_estado(+Tabuleiro)
visualiza_estado(Tab):-
	nl,
	mostra_linhas(1,Tab),
	nl.

mostra_linhas(_,[]).
mostra_linhas(N,[Lin|Resto]):-
	mostra_linha(Lin), write(' '), nl,
	N2 is N+1,
	mostra_linhas(N2, Resto).

mostra_linha([]).
mostra_linha([El|Resto]):-
	escreve(El),
	mostra_linha(Resto).

escreve(0):-write(' .').
escreve(1):-write(' D'). %%%% Defesa %%%%
escreve(2):-write(' A'). %%%% Ataque %%%%
escreve(5):-write(' O'). %%%% Objetivo %%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%