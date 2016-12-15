:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(clpfd)).

:-[oradores].

removeDuplicates([], []).

removeDuplicates([First | Rest], NewRest) :- member(First, Rest), removeDuplicates(Rest, NewRest),!.

removeDuplicates([First | Rest], [First | NewRest]) :- removeDuplicates(Rest, NewRest).

getAllCountries(ListOfCountries):-findall(Country,speaker(_,Country,_,_),List),removeDuplicates(List,ListOfCountries).

getAllSpeakers(ListOfSpeakers):-findall([Name,Country,Price,Gender], speaker(Name,Country,Price,Gender),List),addIDToEachSpeaker(List,ListOfSpeakers,0).

addIDToEachSpeaker([],[],_).
addIDToEachSpeaker([Speaker|Rest],[NewSpeaker|ListOfSpeakers],N):-append(Speaker,[N],NewSpeaker), N1 is N + 1,addIDToEachSpeaker(Rest,ListOfSpeakers, N1).

createListOfLists([],_).
createListOfLists([Head|ListOfLectures],Size):- length(Head,Size),createListOfLists(ListOfLectures,Size).

getIDFromList(ListOfSpeakers,ListOfID):-findall(ID,(member(Speaker,ListOfSpeakers),nth1(5,Speaker,ID)),ListOfID).


getListOfMoneyAndID([],[]).
getListOfMoneyAndID([Speaker|ListOfSpeakers],ListOfMoney):-getListOfMoneyAndID(ListOfSpeakers,OtherList), nth0(4,Speaker,ID),nth0(2,Speaker,Money),
															append([ID],[Money],IDMoney),append([IDMoney],OtherList,ListOfMoney).
getListOfIDGender([],[]).
getListOfIDGender([Speaker|ListOfSpeakers],ListOfIDGender):-getListOfIDGender(ListOfSpeakers,OtherList),nth0(4,Speaker,ID),nth0(3,Speaker,Gender),
																append([ID],[Gender],IDGender),append([IDGender],OtherList,ListOfIDGender).

getListOfIDCountry([],[]).
getListOfIDCountry([Speaker|ListOfSpeakers],ListOfIDCounty):-getListOfIDCountry(ListOfSpeakers,OtherList),nth0(4,Speaker,ID),nth0(1,Speaker,Country),
																append([ID],[Country],IDCountry),append([IDCountry],OtherList,ListOfIDCounty).

divide([],[],[]).
divide([[ID|[Money|[]]]|List],[ID|IDList],[Money|MoneyList]):-divide(List,IDList,MoneyList).

createListOfPairs([]).
createListOfPairs([Head|Tuple]):-length(Head,2),createListOfPairs(Tuple).

sameRestricList([],[]).
sameRestricList([Head1|List1],[Head2|List2]):-Head1 #= Head2,sameRestricList(List1,List2).

abs2(X,X) :- X #>= 0, !.
abs2(X,Y) :- Y #= -1*X.

%restrictions

tupleWithList(ListOfLectures,Template,Tuple):-length(ListOfLectures,Length),length(Tuple,Length),createListOfPairs(Tuple),
											table(Tuple,Template).

