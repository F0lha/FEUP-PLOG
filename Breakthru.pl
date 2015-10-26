

:-use_module(library(lists)).
:-use_module(library(between)).
:-use_module(library(random)).

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
	[[2,0,0,0,1,0,2,0,0,0,0],
	[0,0,0,1,0,0,0,0,0,5,0],
	[0,1,2,0,0,2,0,0,0,1,0],
	[0,0,1,0,0,0,0,0,1,0,0],	
	[0,0,0,0,0,0,0,0,0,1,0],
	[0,0,0,0,0,0,0,0,1,0,2],	
	[0,1,0,2,0,0,0,2,0,1,0],
	[0,1,0,0,0,0,1,0,0,0,0],
	[0,0,0,0,0,0,1,0,0,0,0],
	[0,0,0,0,0,0,0,1,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0]]).

testing:-final_board(Board),playBestMove(Board,1,NewBoard),printTable(NewBoard,0,0).
	
%testing(Value):-final_board(Board),evaluateBoard(Board,0,Value).

%%%% MENUS %%%%

playMenu:-nl,
nl,
write('1 - HUM - HUM '),nl,
write('2 - HUM - PC '),nl,
write('3 - PC - PC '),nl,
write('4 - Back '), nl,
read(Answer), playMenuAnswer(Answer).


playMenuAnswer(1):-initial_board(Board), playFirst(Board,0,0),!,menu.
playMenuAnswer(2):-initial_board(Board), playFirst(Board,1,0),!,menu.
playMenuAnswer(3):-initial_board(Board), playFirst(Board,1,1),!,menu.
playMenuAnswer(4):-!,menu.
playMenuAnswer(_):-write('Wrong Input'),nl,nl,!,playMenu.

menu:- nl, write('Bem Vindo ao BreakThru'),nl,
nl,
write('1 - Jogar '),nl,
write('2 - Creditos '),nl,
write('3 - Exit '),nl,
read(Answer), menuAnswer(Answer).

menuAnswer(1):-playMenu.
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

validMove(Board,X,Y,XF,YF,Player,NewCost,NewestCost):-((getDiagonals(X,Y,XF,YF),playerCost(Board,XF,YF,Player2,_), Player2 =\= -1,Player=\=Player2,whatValue(Board,X,Y,Value),((Value=:= 5, MoreValue is 0);(MoreValue is 1)));
											(inLine(Board,X,Y,XF,YF), MoreValue is 0)),checkCost(NewCost,MoreValue,NewestCost).


%continueGame(Board).

continueGame(Board):- findElem(5,Board), \+(isOnEdge(Board)).

%isOnEdge(Board).

isOnEdge(Board):-between(1,11,Index),((whatValue(Board,Index,1,Value),Value=:=5);
										(whatValue(Board,Index,11,Value),Value=:=5);
										(whatValue(Board,1,Index,Value),Value=:=5);
										(whatValue(Board,11,Index,Value),Value=:=5)).

findElem(Elem,[Elem|_]).

findElem(Elem,[X|Rest]):- is_list(X),findElem(Elem,X);findElem(Elem,Rest).

findElem(Elem,[X|Rest]):- \+(is_list(X)),findElem(Elem,Rest).

%%%%%%%%%%%%%%%%%% Movimentação de Peças %%%%%%%%%%%%%%%%%%%%%%%%

%playFirst(Board,Robot,Robot).

playFirst(Board,Bot1,Bot2):-printTable(Board,0,0),play(Board,0,Bot1,Bot2).

%play(Board,CurrPlayer,Bot1,Bot2). TODO play(Board,CurrPlayer,Bot1,Bot2,Level) TODO Level

play(Board,0,Bot1,Bot2):-continueGame(Board), whoPlays(Board,0,NewBoard,Bot1,Bot2,_),!,play(NewBoard,1,Bot1,Bot2).
play(Board,1,Bot1,Bot2):-continueGame(Board), whoPlays(Board,1,NewBoard,Bot1,Bot2,_),!,play(NewBoard,0,Bot1,Bot2).


play(_,0,_,_):-write('Jogador Cinzento ganhou!').
play(_,1,_,_):-write('Jogador Amarelo ganhou!').

%whoPlays(Board,Player,NewBoard,Bot1,Bot2,Level). TODO LEVEL

whoPlays(Board,0,NewBoard,0,_,_):-chooseMove(Board,0,NewBoard,2).
whoPlays(Board,1,NewBoard,_,0,_):-chooseMove(Board,1,NewBoard,2).
whoPlays(Board,0,NewBoard,1,_,_):-playBestMove(Board,0,NewBoard).
whoPlays(Board,1,NewBoard,_,1,_):-playBestMove(Board,1,NewBoard).

