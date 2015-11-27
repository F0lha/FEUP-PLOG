:- use_module(library(lists)).
:-use_module(library(random)).
:-use_module(library(between)).
:- use_module(library(clpfd)).
:- use_module(library(aggregate)).

:-[puzzle].

exactly(_,[],0).
exactly(X,[Y|L],N) :-
X #= Y #<=> B,
N #= M+B,
exactly(X,L,M).

createWheelList(WheelList):-line(Line),length(Line,Size),length(WheelList,Size).

createMovingWheelsList([],0).

createMovingWheelsList(MovingWheelsList,N):-createWheelList(WheelList),domain(WheelList,1,10),N1 is N - 1,
											createMovingWheelsList(NewMovingWheelsList,N1),append([WheelList],NewMovingWheelsList,MovingWheelsList).
											
getExistingLines(ExistingLines):-findall(X,line(X),ExistingLines).

countValueInList(List,Value,NumberOfReps):-findall(Value,member(Value,List),L),length(L,NumberOfReps).

listValid(ExistingLines,MovingWheelsList,Index):-nth1(Index,ExistingLines,ExistingLine),nth1(Index,MovingWheelsList,MovingWheel),
													createCardinality(ExistingLine,CardinalityList,1),global_cardinality(MovingWheel,CardinalityList).
													
createCardinality(_,[],10).													
													
createCardinality(ExistingLine,CardinalityList,N):-N1 is N + 1,countValueInList(ExistingLine,N,NumberOfReps),createCardinality(ExistingLine,NewCardinalityList,N1),
													append([N-NumberOfReps],NewCardinalityList,CardinalityList).

restrictValidLists(ExistingLines,MovingWheelsList):-length(ExistingLines,Size),foreach(between(1,Size,Index),listValid(ExistingLines,MovingWheelsList,Index)).

labelAllWheelLists(_,[]).

labelAllWheelLists(Type,[H|Rest]):-labeling(Type,H),labelAllWheelLists(Type,Rest).

restrictEqualLine(Line,FirstLine,Same,Same):-nth0(Same,Line,LineElem),nth0(Same,FirstLine,FirstLineElem),FirstLineElem #= LineElem.

restrictEqualLine(Line,FirstLine,Index,Size):-nth0(Index,Line,LineElem),nth0(Index,FirstLine,FirstLineElem),FirstLineElem #= LineElem,NextIndex is Index + 1, restrictEqualLine(Line,FirstLine,NextIndex,Size).

getFirstLine(FirstLine):-firstLine(Line),length(Line,Size),length(FirstLine,Size),S is Size -2,restrictEqualLine(Line,FirstLine,0,S).

createListByIndex([],_,[]).

createListByIndex([H|Rest],Index,List):-nth1(Index,H,Elem),createListByIndex(Rest,Index,NewList),append([Elem],NewList,List).

restrictSumVerticalLine(FirstLine,MovingWheelsList,Index):-nth1(Index,FirstLine,First),createListByIndex(MovingWheelsList,Index,NewList),append([First],NewList,RealList),
															sum(RealList,#=,21).
															
restrictSumVerticalLine(MovingWheelsList,Index):-createListByIndex(MovingWheelsList,Index,RealList),
															sum(RealList,#=,15).													

restrictSum(FirstLine,MovingWheelsList):-length(FirstLine,Size),foreach(between(1,Size,Index),restrictSumVerticalLine(FirstLine,MovingWheelsList,Index)).

restrictSum(MovingWheelsList):-Size is 9,foreach(between(1,Size,Index),restrictSumVerticalLine(MovingWheelsList,Index)).

printWheels([]).

printWheels([H|Rest]):-print(H),nl,printWheels(Rest).

printFirstLine(FirstLine):-print(FirstLine),nl.

testing:-getExistingLines(ExistingLines),length(ExistingLines,Size),createMovingWheelsList(MovingWheelsList,Size),restrictValidLists(ExistingLines,MovingWheelsList),getFirstLine(FirstLine),restrictSum(FirstLine,MovingWheelsList),labelAllWheelLists([],MovingWheelsList),printFirstLine(FirstLine),printWheels(MovingWheelsList),print('Soma na vertical da sempre 20').