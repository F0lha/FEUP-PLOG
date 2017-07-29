:- use_module(library(lists)).
:-use_module(library(random)).
:-use_module(library(between)).
:- use_module(library(clpfd)).
:- use_module(library(aggregate)).

:-dynamic(listWheels/1).
:-dynamic(listColorsNumber/1).
:-dynamic(redge/2).
:-dynamic(timeB/1).

listColors([white, blue, green, yellow, red, black]).

:-[graph].

:-initialization(menu).

%%%% AUX FUNCTIONS  %%%%

%rotateVec(OriginalVec,NewVec,N).

rotateVec(Vec,Vec,0).

rotateVec([H|Rest],NewVec,N):-N > 0,N1 is N - 1, append(Rest,[H],Vec),rotateVec(Vec,NewVec,N1).

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
																element(IndexCol,ListColor,Col1),
																rotateVec(ListColor,NewListColor,3),
																element(IndexCol,NewListColor,Col), Col #= Col2.

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

printNode(ListNodes,List,Index,Term):-nth1(Index,ListNodes,Node),TermToFind=..[Term,Node,Y],findall(Y,TermToFind,L1),remove_dups(L1,L),foreach(member(SecondNode,L),(printRelation(ListNodes,List,Node,SecondNode,Index);true)).

%Print colored Graph

printGraph(ListNodes,List,Term):-length(ListNodes,Size),foreach(between(1,Size,Index),printNode(ListNodes,List,Index,Term)).

%Create List with only Variables not initialized

createEmptyList(Size,List):-length(List,Size).

%List All Nodes

listAllNodes(ListNodes):-findall(X,edge(X,_),L1),findall(X,edge(_,X),L2),append(L1,L2,L),removeDups(L,ListNodes).

%Create List with only Variables not initialized with the same size as the list of all nodes

createEmptyListNodeSized(ListNodes,List):-length(ListNodes,Size),createEmptyList(Size,List).

%Makes the restriction that 2 Adjacent Nodes can't have the same colour.

restrictTwoNodes(ListNodes,List,Node,SecondNode):- getColorOfNodes(ListNodes,List,Node,SecondNode,Col1,Col2),Col1 #\= Col2.
																			
%Restrict Color of a Node

restrictColorsOfNode(ListNodes,List,Node,Term):-TermToFind1=..[Term,Node,Y],findall(Y,TermToFind1,L1),TermToFind2=..[Term,Y,Node],
												findall(Y,TermToFind2,L2),append(L1,L2,L),
												foreach(member(SecondNode,L),restrictTwoNodes(ListNodes,List,Node,SecondNode)).

%Restrict the graph for having different values for adjacent nodes

restrictColorsOfGraph(ListNodes,List,Term):-foreach(member(Node,ListNodes),restrictColorsOfNode(ListNodes,List,Node,Term)).

%%%% RANDOM GRAPH  %%%%


createRandomNodes(ListNodes,N):-numlist(1,N,ListNodes).

createRandomEdges([]).

createRandomEdges([Node1|Rest]):-maybe(0.6),length(Rest,N),random(0,N,Index),nth0(Index,Rest,Node2),assertz(redge(Node1,Node2)),createRandomEdges([Node1|Rest]),!.

createRandomEdges([_|Rest]):-createRandomEdges(Rest).

deleteRandomEdges:-retractall(redge(_,_)).

checkPlanarGraph(ListNodes,Term):-length(ListNodes,V),TermToFind=..[Term,X,Y],findall(X-Y,TermToFind,L),length(L,E), RealV is (3*V) - 6, E =< RealV.

%%%%%%


menu:- nl, write('WELCOME TO MAGELLAN'),nl,
assertz(listWheels([])),
assertz(listColorsNumber([])),
nl,
write('1 - Original Puzzle '),nl,
write('2 - Random Graph '),nl,
write('3 - Credits '),nl,
write('4 - Exit '),nl,
read(Answer), menuAnswer(Answer).

menuAnswer(1):-chooseTypeOfLabeling(Type),chooseTimeOut(TimeOut),originalGame(Type,TimeOut),!,menu.
menuAnswer(2):-randomGraphingMenu,!,menu.
menuAnswer(3):-credits,!,menu.
menuAnswer(4):-!.
menuAnswer(_):-write('Wrong Input'),nl,nl,!,menu.

