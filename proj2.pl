% University of Melbourne, Semester 2 2017
% COMP30020: Declarative Programming
% Project 2: The Math Puzzles
% File     : proj2.pl
% Author   : Duy Vu - vuh2@student.unimelb.edu.au 
% Purpose  : Return the only Puzzle solution for each test run by proj2_test.

:- ensure_loaded(library(clpfd)).
:- ensure_loaded(library(clpb)).

% ==================================== %
% Main Puzzle solver: 
% - Tranpose Puzzle to apply same method for Rows/ Columns
% - Validate Puzzle with Domain [1..9] and distinct row values 
% - Diagonal Propagation and Labelling
% - Labelling Ground/ NonGround Rows (Columns)
% ==================================== %
puzzle_solution(Puzzle) :-
	transpose(Puzzle, TransposePuzzle),
	
	valid(Puzzle),
	valid(TransposePuzzle),

	propagate_diagonal(Puzzle),
	label_diagonal(Puzzle),
	
	label_ground_rows(Puzzle),
	label_ground_rows(TransposePuzzle),
	
	label_non_ground_rows(Puzzle),
	label_non_ground_rows(TransposePuzzle).


% ==================================== %
% Validate Puzzle with Domain [1..9] and distinct row values
% ==================================== %
valid(Puzzle) :-
	Puzzle = [ _ | Rows],
	maplist(validate, Rows).

validate(Row) :-
	Row = [ _ | Rest],
	Rest ins 1..9,
	all_distinct(Rest).


% ==================================== %
% Diagonal Propagation and Labelling: 
% All items on the diagonal are the same.
% ==================================== %

/*
* Constraint all items on diagonal to be the same by getting them 
* in each Row with increasing Index.
*/
propagate_diagonal(Puzzle) :-
	Puzzle = [ _ | Rows],
	Rows = [First | Rest ],
	First = [ _, Diagonal | _ ],
	propagate_diagonal(Rest, Diagonal, 2).

propagate_diagonal([],_,_).
propagate_diagonal([Row | Rows], Diagonal, Index) :-
	nth0(Index, Row, Elem, _),
	Elem #= Diagonal,
	Index1 is Index + 1,
	propagate_diagonal(Rows, Diagonal, Index1).

/*
* Labelling to all diagonal items by Labelling through the 
* first diagonal item
*/
label_diagonal(Puzzle) :-
	Puzzle = [ _ | Rows],
	Rows = [First | _ ],
	First = [ _, Diagonal | _ ],
	label([Diagonal]).


% ==================================== %
% Labelling Rows (Columns)
% Prioritise Rows (Columns) with more ground items
% ==================================== %

/*
* General label through all Rows without chosen
*/
label_rows(Puzzle) :-
	Puzzle = [ _ | Rows],
	maplist(sum_or_prod, Rows).

/*
* Labeling to only Rows that have Ground item
*/
label_ground_rows(Puzzle) :-
	Puzzle = [ _ | Rows],
	include(has_ground, Rows, GroundRows),
	maplist(sum_or_prod, GroundRows).

/*
* Labeling to only Rows that dont hvae Ground item
*/
label_non_ground_rows(Puzzle) :-
	Puzzle = [ _ | Rows],
	exclude(has_ground, Rows, NonGroundRows),
	maplist(sum_or_prod, NonGroundRows).

/*
* Holds true if a Row have at least one Ground item
*/
has_ground(Row) :-
	Row = [ _ | Rest],
	include(ground, Rest, GroundList),
	length(GroundList, Len),
	Len #> 0.


% ==================================== %
% Validate Header of Rows (Columns) is either
% Sum or Product of Row items.
% ==================================== %

/*
* Holds true when the Header of the Row is 
* either sum or product of row items 
*/
sum_or_prod(Row) :-
	Row = [ Head | Rest],
	label(Rest),
	sum_or_prod(Rest, Head).

sum_or_prod(Rest, Head) :-
	sumlist(Rest, Hsum),
	productlist(Rest, Hprod),
	(Hsum #= Head)  #\/ (Hprod #= Head).

/*
* True if Sum is sum of all elements in List
*/
sumlist(List, Sum) :-
	sumlist(List, 0, Sum).

sumlist([], Sum, Sum).
sumlist([N|Ns], Sum0, Sum) :-
	Sum1 is Sum0 + N,
	sumlist(Ns, Sum1, Sum).

/*
* True if Prod is product of all elements in List
*/
productlist(List, Prod) :-
	productlist(List, 1, Prod).

productlist([], Prod, Prod).
productlist([N|Ns], Prod0, Prod) :-
	Prod1 is Prod0 * N,
	productlist(Ns, Prod1, Prod).


	
