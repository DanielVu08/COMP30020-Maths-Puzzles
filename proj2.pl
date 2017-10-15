% University of Melbourne, Semester 2 2017
% COMP30020: Declarative Programming
% Project 2: The Math Puzzels
% File     : proj2.pl
% Author   : Duy Vu - vuh2@student.unimelb.edu.au 
% Purpose  : Return puzzle solution for each test run by proj2_test.pl

:- ensure_loaded(library(clpfd)).

puzzle([[0,45,72],[72,_,_],[14,_,_]]).

puzzle_solution(Puzzle) :-
	valid(Puzzle),
	transpose(Puzzle, TransposePuzzle),
	valid(TransposePuzzle).
	

valid(Puzzle) :-
	Puzzle = [ _ , First, Second],
	First = [ Fhead | Frest],
	Second = [ Shead | Srest],
	Frest ins 1..9,
	Srest ins 1..9,
	all_distinct(Frest),
	all_distinct(Srest),
	Frest = [F1,F2],
	Srest = [S1,S2],
	F1 #= S2,
	((Fhead #= F1 * F2) #\/ (Fhead #= F1 + F2)),
	((Shead #= S1 * S2) #\/ (Shead #= S1 + S2)).


all_same(List) :-
	listof(_, List).

listof(_, []).
listof(Elt, [Elt|List]) :-
	listof(Elt, List).

sumlist(List, Sum) :-
	sumlist(List, 0, Sum).

sumlist([], Sum, Sum).
sumlist([N|Ns], Sum0, Sum) :-
	Sum1 is Sum0 + N,
	sumlist(Ns, Sum1, Sum).

	
