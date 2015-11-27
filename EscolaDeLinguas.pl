:- use_module(library(lists)).
:-use_module(library(random)).
:-use_module(library(between)).
:- use_module(library(clpfd)).
:- use_module(library(aggregate)).

:-[data].

getProfessors(ProfList):-findall(X,prof(X),ProfList).

getCourses(CourseList):-courses(CourseList).

createListOfHours(ListHours):-timeOpenByDay(HoursByDay),Size is HoursByDay*7,print('Size = '), print(Size),nl,length(ListHours,Size).

createListOfHours(ListCourses):-timeOpenByDay(HoursByDay),Size is HoursByDay*7,length(ListHours,Size).

restrictProfHours(ListHours,ProfList):-length(ProfList,NProfs),weeklyHours(WeeklyHours),print(NProfs),nl,print(WeeklyHours),nl,foreach(between(1,NProfs,Index),count(Index,ListHours,#=<,WeeklyHours)).



giveDomain(ListHours,ProfList,ListCourses):-length(ProfList,NProfs),getCourses(CourseList),length(CourseList,NCourses),domain(ListHours,0,NProfs),domain(CourseList,0,NCourses).

testing:-getProfessors(ProfList),createListOfHours(ListHours),createListOfHours(ListCourses),giveDomain(ListHours,ProfList,ListCourses),restrictProfHours(ListHours,ProfList),labeling([],ListHours),print('oi'),print(ListHours).