%canUseThisPiece(Board,X,Y,Player,CostLeft,NewCost).

canUseThisPiece(Board,X,Y,Player,CostLeft,NewCost):-playerCost(Board,X,Y,RightPlayer,Diff),checkCost(CostLeft,Diff,NewCost),RightPlayer =:= Player.

%chooseMove(Board,Player,NewBoard,CostLeft)

chooseMove(Board,_,Board,0).
chooseMove(Board,Player,NewBoard,CostLeft):- write('Que peca deseja mover? Jogador '),((Player =:= 0, write('Amarelo'));(Player =:= 1,write('Cinzento'))),write(' com '),write(CostLeft),write(' Jogadas:')
										,nl,write('X = '), read(X),nl, write('Y = '), read(Y),nl,
										canUseThisPiece(Board,X,Y,Player,CostLeft,NewCost),
										write('New X = '), read(XF),nl, write('New Y = '),read(YF),nl,
										validMove(Board,X,Y,XF,YF,Player,NewCost,NewestCost), 
										movePiece(Board,X,Y,XF,YF,NewBoard2),
										printTable(NewBoard2,XF,YF),
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


%%%%%%%%%%%%%%%%%%%%%%%%%   BOT   %%%%%%%%%%%%%%%%%%%%%%%


getBestMove(Board,Player,Move,CostLeft):-	listAllPossibleMoves(Board,Player,CostLeft,L),random_permutation(L,List),
															evaluate_and_choose(List,Board,Player,(_,-2000),Move).

%evaluate_and_choose  Based on the Art of Prolog predicate

evaluate_and_choose([],_,_,(Move,_),Move).

evaluate_and_choose([X-Y-XF-YF-1 | ListMoves] ,Board, Player ,Record, BestMove):-
				movePiece(Board,X,Y,XF,YF,NewBoard),
				getBestMove(NewBoard,Player,X1-Y1-XF1-YF1-0,1),
				movePiece(NewBoard,X1,Y1,XF1,YF1,NewBoard2),
				evaluateBoard(NewBoard2,Player,Value),
				updateBestMove([X-Y-XF-YF-1,X1-Y1-XF1-YF1-0], Value, Record, Record1),
				evaluate_and_choose(ListMoves,Board,Player,Record1,BestMove).

evaluate_and_choose([X-Y-XF-YF-0 | ListMoves] ,Board, Player ,Record, BestMove):-
				movePiece(Board,X,Y,XF,YF,NewBoard),
				evaluateBoard(NewBoard,Player,Value),
				updateBestMove(X-Y-XF-YF-0, Value, Record, Record1),
				evaluate_and_choose(ListMoves,Board,Player,Record1,BestMove).


updateBestMove(_,Value,(Move1,Value1),(Move1,Value1)):- Value =< Value1.
updateBestMove(Move,Value,(_,Value1),(Move,Value)):- Value > Value1.


%evaluateBoard(Board,Player,Value).


evaluateBoard(Board,_,Value):- 	\+(continueGame(Board)),write('passa aqui1'),Value is 2000.
evaluateBoard(Board,0,Value):-	checkMateGray(Board,_,_,_,_),write('passa aqui3'),Value is -1500.
evaluateBoard(Board,0,Value):-	checkMateYellow(Board,_,_,_,_),\+ (checkMateGray(Board,_,_,_,_)),write('passa aqui2'),Value is 1500.
evaluateBoard(Board,1,Value):-	checkMateYellow(Board,_,_,_,_),write('passa aqui4'),Value is -1500.
evaluateBoard(Board,1,Value):-	checkMateGray(Board,_,_,_,_),\+ (checkMateYellow(Board,_,_,_,_)),write('passa aqui5'),Value is 1500.
evaluateBoard(Board,0,Value):-	motherShipPositionValue(Board,MValue),getNShips(Board,0,NPlayer),
								getNShips(Board,1,NPlayer1),Value is (MValue+NPlayer-NPlayer1).
evaluateBoard(Board,1,Value):-	getNShips(Board,1,NPlayer),
								getNShips(Board,0,NPlayer1),Value is (NPlayer-NPlayer1).

%getNShips(Board,Player,N).

getNShips(Board,Player,N):-getNShipsRecursive(Board,Player,1,1,0,N).

