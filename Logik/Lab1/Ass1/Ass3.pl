palengthE([],0).
lengthE([_|T],N) :- lengthE(T,N1), N is N1+1.

appendE([],L,L).
appendE([H|T],L,[H|R]) :- appendE(T,L,R).


% appendS_2: it takes the head of the list for example 1 in [1,2,3,4] and tries to finde a start
% so that when appending start with End it will make a part list and then tries to find an anonymos 
% sublist so that appending part to that it will make the whole list, when such and Start is found it
% then appends to element End and returns as Result. 

% for example when End is 3, the possible Start are, [], [1], [1,2], [4], [2], [1,2,4]  which then after 
% appending 
% gives us the following results: [3], [1,3](It violates the ordning!!) , [1,2,3], [4,3], [2,3], 
% [1,2,3,4]

separate_array(Array, R) :- appendE(_, Sub, Array), appendE(Start, [End|_], Sub), appendE(Start, 
[End], R).

partstring(List, L, F) :- separate_array(List, F), lengthE(F, L).