sumCosts(ListOfLectures,Budget,ListOfSpeakers):-getListOfMoneyAndID(ListOfSpeakers,IDMoney),tupleWithList(ListOfLectures,IDMoney,Tuple),divide(Tuple,IDList,MoneyList),
											sameRestricList(IDList,ListOfLectures),sum(MoneyList, #=<, Budget).

differenceGender(ListOfLectures,ListOfSpeakers,Difference):-getListOfIDGender(ListOfSpeakers,ListOfIDGender),tupleWithList(ListOfLectures,ListOfIDGender,Tuple),divide(Tuple,IDList,GenderList),
																sameRestricList(IDList,ListOfLectures),count(0,GenderList,#=,MenN),count(1,GenderList,#=,WomenN), Diff #= MenN - WomenN,
																abs2(Diff,Difference).

everyLectureHasASpeaker([],_).
everyLectureHasASpeaker([Head|ListOfLectures],ListOfID):-element(_,ListOfID,Head),everyLectureHasASpeaker(ListOfLectures,ListOfID).

differentCountries(ListOfLectures,ListOfSpeakers):-getListOfIDCountry(ListOfSpeakers,ListOfIDCounty),tupleWithList(ListOfLectures,ListOfIDCounty,Tuple),divide(Tuple,IDList,CountryList),all_distinct(IDList),
													sameRestricList(IDList,ListOfLectures), all_distinct(CountryList).

%%startRestrictions
%final list is ListOfLectures
startRestrictions(ListOfLectures,_,Budget,ListOfSpeakers,Difference):-
															all_distinct(ListOfLectures),print('Done Lectures'),nl,
															sumCosts(ListOfLectures,Budget,ListOfSpeakers),print('Done Sum'),nl,
															differenceGender(ListOfLectures,ListOfSpeakers,Difference),print('Done gender'),nl,
															differentCountries(ListOfLectures,ListOfSpeakers),print('Done Country'),nl,print(ListOfLectures).


mainPred:-	daysOfConference(Days),lecturePerDay(Lectures), SizeOfList is Days*Lectures, moneyAvailable(Money),
			length(ListOfLectures,SizeOfList), getAllSpeakers(ListOfSpeakers), startRestrictions(ListOfLectures,Days,Money,ListOfSpeakers,Difference),print(Difference),
			nl,
			labeling([minimize(Difference)],ListOfLectures),	
			nl,
			printLectures(ListOfLectures,ListOfSpeakers).
mainPred:-write('nop').

%printing

printLectures([],_).
printLectures([Lecture|ListOfLectures],ListOfSpeakers):-nth0(Lecture,ListOfSpeakers,Speaker), printLecture(Speaker),nl,printLectures(ListOfLectures,ListOfSpeakers).

printLecture([Name|Speaker]):-write(Name),printLecture2(Speaker).
printLecture2([Country|Speaker]):-country(Country,NameOfCountry),write(' of '),write(NameOfCountry),printLecture3(Speaker).
printLecture3([Cost|Speaker]):-write(' costs '),write(Cost),printLecture4(Speaker).
printLecture4([0|_]):-write(' and is Male.').
printLecture4([1|_]):-write(' and is Female.').

moneyAvailable(Money):-	nl,write('How much money Available?'),nl,
						read(Answer), moneyAvailableAnswer(Answer,Money).
						
moneyAvailableAnswer(Answer,Answer):-number(Answer), Answer > 0.
moneyAvailableAnswer(_,Money):-write('Money is not Sufficient!'),nl,nl,!,moneyAvailable(Money). 


daysOfConference(Days):-	nl,write('How many days of Conference?'),nl,
						read(Answer), daysOfConferenceAnswer(Answer,Days).
						
daysOfConferenceAnswer(Answer,Answer):-number(Answer), Answer > 0, Answer <8.
daysOfConferenceAnswer(_,Days):-write('Wrong Days Of Conference Input'),nl,nl,!,daysOfConference(Days).


lecturePerDay(Lectures):-	nl,write('How many lectures of Conference?'),nl,
						read(Answer), lecturePerDayAnswer(Answer,Lectures).
						
lecturePerDayAnswer(Answer,Answer):-number(Answer), Answer > 0, Answer <8.
lecturePerDayAnswer(_,Lectures):-write('Wrong Number of Lectures Input'),nl,nl,!,lecturePerDay(Lectures).

menu:- nl, write('Welcome To Speakers'),nl,
nl,
write('1 - Organize Speakers '),nl,
write('2 - Credits '),nl,
write('3 - Exit '),nl,
read(Answer), menuAnswer(Answer).

menuAnswer(1):-mainPred,nl,nl,!,menu.
menuAnswer(2):-credits,!,menu.
menuAnswer(3):-!.
menuAnswer(_):-write('Wrong Input'),nl,nl,!,menu.

credits:-nl, write('Puzzle implementation made by Carolina Moreira'),nl, nl.