%getNShipsRecursive(Board,Player,X,Y,NCurr,NProx). Obligatory to be called with X and Y at 1.

getNShipsRecursive(_,_,11,12,N,N).

getNShipsRecursive(Board,Player,X,12,NCurr,NProx):-X1 is X + 1, getNShipsRecursive(Board,Player,X1,1,NCurr,NProx).

getNShipsRecursive(Board,0,X,Y,NCurr,NProx):-whatValue(Board,X,Y,Value), Value=:=2 ,N2 is NCurr+1,Y2 is Y + 1,getNShipsRecursive(Board,0,X,Y2,N2,NProx).

getNShipsRecursive(Board,1,X,Y,NCurr,NProx):-whatValue(Board,X,Y,Value), Value=:=1 ,N2 is NCurr+1,Y2 is Y + 1,getNShipsRecursive(Board,1,X,Y2,N2,NProx).

getNShipsRecursive(Board,Player,X,Y,NCurr,NProx):-whatValue(Board,X,Y,Value),Y2 is Y + 1,((Player =:= 0, Value =\= 2);(Player =:= 1, Value =\= 1)),getNShipsRecursive(Board,Player,X,Y2,NCurr,NProx).

%motherShipPositionValue(Value).

motherShipPositionValue(Board,Value):-whereM(Board,X,Y), Value is sqrt((((X - 1) mod 5)*((X - 1) mod 5)) + (((Y - 1) mod 5)*((Y - 1) mod 5))).

%listAllPossibleMoves(Board,Player,CostLeft,X,Y,XF,YF,CostToSpend,List).

listAllPossibleMoves(Board,Player,CostLeft,List):-findall(X-Y-XF-YF-CostToSpend,allPossibleMoves(Board,Player,CostLeft,X,Y,XF,YF,CostToSpend),List).

%testMoves(Board,Player,CostLeft,XIndex,YIndex,XFIndex,YFIndex,CostToSpend). Tests if the Move can be done

testMoves(Board,Player,CostLeft,XIndex,YIndex,XFIndex,YFIndex,CostToSpend):-	canUseThisPiece(Board,XIndex,YIndex,Player,CostLeft,NewCost),
																				validMove(Board,XIndex,YIndex,XFIndex,YFIndex,Player,NewCost,CostToSpend).														

%allPossibleMoves(Board,Player,CostLeft,X,Y,XF,YF). Generate and Test random movements																			
																				
allPossibleMoves(Board,Player,CostLeft,X,Y,XF,YF,CostToSpend):-	between(1,11,XIndex),between(1,11,YIndex),between(1,11,XFIndex),between(1,11,YFIndex),
																	testMoves(Board,Player,CostLeft,XIndex,YIndex,XFIndex,YFIndex,CostToSpend),
																	X is XIndex,Y is YIndex, XF is XFIndex, YF is YFIndex.

%getRandomMove(Board,Player,CostLeft,X,Y,XF,YF,CostToSpend).

getRandomMove(Board,Player,CostLeft,X,Y,XF,YF,CostToSpend):-listAllPossibleMoves(Board,Player,CostLeft,List),random_member(X-Y-XF-YF-CostToSpend,List).
														

%playRandomMove(Board,Player,NewBoard,CostLeft).

playRandomMove(Board,_,Board,0).	
playRandomMove(Board,Player,NewBoard,CostLeft):-getRandomMove(Board,Player,CostLeft,X,Y,XF,YF,CostToSpend),movePiece(Board,X,Y,XF,YF,NewBoard2),
												printBotPlay(Player,X,Y,XF,YF),nl,
												printTable(NewBoard2,XF,YF),
												playRandomMove(NewBoard2,Player,NewBoard,CostToSpend).

%printBotPlay(Player, X,Y,XF,YF).

printBotPlay(0,X,Y,XF,YF):-write('Yellow Bot played X:'),write(X),write('|Y:'),write(Y),write(' to XF '), write(XF),write('|YF:'),write(YF).
printBotPlay(1,X,Y,XF,YF):-write('Gray Bot played X:'),write(X),write('|Y:'),write(Y),write(' to XF '), write(XF),write('|YF:'),write(YF).

%printBestBotPlay(Player, X,Y,XF,YF)

printBestBotPlay(0,X,Y,XF,YF):-write('Yellow Bot played X:'),write(X),write('|Y:'),write(Y),write(' to XF '), write(XF),write('|YF:'),write(YF).
printBestBotPlay(1,X,Y,XF,YF):-write('Gray Bot played X:'),write(X),write('|Y:'),write(Y),write(' to XF '), write(XF),write('|YF:'),write(YF).

