:- use_module(library(lists)).
:-use_module(library(random)).
:-use_module(library(between)).
:- use_module(library(clpfd)).
:- use_module(library(aggregate)).

:-dynamic(listWheels/1).
:-dynamic(listColorsNumber/1).



listColors([white, blue, green, yellow, red, black]).


:-[graph].

%%%% AUX FUNCTIONS  %%%%

flatten([], []) :- !.
flatten([L|Ls], FlatL) :-
    !,
    flatten(L, NewL),
    flatten(Ls, NewLs),
    append(NewL, NewLs, FlatL).
flatten(L, [L]).


removeDups([], []).

removeDups([First | Rest], NewRest) :- member(First, Rest), removeDups(Rest, NewRest),!.

removeDups([First | Rest], [First | NewRest]) :- removeDups(Rest, NewRest).

getColorOfNodes(ListNodes,List,Node1,Node2,Col1,Col2):-nth0(Index1,ListNodes,Node1),nth0(Index2,ListNodes,Node2),nth0(Index1,List,Col1),nth0(Index2,List,Col2).

makeListNSize(_,0,[]).

makeListNSize([H|Rest],N,[H|NewRest]):-N1 is N - 1, makeListNSize(Rest,N1,NewRest).

%%%%%%%%%%%%%%%%%%

%Restricts the puzzle acording to the joint wheels given

restrictDoubleWheelsAux(ListNodes,List,ListColor,(Node1,Node2)):-getColorOfNodes(ListNodes,List,Node1,Node2,Col1,Col2),
																nth0(IndexCol,ListColor,Col1),IndexCorCorrected is mod((IndexCol+3),6),
																nth0(IndexCorCorrected,ListColor,Col), Col #= Col2.

restrictDoubleWheels(ListNodes,List):-findall(X,listWheels(X),ListWheels),findall(X,listColorsNumber(X),ListColors),length(ListWheels,NWheels),
									  foreach(between(1,NWheels,Index),restrictDoubleWheels(ListNodes,List,Index,ListWheels,ListColors)).

restrictDoubleWheels(ListNodes,List,Index,ListWheels,ListColors):-	nth1(Index,ListWheels,ListWheels1),nth1(Index,ListColors,ListColors1),
																	foreach(member(Wheel1,ListWheels1),restrictDoubleWheelsAux(ListNodes,List,ListColors1,Wheel1)).

%Enables to print the colour name

printColour(Col):-listColors(ListColors),nth0(Col,ListColors,Term), print(Term).																	
																	
%Print Relation between 2 Nodes
printRelation(ListNode,List,Node,SecondNode,Index):-nth1(Index2,ListNode,SecondNode),nth1(Index,List,Cor1),nth1(Index2,List,Cor2), print('The node '), print(Node), print(' - '), printColour(Cor1), print( ' connected to '),  print(SecondNode), print(' - '), printColour(Cor2),nl.

printColorsAux(ListNodes,List,Index):-nth1(Index,ListNodes,Node),nth1(Index,List,Cor1),print('Node -> '), print(Node),print(' - Colour -> '), printColour(Cor1),nl.

%Print Node Colors

printColors(ListNodes,List):-length(ListNodes,Size),foreach(between(1,Size,Index),printColorsAux(ListNodes,List,Index)).

%Print colored Node

printNode(ListNodes,List,Index):-nth1(Index,ListNodes,Node),findall(Y,edge(Node,Y),L1),remove_dups(L1,L),foreach(member(SecondNode,L),(printRelation(ListNodes,List,Node,SecondNode,Index);true)).

%Print colored Graph

printGraph(ListNodes,List):-length(ListNodes,Size),foreach(between(1,Size,Index),printNode(ListNodes,List,Index)).

%Create List with only Variables not initialized

createEmptyList(Size,List):-length(List,Size).

%List All Nodes

listAllNodes(ListNodes):-findall(X,edge(X,_),L1),findall(X,edge(_,X),L2),append(L1,L2,L),removeDups(L,ListNodes).

%Create List with only Variables not initialized with the same size as the list of all nodes

createEmptyListNodeSized(ListNodes,List):-length(ListNodes,Size),createEmptyList(Size,List).

%Makes the restriction that 2 Adjacent Nodes can't have the same colour.

restrictTwoNodes(ListNodes,List,Node,SecondNode):- getColorOfNodes(ListNodes,List,Node,SecondNode,Col1,Col2),Col1 #\= Col2.
																			
%Restrict Color of a Node

restrictColorsOfNode(ListNodes,List,Node):-findall(Y,edge(Node,Y),L1),findall(Y,edge(Y,Node),L2),append(L1,L2,Ls),removeDups(Ls,L),foreach(member(SecondNode,L),restrictTwoNodes(ListNodes,List,Node,SecondNode)).

%Restrict the graph for having different values for adjacent nodes

restrictColorsOfGraph(ListNodes,List):-foreach(member(Node,ListNodes),restrictColorsOfNode(ListNodes,List,Node)).


menu:- nl, write('WELCOME TO MAGELLAN'),nl,
assertz(listWheels([])),
assertz(listColorsNumber([])),
nl,
write('1 - Original Puzzle '),nl,
write('2 - Credits '),nl,
write('3 - Exit '),nl,
read(Answer), menuAnswer(Answer).

menuAnswer(1):-originalGame(0),!,menu.
menuAnswer(2):-credits,!,menu.
menuAnswer(3):-!.
menuAnswer(_):-write('Wrong Input'),nl,nl,!,menu.

credits:-nl, write('Puzzle implementation made by Joao Baiao and Pedro Castro'),nl, nl.

originalMenu:-write('Its Not Possible To Fill the Puzzle with that amount of Different Colours'),nl.
		
originalGame(N):-listAllNodes(ListNodes),createEmptyListNodeSized(ListNodes,List),domain(List,0,5),nvalue(N,List),
				restrictColorsOfGraph(ListNodes,List),restrictDoubleWheels(ListNodes,List),nth0(12,List,Cor), Cor#=0,nth0(0,List,Cor), Cor#=0, labeling([],List),
				printGraph(ListNodes,List),nl,
				print('Puzzle Completed with '),print(N), print(' different colours!\n'),nl,
				fd_statistics,nl.
				
originalGame(N):-!,print('Impossible to complete the puzzle with '), print(N), print(' different colours!\n'),N1 is N+1,originalGame(N1).
