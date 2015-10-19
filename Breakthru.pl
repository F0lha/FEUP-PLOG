

:-use_module(library(lists)).

%%% Jogador Amarelo = 0 %%%
%%% Jogador Cinzento = 1 %%%

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
nl,
write('passou1'),
nl,
playerMove(Board,7,1,9,2,1,NewBoard),
nl,
write('passou2'),
nl,
printTable(NewBoard).


%%%%%%%%%%%%%%%%%%% Validacao de Jogadas %%%%%%%%%%%%%%%%%%%%%%%

%whatValue(Board,X,Y,Value).

whatValue(Board,X,Y,Value):-X2 is X - 1, Y2 is Y -1, nth0(Y2,Board,List),nth0(X2,List,Value).

findElem(Elem,[Elem|_]).

findElem(Elem,[X|Rest]):- is_list(X),findElem(Elem,X);findElem(Elem,Rest).

findElem(Elem,[X|Rest]):- \+(is_list(X)),findElem(Elem,Rest).

%%%%%%%%%%%%%%%%%% Movimentação de Peças %%%%%%%%%%%%%%%%%%%%%%%%

playerMove(Board,X,Y,XF,YF,Player,NewBoard):-whatPlayer(Board,X,Y,Player2), Player2 =:= Player, movePiece(Board,X,Y,XF,YF,NewBoard).
playerMove(Board,_,_,_,_,_,Board).

whatPlayer(Board,X,Y,Player):- whatValue(Board,X,Y,Value), (Value =:= 2;Value =:=5),Player is 0.
whatPlayer(Board,X,Y,Player):- whatValue(Board,X,Y,Value), Value =:= 1, Player is 1.
whatPlayer(_,_,_,Player):- Player is -1.

movePiece(Board,X,Y,XF,YF,NewBoard):-whatValue(Board,X,Y,Value),defineSpace(Board,X,Y,0,TempBoard),defineSpace(TempBoard,XF,YF,Value,NewBoard).

defineSpace([],_,_,_,[]).

defineSpace([_|Rest],1,0,NewValue,NewBoard):-append([NewValue],Rest,NewBoard).

defineSpace([H|Rest],X,0,NewValue,NewBoard):- X2 is X - 1, defineSpace(Rest,X2,0,NewValue,NewBoard2),append([H],NewBoard2,NewBoard).

defineSpace([H|Rest], X, Y, NewValue, NewBoard):- X > 0, Y2 is Y -1, Y2 =:= 0, defineSpace(H,X,Y2,NewValue,NewBoard2),append([NewBoard2],Rest,NewBoard).

defineSpace([H|Rest], X, Y, NewValue, NewBoard):- X > 0, Y2 is Y-1,defineSpace(Rest,X,Y2,NewValue,NewBoard2),append([H],NewBoard2,NewBoard).



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