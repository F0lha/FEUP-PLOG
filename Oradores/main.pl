:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(clpfd)).



menu:- nl, write('Welcome To Speakers'),nl,
nl,
write('1 - Organize Speakers '),nl,
write('2 - Credits '),nl,
write('3 - Exit '),nl,
read(Answer), menuAnswer(Answer).

menuAnswer(1):-mainPred,nl,nl,!,menu.
menuAnswer(2):-credits,!,menu.
menuAnswer(1):-!.
menuAnswer(_):-write('Wrong Input'),nl,nl,!,menu.

credits:-nl, write('Puzzle implementation made by Carolina Moreira'),nl, nl.


mainPred:-daysOfConference(Days),lecturePerDay(Lectures), SizeOfList is Days*Lectures, write(SizeOfList), length(ListOfLectures,SizeOfList).

daysOfConference(Days):-	nl,write('How many days of Conference?'),nl,
						read(Answer), daysOfConferenceAnswer(Answer,Days).
						
daysOfConferenceAnswer(Answer,Answer):-number(Answer), Answer > 0, Answer <7.
daysOfConferenceAnswer(_,Days):-write('Wrong Input'),nl,nl,!,daysOfConference(Days).


lecturePerDay(Lectures):-	nl,write('How many lectures of Conference?'),nl,
						read(Answer), daysOfConferenceAnswer(Answer,Lectures).
						
lecturePerDay(Answer,Answer):-number(Answer), Answer > 0, Answer <7.
lecturePerDay(_,Lectures):-write('Wrong Input'),nl,nl,!,lecturePerDay(Lectures).