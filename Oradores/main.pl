:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(clpfd)).

:-[oradores].

removeDuplicates([], []).

removeDuplicates([First | Rest], NewRest) :- member(First, Rest), removeDuplicates(Rest, NewRest),!.

removeDuplicates([First | Rest], [First | NewRest]) :- removeDuplicates(Rest, NewRest).

getAllCountries(ListOfCountries):-findall(Country,speaker(_,Country,_,_),List),removeDuplicates(List,ListOfCountries).

getAllSpeakers(ListOfSpeakers):-findall([Name,Country,Price,Gender,Topic], speaker(Name,Country,Price,Gender,Topic),List),addIDToEachSpeaker(List,ListOfSpeakers,0).

addIDToEachSpeaker([],[],_).
addIDToEachSpeaker([Speaker|Rest],[NewSpeaker|ListOfSpeakers],N):-append(Speaker,[N],NewSpeaker), N1 is N + 1,addIDToEachSpeaker(Rest,ListOfSpeakers, N1).

createListOfLists([],_).
createListOfLists([Head|ListOfLectures],Size):- length(Head,Size),createListOfLists(ListOfLectures,Size).

getIDFromList(ListOfSpeakers,ListOfID):-findall(ID,(member(Speaker,ListOfSpeakers),nth0(5,Speaker,ID)),ListOfID).


getListOfMoneyAndID([],[]).
getListOfMoneyAndID([Speaker|ListOfSpeakers],ListOfMoney):-getListOfMoneyAndID(ListOfSpeakers,OtherList), nth0(5,Speaker,ID),nth0(2,Speaker,Money),
															append([ID],[Money],IDMoney),append([IDMoney],OtherList,ListOfMoney).
getListOfIDGender([],[]).
getListOfIDGender([Speaker|ListOfSpeakers],ListOfIDGender):-getListOfIDGender(ListOfSpeakers,OtherList),nth0(5,Speaker,ID),nth0(3,Speaker,Gender),
																append([ID],[Gender],IDGender),append([IDGender],OtherList,ListOfIDGender).

getListOfIDCountry([],[]).
getListOfIDCountry([Speaker|ListOfSpeakers],ListOfIDCounty):-getListOfIDCountry(ListOfSpeakers,OtherList),nth0(5,Speaker,ID),nth0(1,Speaker,Country),
																append([ID],[Country],IDCountry),append([IDCountry],OtherList,ListOfIDCounty).

getListIDTopic([],[]).
getListIDTopic([Speaker|ListOfSpeakers],ListOfIDTopic):-getListIDTopic(ListOfSpeakers,OtherList),nth0(5,Speaker,ID),nth0(1,Speaker,Topic),
																append([ID],[Topic],IDTopic),append([IDTopic],OtherList,ListOfIDTopic).

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
											sameRestricList(ListOfLectures,IDList),sum(MoneyList, #=<, Budget).

differenceGender(ListOfLectures,ListOfSpeakers,Difference):-getListOfIDGender(ListOfSpeakers,ListOfIDGender),tupleWithList(ListOfLectures,ListOfIDGender,Tuple),divide(Tuple,IDList,GenderList),
																sameRestricList(ListOfLectures,IDList),count(0,GenderList,#=,MenN),count(1,GenderList,#=,WomenN), 
																Diff #= MenN - WomenN, Difference #= abs(Diff).

differentCountries(ListOfLectures,ListOfSpeakers):-getListOfIDCountry(ListOfSpeakers,ListOfIDCounty),tupleWithList(ListOfLectures,ListOfIDCounty,Tuple),divide(Tuple,IDList,CountryList),
													sameRestricList(IDList,ListOfLectures), all_distinct(CountryList).

getTopicsOfDay([],_,_,[]).
getTopicsOfDay([Head|Rest],IDList,TopicList,[Head2|Rest2]):-element(Index1,IDList,Head),element(Index2,TopicList,Topic),Head2 #= Topic, Index1 #= Index2, getTopicsOfDay(Rest,IDList,TopicList,Rest2).

restrictTopics([],_,_).
restrictTopics([Head|Rest],IDList,TopicsList):-getTopicsOfDay(Head,IDList,TopicsList,Topics), all_distinct(Topics), restrictTopics(Rest,IDList,TopicsList).

differentTopics(ListOfLecturesByDay,ListOfLectures,ListOfSpeakers):-getListIDTopic(ListOfSpeakers,ListOfIDTopics),tupleWithList(ListOfLectures,ListOfIDTopics,Tuple),divide(Tuple,IDList,TopicsList),
																	sameRestricList(ListOfLectures,IDList),restrictTopics(ListOfLecturesByDay,IDList,TopicsList).

%%startRestrictions
%final list is ListOfLectures
startRestrictions(ListOfLectures,ListOfLecturesByDay,Budget,ListOfSpeakers,Difference):-length(ListOfSpeakers,Length), domain(ListOfLectures,0,Length),
															all_distinct(ListOfLectures),write('Done Lectures'),nl,
															sumCosts(ListOfLectures,Budget,ListOfSpeakers),write('Done Sum'),nl,
															differenceGender(ListOfLectures,ListOfSpeakers,Difference),write('Done gender'),nl,
															differentCountries(ListOfLectures,ListOfSpeakers),write('Done Country'),
															differentTopics(ListOfLecturesByDay,ListOfLectures,ListOfSpeakers),write(ListOfLectures),nl,write('Done Topics').
listOnList([],_).
listOnList([Head|Rest],Size):-length(Head,Size),listOnList(Rest,Size).

mainPred:-	daysOfConference(Days),lecturePerDay(Lectures), moneyAvailable(Money),length(ListOfLecturesByDay,Days),listOnList(ListOfLecturesByDay,Lectures),
			append(ListOfLecturesByDay,ListOfLectures), nl,nl,write(ListOfLecturesByDay),write('/'),write(ListOfLectures),nl,nl,
			getAllSpeakers(ListOfSpeakers), startRestrictions(ListOfLectures,ListOfLecturesByDay,Money,ListOfSpeakers,Difference),
			nl,
			labeling([minimize(Difference),ffc],ListOfLectures),	
			nl,
			writeLectures(ListOfLectures,ListOfSpeakers).
mainPred:-write('nop').

%writeing

writeLectures([],_).
writeLectures([Lecture|ListOfLectures],ListOfSpeakers):-nth0(Lecture,ListOfSpeakers,Speaker), writeLecture(Speaker),nl,writeLectures(ListOfLectures,ListOfSpeakers).

writeLecture([Name|Speaker]):-write(Name),writeLecture2(Speaker).
writeLecture2([Country|Speaker]):-country(Country,NameOfCountry),write(' of '),write(NameOfCountry),writeLecture3(Speaker).
writeLecture3([Cost|Speaker]):-write(' costs '),write(Cost),writeLecture4(Speaker).
writeLecture4([Gender|[Topic|_]]):-topic(Topic,NameOfTopic),write(', talks about '),write(NameOfTopic),writeLecture5([Gender]).
writeLecture5([0|_]):-write(' and is Male.').
writeLecture5([1|_]):-write(' and is Female.').

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