%playRandomMoveWithEnd(Board,Player,NewBoard,CostLeft). A little smarter Bot that ends whenever there is the opportunity or else it plays randomly.

playRandomMoveWithEnd(Board,_,Board,0).

playRandomMoveWithEnd(Board,0,NewBoard,2):-checkMateYellow(Board,X,Y,XF,YF),movePiece(Board,X,Y,XF,YF,NewBoard2),
													printBotPlay(0,X,Y,XF,YF), write(' - Ended with CheckMate function'), nl,
													printTable(NewBoard2,XF,YF),
													playRandomMoveWithEnd(NewBoard2,_,NewBoard,0).
													
playRandomMoveWithEnd(Board,1,NewBoard,2):-checkMateGray(Board,X,Y,XF,YF),movePiece(Board,X,Y,XF,YF,NewBoard2),
													printBotPlay(1,X,Y,XF,YF), write(' - Ended with CheckMate function'),nl,
													printTable(NewBoard2,XF,YF),
													playRandomMoveWithEnd(NewBoard2,_,NewBoard,0).

playRandomMoveWithEnd(Board,Player,NewBoard,CostLeft):-playRandomMove(Board,Player,NewBoard,CostLeft).
	
%playBestMove(Board,Player,NewBoard).	
	
	
playBestMove(Board,Player,NewBoard):-	getBestMove(Board,Player,Move,2),
												((is_list(Move),nth0(0,Move,X-Y-XF-YF-_),nth0(0,Move,X1-Y1-XF1-YF1-_),
												movePiece(Board,X,Y,XF,YF,NewBoard),
												printBestBotPlay(Player,X,Y,XF,YF),nl,
												printTable(NewBoard,XF,YF),
												movePiece(NewBoard,X1,Y1,XF1,YF1,NewBoard2),
												printBestBotPlay(Player,X1,Y1,XF1,YF1),nl,
												printTable(NewBoard2,XF1,YF1));
												(Move is X-Y-XF-YF-_,
												movePiece(Board,X,Y,XF,YF,NewBoard),
												printBestBotPlay(Player,X,Y,XF,YF),nl,
												printTable(NewBoard,XF,YF))).
	
%checkMateYellow(Board).

checkMateYellow(Board,X,Y,XF,YF):-whereM(Board,X,Y),((inLine(Board,X,Y,1,Y),XF is 1, YF is Y);(inLine(Board,X,Y,11,Y),XF is 11, YF is Y);(inLine(Board,X,Y,X,1),XF is X, YF is 1);(inLine(Board,X,Y,X,11),XF is X, YF is 11)).

%checkMateGray(Board).

checkMateGray(Board,XF,YF,X,Y):-whereM(Board,X,Y),getDiagonals(X,Y,XTemp,YTemp),whatValue(Board,XTemp,YTemp,Value),Value =:= 1,XF is XTemp,YF is YTemp.

%%%%%%%%%%%%%%%%%%%%%% Printing  %%%%%%%%%%%%%%%%%%%%%%


%printBoard(Board,X,Y).

printTable(Board,X,Y):- 	nl,
							printFirstLine(_),
							nl,
							printLines(Board,X,Y),
							nl,nl.
							
printLines(Board,X,Y):-between(1,11,YIndex),nl, write(YIndex),((YIndex < 10, write(' |'));(YIndex >= 10,write('|'))), printRestLine(Board,YIndex,X,Y).

printRestLine(Board,YIndex,X,Y):-	between(1,11,XIndex), whatValue(Board,XIndex,YIndex,Value),
									((XIndex=:=X,YIndex=:=Y,writePiece(Value,1));( \+ (XIndex=:=X,YIndex=:=Y),writePiece(Value,0))), XIndex =:= 11,nl,printDivison(_), YIndex =:= 11.



printDivison(_):-write('-----------------------------------------------').

printFirstLine(_):-write('    1   2   3   4   5   6   7   8   9   10  11 ').

writePiece(0,0):-write(' . |').
writePiece(1,0):-write(' D |'). %%%% Defesa %%%%
writePiece(2,0):-write(' A |'). %%%% Ataque %%%%
writePiece(5,0):-write(' M |'). %%%% Objetivo %%%%
writePiece(1,1):-write('(D)|'). %%%% Defesa %%%%
writePiece(2,1):-write('(A)|'). %%%% Ataque %%%%
writePiece(5,1):-write('(M)|'). %%%% Objetivo %%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
