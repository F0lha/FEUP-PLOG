

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
	
	final_board(
	[[0,0,0,0,1,0,2,0,5,0,0],
	[0,0,0,1,0,0,0,0,0,0,0],
	[0,1,2,0,0,2,0,0,0,1,0],
	[0,0,1,0,0,0,0,0,1,0,0],	
	[0,0,0,0,0,0,0,0,0,1,0],
	[0,0,0,0,0,0,0,0,0,0,0],	
	[0,1,0,2,0,0,0,2,0,1,0],
	[0,1,0,0,1,1,2,0,0,0,0],
	[0,0,0,0,0,0,1,0,0,0,0],
	[0,0,0,0,0,0,0,1,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0]]).
	

init:-
write('BEM-VINDO AO BREAKTHRU'),
final_board(Board), %%% Declare Board as the Board Variable
nl,
nl,
printTable(Board),
findElem(4,Board).


%%%%%%%%%%%%%%%%%%% Validacao de Jogadas %%%%%%%%%%%%%%%%%%%%%%%

findElem(Elem,[Elem|_]).

findElem(Elem,[X|Rest]):- is_list(X),findElem(Elem,X);findElem(Elem,Rest).

findElem(Elem,[X|Rest]):- \+(is_list(X)),findElem(Elem,Rest).

%%%%%%%%%%%%%%%%%% Movimentação de Peças %%%%%%%%%%%%%%%%%%%%%%%%

on(Item,[Item|Rest]).

on(Item,[DisregardHead|Tail]):- on(Item,Tail).

%%%%%%%%%%%%%%%%%%%%%% COPIADO CARALHO CUIDADO %%%%%%%%%%%%%%%%%%%%%%

printTable(Table):-
	nl,
	printFirstLine(_),
	nl,nl,
	printLines(1,Table),
	nl.
printLines(_,[]).

printLines(1,[Lin|Resto]):-
	write(1), write(' |'),printLine(Lin), write('    W | C | E'),
	nl,
	printUnderscores(_),nl,
	printLines(2,Resto).
	
printLines(2,[Lin|Resto]):-
	write(2), write(' |'),printLine(Lin), write('    SW| S |SE'),
	nl,
	printUnderscores(_),nl,
	printLines(3,Resto).
	
printLines(N,[Lin|Resto]):- N < 10,N > 2,
	write(N), write(' |'),printLine(Lin), nl,
	printUnderscores(0),nl,
	N2 is N + 1,
	printLines(N2,Resto).
	
printLines(N,[Lin|Resto]):- N >= 10,
	write(N), write('|'),printLine(Lin), nl,
	N2 is N + 1,
	printUnderscores(0),nl,
	printLines(N2,Resto).

printLine([]).
printLine([El|Resto]):-
	writePiece(El),
	printLine(Resto).
	
printUnderscores(_):-write('_______________________________________________').

printFirstLine(_):-write('    1   2   3   4   5   6   7   8   9   10  11     NW| N |NE').

writePiece(0):-write(' . |').
writePiece(1):-write(' D |'). %%%% Defesa %%%%
writePiece(2):-write(' A |'). %%%% Ataque %%%%
writePiece(5):-write(' M |'). %%%% Objetivo %%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%