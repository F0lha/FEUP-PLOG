

:-use_module(library(lists)).
:-use_module(library(between)).

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
	[[0,0,0,0,1,0,2,0,0,0,0],
	[0,0,0,1,0,0,0,0,0,0,0],
	[0,1,2,0,0,2,0,0,0,1,0],
	[0,0,1,0,0,0,0,0,1,0,0],	
	[0,0,0,0,0,0,0,0,0,1,0],
	[0,0,0,0,0,0,0,0,1,0,2],	
	[0,1,0,2,0,0,0,2,0,1,0],
	[0,1,0,0,0,1,1,0,0,0,0],
	[0,0,0,0,0,5,1,0,0,0,0],
	[0,0,0,0,0,0,0,1,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0]]).

testing:-final_board(Board),inLine(Board,7,1,4,1).
	
init:-
write('BEM-VINDO AO BREAKTHRU'),
final_board(Board), %%% Declare Board as the Board Variable
nl,
nl,
printTable(Board),
nl,
write('passou1'),
nl,
chooseMov(Board,0,NewBoard),
nl,
write('passou2'),
nl,
printTable(NewBoard).

menu:- write('Bem Vindo ao BreakThru'),nl,
nl,
write('1 - Jogar '),nl,
write('2 - Creditos '),nl,
write('3 - Exit '),nl,
read(Answer), menuAnswer(Answer).

menuAnswer(1):-final_board(Board), playFirst(Board),!,menu.
menuAnswer(2):-credits,!,menu.
menuAnswer(3):-!.
menuAnswer(_):-write('Wrong Input'),nl,nl,!,menu.

credits:-nl, write('Jogo feito por Joao Baiao e Pedro Castro'),nl, nl.

%%%%%%%%%%%%%%%%%%% Validacao de Jogadas %%%%%%%%%%%%%%%%%%%%%%%

%inLine(Board,X,Y,XF,YF).

inLine(Board,X,Y,XF,YF):-(X =:= XF, YF >= Y,Low is Y + 1,High is YF, between(Low,High,Index),whatValue(Board,X,Index,Value),((Value =\= 0,!,fail);Index =:=High));
							(X =:= XF, Y > YF,Low is YF,High is Y - 1, between(Low,High,Index),whatValue(Board,X,Index,Value),((Value =\= 0,!,fail);Index =:=High));
							(Y =:= YF, XF >= X, Low is X + 1,High is XF, between(Low,High,Index),whatValue(Board,Index,Y,Value),((Value =\= 0,!,fail);Index =:=High));
							(Y =:= YF,X > XF, Low is XF,High is X - 1, between(Low,High,Index),whatValue(Board,Index,Y,Value),((Value =\= 0,!,fail);Index =:=High)).
												
%getDiagonals(X,Y,XF,YF).
												 
getDiagonals(X,Y,XF,YF):-bagof(XF,diagonal(X,Y,XF,YF),LX),getAllElements(LX,XF).				
							
%diagonal(X,Y,XF,YF).

diagonal(X,Y,XF,YF):-XT is X + 1, XB is X - 1,YT is Y + 1, YB is Y - 1,(
					(XT < 12,YT < 12, XF is XT, YF is YT);
					(XB > 0,YT < 12,XF is XB, YF is YT);
					(XT < 12,YB > 0,XF is XT, YF is YB);
					(XB > 0,YB > 0,XF is XB, YF is YB)).

%validMove(Board,X,Y,Player).

validMove(Board,X,Y,XF,YF,Player,NewCost,NewestCost):-((diagonal(X,Y,XF,YF),playerCost(Board,XF,YF,Player2,_), Player2 =\= -1,Player=\=Player2,whatValue(Board,X,Y,Value),((Value=:= 5, MoreValue is 0);(MoreValue is 1)));
											(inLine(Board,X,Y,XF,YF), MoreValue is 0)),checkCost(NewCost,MoreValue,NewestCost).


%continueGame(Board).

continueGame(Board):- findElem(5,Board), \+(isOnEdge(Board)).
continueGame(_):- fail.

%isOnEdge(Board).

isOnEdge(Board):-between(1,11,Index),((whatValue(Board,Index,1,Value),Value=:=5);
										(whatValue(Board,Index,11,Value),Value=:=5);
										(whatValue(Board,1,Index,Value),Value=:=5);
										(whatValue(Board,11,Index,Value),Value=:=5)).

findElem(Elem,[Elem|_]).

findElem(Elem,[X|Rest]):- is_list(X),findElem(Elem,X);findElem(Elem,Rest).

findElem(Elem,[X|Rest]):- \+(is_list(X)),findElem(Elem,Rest).