randomGraphing(ListNodes,Type,TimeOut):-statistics('runtime',_),createEmptyListNodeSized(ListNodes,List),domain(List,0,5),nvalue(N,List),
				restrictColorsOfGraph(ListNodes,List,redge),labeling([time_out(TimeOut, Lr),minimize(N)|Type],List),
				printGraph(ListNodes,List,redge),nl,
				nl,statistics('runtime',[SinceBeginning,Value]),
				printTimeOut(Lr),
				print('Puzzle Completed with '),print(N), print(' different colours! RunTime = '),print(Value),print('ms!\n'),
				print('Full RunTime = '),timeB(Time),TimeDeff is  SinceBeginning - Time, print(TimeDeff),nl,retractall(timeB(_)),
				nl,
				fd_statistics,nl,
				deleteRandomEdges.
				
credits:-nl, write('Puzzle implementation made by Joao Baiao and Pedro Castro'),nl, nl.

randomGraphingMenu:-print('How many Nodes Should the Graph have? (More than 3)'), read(N), 
					statistics('runtime',[T,_]),assertz(timeB(T)),randomGraphingManager(N).

randomCreation(N):-createRandomNodes(ListNodes,N),createRandomEdges(ListNodes),checkPlanarGraph(ListNodes,redge),chooseTypeOfLabeling(Type),chooseTimeOut(TimeOut),randomGraphing(ListNodes,Type,TimeOut).

randomCreation(N):-print('Random Graph Generated is Not a Planar Graph! Generating Again!\n'),deleteRandomEdges,!, randomCreation(N).

randomGraphingManager(N):-N > 3,randomCreation(N).

randomGraphingManager(_):-print('Number of Nodes invalid!\n'),!,menu.

originalMenu:-write('Its Not Possible To Fill the Puzzle with that amount of Different Colours'),nl.

deleteIndex([_|L],0,L).

deleteIndex([H|Rest],Index,[H|NewList]):- NewIndex is Index - 1, deleteIndex(Rest,NewIndex,NewList).

sel(Vars,Selected,Rest):-random_select(Selected,Vars,Rest),var(Selected).

%sel(Vars,Selected,Rest):-length(Vars,N1),N is N1 - 1,random(0,N,RandomIndex),nth0(RandomIndex,Vars,Selected),var(Selected),deleteIndex(Vars,RandomIndex,Rest).


chooseTimeOut(TimeOut):-nl,write('How Much Time Should the TimeOut be ?'),nl,
						read(TimeOut), number(TimeOut), TimeOut > 0.
chooseTimeOut(TimeOut):-nl,print('Wrong Input/ Insufficient TimeOut'),nl,nl,!,chooseTimeOut(TimeOut).

minimizeColors(Type,List,Optimization,N):-nl,write('Should the number of colors used optimized (this means using the least number of colors possible) ?'),nl,
							read(Answer),minimizeColorsAnswer(Type,Answer,List,Optimization,N).
							
minimizeColorsAnswer(Type,'y',List,[minimize(N)|Type],N):-nvalue(N,List).
minimizeColorsAnswer(Type,'Y',List,[minimize(N)|Type],N):-nvalue(N,List).	
minimizeColorsAnswer(Type,'n',List,Type,N):-nvalue(N,List).	
minimizeColorsAnswer(Type,'N',List,Type,N):-nvalue(N,List).	
minimizeColorsAnswer(Type,_,List,Optimization,N):-write('Wrong Input'),nl,nl,!,minimizeColors(Type,List,Optimization,N).


chooseTypeOfLabeling(Type):-	nl,write('What Type of Labeling do you want?'),nl,
						write('1 - Default Labeling '),nl,
						write('2 - Random Labeling '),nl,
						write('3 - FFC '),nl,
						read(Answer), typeOfLabelingAnswer(Answer,Type).
						
typeOfLabelingAnswer(1,[]).
typeOfLabelingAnswer(2,[variable(sel)]).
typeOfLabelingAnswer(3,[ffc]).
typeOfLabelingAnswer(_,Type):-write('Wrong Input'),nl,nl,!,chooseTypeOfLabeling(Type).

printTimeOut('time_out'):-print('A timeout has occurred!!! Displaying best solution found until then!'),nl.
printTimeOut('success'):-print('No timeout ocurred :D'),nl.
		
originalGame(Type,TimeOut):-listAllNodes(ListNodes),createEmptyListNodeSized(ListNodes,List),domain(List,0,5),minimizeColors(Type,List,Optimization,N),
				restrictColorsOfGraph(ListNodes,List,edge),restrictDoubleWheels(ListNodes,List),labeling([time_out(TimeOut, Lr)|Optimization],List),
				printGraph(ListNodes,List,edge),nl,
				print('Puzzle Completed with '),print(N), print(' different colours!\n'),nl,
				printTimeOut(Lr),
				fd_statistics,nl.
