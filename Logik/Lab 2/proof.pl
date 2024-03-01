%----------------------------------------------------------------
%	All needed axioms
%----------------------------------------------------------------

and(X, Y) :-  
	X, Y.
or(X, Y) :- 
	X; Y.
neg(X) :-   
	X, !, fail; true.
imp(X, Y) :- 
	and(X, Y); neg(X).

check_premise(Expression, Premise):- 
		member(Expression, Premise).

negation_elimination(L1, L2, Checked) :- 
		member([L1, Expression, _], Checked),
		member([L2, neg(Expression), _], Checked).

and_elimination_one(L, Expression, Checked) :- 
		member([L, and(Expression, _), _], Checked).

contradiction_elimination(L, Expression, Checked) :- 
		member([L, Expression, _], Checked).

negation_negation_elimination(L, Expression, Checked) :-
		member([L, neg(neg(Expression)), _], Checked).

and_introduction(T1, T2, L1, L2, Checked):-
		member([L1, T1, _], Checked),
		member([L2, T2, _], Checked).

derived_MT(T1, L1, L2, Checked) :- 
		member([L1, imp(T1, T2), _], Checked),
		member([L2, neg(T2), _], Checked).

or_elimination(R, [L1, L2, L3, L4, L5], Checked):-
		member([L1, or(T1, T2),_], Checked),
		member(Box1, Checked),
		member(Box2, Checked),
		member([L2, T1, assumption], Box1),
		get_last_line(Box1, Last1),
		Last1 = [L3, R, _],
		member([L4, T2, assumption], Box2),
		get_last_line(Box2, Last2),
		Last2 = [L5, R, _].

implication_introduction(T1, T2, L1, L2, Checked):- 
		member(Box, Checked), 
		member([L1, T1, assumption], Box),
		get_last_line(Box, Last),
		Last = [L2, T2, _].

and_elimination_two(L, Expression, Checked) :-  
        member([L, and(_, Expression), _], Checked).

implication_elimination(X, Y, Previous, Expression, Checked) :-
    member([X, Previous, _], Checked),
    member([Y, imp(Previous, Expression), _], Checked).

or_introduction_one(X, Expression, Checked) :-
    member([X, Expression, _], Checked).

or_introduction_two(X, Expression, Checked) :-
    member([X, Expression, _], Checked).

double_negation_introduction(X, Expression, Checked) :-
    member([X, Expression, _], Checked).

copy_rule(X, Expression, Checked) :-
    member([X, Expression, _], Checked).

law_of_excluded_middle(X, Y) :-
    Y = neg(X).

assumption_rule(X, Expression, Box, Premise, Checked) :-
    check_proof(Box, Premise, [[X, Expression, assumption]|Checked]).

negation_introduction(X, Y, Expression, Box, Checked) :-
    member(Box, Checked),
    member([X, Expression, assumption], Box),
    get_last_line(Box, Last),
    Last = [Y, cont, _].

pbc_rule(X, Y, Expression, Box, Checked) :-
    member(Box, Checked),
    member([X, neg(Expression), assumption], Box),
    get_last_line(Box, Last),
    Last = [Y, cont, _].


%----------------------------------------------------------------
%	Utilities
%----------------------------------------------------------------

get_last_line([X], X).
get_last_line([_|T], NextLine) :- 
		get_last_line(T, NextLine).

check_proof([], _, _).
check_proof([H|T], Premise, Checked) :- 
		findAxiom(H, Premise, Checked),
		check_proof(T, Premise, [H|Checked]).

read_input(InputFileName, Premise, Conclusion, Proof) :- 
		see(InputFileName), 
		read(Premise),
		read(Conclusion), 
		read(Proof).

check_conclusion(Proof, Conclusion) :- 
		get_last_line(Proof, R), member(Conclusion, R), !.

valid_proof(Premise, Conclusion, Proof) :- 
		check_conclusion(Proof, Conclusion),
		check_proof(Proof, Premise, []), !.

%----------------------------------------------------------------
%	Main program
%----------------------------------------------------------------

verify(InputFileName) :-
		read_input(InputFileName, Premise, Conclusion, Proof),
		seen,
		valid_proof(Premise, Conclusion, Proof).

%----------------------------------------------------------------
% Predicates to find the right axiom
%----------------------------------------------------------------
																							
findAxiom([_, Expression, premise], Premise, _) :- 
		check_premise(Expression, Premise).

findAxiom([_, cont, negel(L1,L2)], _, Checked) :- 
		negation_elimination(L1, L2, Checked).			
			
findAxiom([_, Expression, andel1(L)], _, Checked) :- 
		and_elimination_one(L, Expression, Checked).

findAxiom([_, _, contel(L)], _, Checked) :-        
		contradiction_elimination(L, cont, Checked).

findAxiom([_, Expression, negnegel(L)], _, Checked) :- 
		negation_negation_elimination(L,Expression, Checked).

findAxiom([_, and(T1, T2), andint(L1,L2)], _, Checked) :- 
		and_introduction(T1, T2, L1, L2, Checked).
	
findAxiom([_, neg(T), mt(L1,L2)], _, Checked) :- 
		derived_MT(T, L1, L2, Checked).

findAxiom([_, Result, orel(L1, L2, L3, L4, L5)], _, Checked):- 
		or_elimination(Result, [L1, L2, L3, L4, L5], Checked).

findAxiom([_, imp(T1, T2), impint(L1,L2)], _, Checked) :- 
		implication_introduction(T1, T2, L1, L2 , Checked).

findAxiom([_, Expression, andel2(L)], _, Checked) :- 
    and_elimination_two(L, Expression, Checked).

findAxiom([_, Expression, impel(X, Y)], _, Checked) :- 
    implication_elimination(X, Y, _, Expression, Checked).

findAxiom([_, or(Expression, _), orint1(X)], _, Checked) :- 
    or_introduction_one(X, Expression, Checked).

findAxiom([_, or(_, Expression), orint2(X)], _, Checked) :- 
    or_introduction_two(X, Expression, Checked).

findAxiom([_, neg(neg(Expression)), negnegint(X)], _, Checked) :- 
    double_negation_introduction(X, Expression, Checked).

findAxiom([_, Expression, copy(X)], _, Checked) :- 
    copy_rule(X, Expression, Checked).

findAxiom([_, or(X, Y), lem], _, _) :- 
    law_of_excluded_middle(X, Y).

findAxiom([[X, Expression, assumption]|Box], Premise, Checked) :- 
    assumption_rule(X, Expression, Box, Premise, Checked).

findAxiom([_, neg(Expression), negint(X, Y)], _, Checked) :- 
    negation_introduction(X, Y, Expression, _, Checked).

findAxiom([_, Expression, pbc(X, Y)], _, Checked) :- 
    pbc_rule(X, Y, Expression, _, Checked).
%----------------------------------------------------------------
% Predicates Reborn
%----------------------------------------------------------------




