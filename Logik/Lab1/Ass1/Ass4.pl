e(a, b).
e(b, c).
e(b, d).
e(c, e).

select(X, [X|T], T).
select(X, [Y|T], [Y|R]) :- select(X, T, R).
member(X, L) :- select(X, L, _).

reverse_list([], []).
reverse_list([X|Xs], Reversed) :-
    reverse_list(Xs, Rest),
    append(Rest, [X], Reversed).

path(A, B, Path) :-
    path(A, B, [], Path).

path(A, A, Visited, [A|Visited]).
path(A, B, Visited, Path) :-
    e(A, X),
    \+ member(X, Visited),
    path(X, B, [A|Visited], Path).

real_path(A, B, ReversedPath) :-
    path(A, B, Path),
    reverse_list(Path, ReversedPath).

