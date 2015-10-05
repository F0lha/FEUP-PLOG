accu([],L,L).
accu([H|L1],L,R):-accu(L1,[H|L],R).


inverter(L1,L2):- accu(L1,[],L2).

%membro(X,[X|_]).
%membro(X,[_|L]):-[_|L]\=[],membro(X,L).

membro(X,L):- append(_,[X|_],L). 

last([H|_],X):- X is H.
last([_|L],X):- last(L,X).

%n_th(L,N,X).

n_th([X|_],1,X).
n_th([_|L],N,X):- N2 is N - 1, n_th(L,N2,X). 



delete_one(X,[X|L1],L1).
delete_one(X,[H|L1],L2):- delete_one(X,L1,L3), append([H],L3,L2).


delete_all(_,[],[]).
delete_all(X,[X|L1],L2):- delete_all(X,L1,L2).
delete_all(X,[H|L1],L2):- delete_all(X,L1,L3), append([H],L3,L2).


delete_all_list([],L,L).
delete_all_list([X|LX],L1,L2):-delete_all(X,L1,L3), delete_all_list(LX,L3,L2).


before(A,B,L):- append(_,[A|L2],L),
	append(_,[B|_],L2).
	
conta([],0).
conta([_|L],N):-conta(L,N1),N is N1 + 1.

conta_elem(_,[],0).
conta_elem(X,[X|L],N):-conta_elem(X,L,N1), N is N1 + 1.
conta_elem(X,[H|L],N):- X\=H, conta_elem(X,L,N).

substitui(_,_,[],[]).
substitui(X,Y,[X|L],L1):- substitui(X,Y,L,L2), append([Y],L2,L1).
substitui(X,Y,[H|L],L1):- substitui(X,Y,L,L2), append([H],L2,L1).

elimina_duplicados([],[]).
elimina_duplicados([X|L1],L2):- delete_all(X,L1,L3), elimina_duplicados(L3,L4), append([X],L4,L2).

ordenada([_|[]]).
ordenada([X|L]):- 
	ordenada2(X,L),
	ordenada(L).
ordenada2(X,[Y|_]):- Y > X.

ordena(L1,L2):- 
	ordena2([],L1,L2).

ordena2(L,[],L).

ordena2(LA,[X|LPOS],LF):-
	ordem(X,LPOS),
	append(LA,[X],L1),
	ordena2(L1,LPOS,LF).
ordena2(LA,[X|LPOS],LF):-
	troca(X,LPOS,LPOS2),
	append(LA,LPOS2,LN),
	ordena2([],LN,LF).
	
ordem(_,[]).
ordem(X,[Y|_]):- Y > X.

troca(X,[Y|L],LN):-
	append([Y],[X],LN2),
	append(LN2,L,LN).
