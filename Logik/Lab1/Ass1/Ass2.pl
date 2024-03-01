select(X,[X|T],T).
select(X,[Y|T],[Y|R]) :- select(X,T,R).
member(X,L) :- select(X,L,_).

remove_duplicates(List, Result) :-
    remove_duplicates(List, [], Result).

remove_duplicates([], Acc, Result) :-
    append(Acc, [], Result).

remove_duplicates([H|T], Acc, Result) :-
    member(H, Acc),
    remove_duplicates(T, Acc, Result).

remove_duplicates([H|T], Acc, Result) :-
    \+ member(H, Acc),
    append(Acc, [H], NewAcc),
    remove_duplicates(T, NewAcc, Result).
