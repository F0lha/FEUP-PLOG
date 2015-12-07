
:-use_module(library(clpfd)).
:- use_module(library(lists)).

factorial(1, 1).
factorial(N, Valor) :- N1 is N-1, factorial(N1,V2),Valor is V2 * N.

fibonnaci(0,1).
fibonnaci(1,1).
fibonnaci(N,V):-N1 is N-1, N2 is N - 2, fibonnaci(N1,V1),fibonnaci(N2,V2), V is V1 + V2.

fibonacci(N,V):-
	iter(N,V,1,1,1).

iter(N,S,N1,N2,N).
iter(N,S,N1,N2,A):-A1 is A+1,N3 is N1+N2,iter(N,S,N2,N3,A1).

e_primo(2).
e_primo(N):-
	N1 is N-1,
	\+(recursive(N,N1,1)).
	
recursive(N,N1,0).
recursive(N,N1,N2):- N1 > 1,N5 is N mod N1,N3 is N1-1,recursive(N,N3,N5).

findElem(Elem,[Elem|Rest]).

findElem(Elem,[X|Rest]):- is_list([X|Rest]),findElem(Elem,Rest).

a(1,2).

%mais_proximos(+Idade,-ListaProximos).

daCartas(Cartas,[],Cartas,0).

daCartas([Cab|Cartas], [Cab|Mao1], Resto, Contador):-
	Contador1 is Contador - 1, daCartas(Cartas,Mao1,Resto,Contador1).
	
deleteFromList([Element|List],Element,List).
deleteFromList([H|List],Element,[H|NewList]):-deleteFromList(List,Element,NewList).

soma([],X,0):-!.

soma([Head|Tail],Head,N):-
	soma(Tail,Head,N1),
	N is 1+N1.
soma([_|Tail],Head,N1):-
	write(N1),nl,
	soma(Tail,Head,N1).


