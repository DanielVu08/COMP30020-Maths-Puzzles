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
	Puzzle = [ _ | Rows],
	maplist(validate, Rows).

validate(Row) :-
	Row = [ Head | Rest],
	Rest ins 1..9,
	all_distinct(Rest),
	Rest = [V1,V2],
	((Head #= V1 * V2) #/\ (Head #\= V1 + V2) ) #\ ( (Head #= V1 + V2) #/\ (Head #\= V1 * V2)),
	label(Rest).





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

productlist(List, Prod) :-
	productlist(List, 1, Prod).

productlist([], Prod, Prod).
productlist([N|Ns], Prod0, Prod) :-
	Prod1 is Prod0 * N,
	productlist(Ns, Prod1, Prod).

primeNumber(2).
primeNumber(A) :-
    A > 2,
    \+ 0 is A mod 2,
    L is floor(sqrt(A) / 2),
    \+ (between(1, L, X),
        0 is A mod (1 + 2*X)).

	
