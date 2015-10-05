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