%%%%%%%%%%%%%%%%%% Movimentação de Peças %%%%%%%%%%%%%%%%%%%%%%%%

playFirst(Board):-printTable(Board),play(Board,0).

play(Board,0):-continueGame(Board), chooseMove(Board,0,NewBoard,2),!,play(NewBoard,1).
play(Board,1):-continueGame(Board), chooseMove(Board,1,NewBoard,2),!,play(NewBoard,0).
play(_,0):-write('Jogador Cinzento ganhou!').
play(_,1):-write('Jogador Amarelo ganhou!').

%chooseMove(Board,Player,NewBoard,CostLeft)
chooseMove(Board,_,Board,0).
chooseMove(Board,Player,NewBoard,CostLeft):- write('Que peca deseja mover? Jogador '),((Player =:= 0, write('Amarelo'));(Player =:= 1,write('Cinzento'))),write(' com '),write(CostLeft),write(' Jogadas:')
										,nl,write('X = '), read(X),nl, write('Y = '), read(Y),nl,
										playerCost(Board,X,Y,RightPlayer,Diff), checkCost(CostLeft,Diff,NewCost),RightPlayer =:= Player,
										write('New X = '), read(XF),nl, write('New Y = '),read(YF),nl,
										validMove(Board,X,Y,XF,YF,Player,NewCost,NewestCost), 
										movePiece(Board,X,Y,XF,YF,NewBoard2),
										printTable(NewBoard2),
										chooseMove(NewBoard2,Player,NewBoard,NewestCost),!.
										
chooseMove(Board,Player,NewBoard,CostLeft):-write('Jogada Impossivel'),nl,nl,chooseMove(Board,Player,NewBoard,CostLeft),!.

checkCost(CostLeft,Cost,NewCost):-Cost =< CostLeft, NewCost is (CostLeft-Cost).

playerCost(Board,X,Y,0,1):- whatValue(Board,X,Y,Value), Value =:= 2.
playerCost(Board,X,Y,0,2):- whatValue(Board,X,Y,Value), Value =:= 5.
playerCost(Board,X,Y,1,1):- whatValue(Board,X,Y,Value), Value =:= 1.
playerCost(_,_,_,-1,0).

movePiece(Board,X,Y,XF,YF,NewBoard):-whatValue(Board,X,Y,Value),defineSpace(Board,X,Y,0,TempBoard),defineSpace(TempBoard,XF,YF,Value,NewBoard).

defineSpace([],_,_,_,[]).

defineSpace([_|Rest],1,0,NewValue,NewBoard):-append([NewValue],Rest,NewBoard).

defineSpace([H|Rest],X,0,NewValue,NewBoard):- X2 is X - 1, defineSpace(Rest,X2,0,NewValue,NewBoard2),append([H],NewBoard2,NewBoard).

defineSpace([H|Rest], X, Y, NewValue, NewBoard):- X > 0, Y2 is Y -1, Y2 =:= 0, defineSpace(H,X,Y2,NewValue,NewBoard2),append([NewBoard2],Rest,NewBoard).

defineSpace([H|Rest], X, Y, NewValue, NewBoard):- X > 0, Y2 is Y-1,defineSpace(Rest,X,Y2,NewValue,NewBoard2),append([H],NewBoard2,NewBoard).


%%%%%%%%%%%%%%%%%%%%% FUNCOES AUXILIARES   %%%%%%%%%%%%%%%%%%%%%%%%%


%whereM(Board,X,Y).

whereM(Board,X,Y):-between(1,11,Index1),between(1,11,Index2),whatValue(Board,Index1,Index2,Value),Value =:= 5, X is Index1, Y is Index2.

%whatValue(Board,X,Y,Value).

whatValue(Board,X,Y,Value):-X2 is X - 1, Y2 is Y -1, nth0(Y2,Board,List),nth0(X2,List,Value).

%getAllElements(List,Elem).

getAllElements([X|_],X).
getAllElements([_|Rest],Y):-getAllElements(Rest,Y).

%getAllPossibleMoves(Board,Player,List).



%%%%%%%   BOT   %%%%%

%checkMateYellow(Board).

checkMateYellow(Board):-whereM(Board,X,Y),(inLine(Board,X,Y,1,Y);inLine(Board,X,Y,11,Y);inLine(Board,X,Y,X,1);inLine(Board,X,Y,X,11)).

%checkMateGray(Board).

checkMateGray(Board):-whereM(Board,X,Y),getDiagonals(X,Y,XF,YF),whatValue(Board,XF,YF,Value),Value =:= 1.

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
