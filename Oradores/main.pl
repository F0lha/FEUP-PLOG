:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(between)).
:- use_module(library(clpfd)).

:initialization(menu).

menu:- nl, write('Welcome To Speakrs'),nl
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

credits:-nl, write('Puzzle implementation made by Carolina Moreira'),nl, nl.