% University of Melbourne, Semester 2 2017
% COMP30020: Declarative Programming
% Project 2: The Math Puzzels
% File     : proj2.pl
% Author   : Duy Vu - vuh2@student.unimelb.edu.au 
% Purpose  : Return puzzle solution for each test run by proj2_test.pl

:- ensure_loaded(library(clpfd)).
:- ensure_loaded(library(clpb)).

puzzle([[0,45,72],[72,_,_],[14,_,_]]).

puzzle_solution(Puzzle) :-
	valid(Puzzle),
	transpose(Puzzle, TransposePuzzle),
	valid(TransposePuzzle).

valid(Puzzle) :-
	Puzzle = [ _ | Rows],
	match_diagonal(Rows),
	maplist(validate, Rows).

validate(Row) :-
	Row = [ Head | Rest],
	Rest ins 1..9,
	all_distinct(Rest),
	label(Rest),
	sum_or_prod(Rest, Head).

sum_or_prod(Rest, Head) :-
	sumlist(Rest, Hsum),
	productlist(Rest, Hprod),
	(Hsum #= Head) #\/ (Hprod #= Head).

match_diagonal(Rows) :-
	Rows = [First | Rest ],
	First = [ _, Diagonal | _ ],
	match_diagonal(Rest, Diagonal, 2).

match_diagonal([],_,_).
match_diagonal([Row | Rows], Diagonal, Index) :-
	nth0(Index, Row, Elem, _),
	Elem #= Diagonal,
	Index1 is Index + 1,
	match_diagonal(Rows, Diagonal, Index1).


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


	
