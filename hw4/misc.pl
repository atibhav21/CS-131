Save in case 

convert([], []).
convert(['.',-|L], R):- convert(L, R1), append([a],R1, R).
convert([-,'.','.','.'|L], R):- convert(L, R1), append([b],R1, R).
convert([-,'.',-,'.'|L|L], R, R):- 
convert([-,'.','.'|L|L], R, R):- 
convert(['.'|L|L], R, R):- 
convert(['.','.',-,'.','.'|L], R):-
convert(['.','.',-,'.'|L], R):-
convert([-,-,'.'|L], R):-
convert(['.','.','.','.'|L], R):-
convert(['.','.'|L], R):-
convert(['.',-,-,-|L], R):-
convert([-,'.',-|L], R):-
convert(['.',-,'.','.'|L], R):-
convert([-,-|L], R):-
convert([-,'.'|L], R):-
convert([-,-,-|L], R):-
convert(['.',-,-,'.'|L], R):-
convert([-,-,'.',-|L], R):-
convert(['.',-,'.'|L], R):-
convert(['.','.','.'|L], R):-
convert([-|L], R):-
convert(['.','.',-|L], R):-
convert(['.','.','.',-|L], R):-
convert(['.',-,-|L], R):-
convert([-,'.','.',-|L], R):-
convert([-,'.',-,-|L], R):-
convert([-,-,'.','.'|L], R):-
convert([-,-,-,-,-|L], R):-
convert(['.',-,-,-,-|L], R):-
convert(['.','.',-,-,-|L], R):-
convert(['.','.','.',-,-|L], R):-
convert(['.','.','.','.',-|L], R):-
convert(['.','.','.','.','.'|L], R):-
convert([-,'.','.','.','.'|L], R):-
convert([-,-,'.','.','.'|L], R):-
convert([-,-,-,'.','.'|L], R):-
convert([-,-,-,-,'.'|L], R):-
convert(['.',-,'.',-,'.',-|L], R):-
convert([-,-,'.','.',-,-|L], R):-
convert([-,-,-,'.','.','.'|L], R):-
convert(['.','.',-,-,'.','.'|L], R):-
convert(['.',-,-,-,-,'.'|L], R):-
convert([-,'.','.','.','.',-|L], R):-
convert([-,'.','.',-,'.'|L], R):-
convert([-,'.',-,-,'.'|L], R):-
convert([-,'.',-,-,'.',-|L], R):-
convert(['.',-,'.','.',-,'.'|L], R):-
convert([-,'.','.','.',-|L], R):-
convert(['.',-,'.',-,'.'|L], R):-
convert(['.',-,-,'.',-,'.'|L], R):-




/* Signal_message facts */

signal_message([], []).

signal_message([1,1,1,0,1,1,1,0,1|L], R):- signal_message(L,R1), append([g], R1, R).
signal_message([1,1,1,0,1,1,1,0,1,1,1|L], R) :- signal_message(L, R1), append([o], R1, R).
signal_message([1,1,1,0,1,1,1,0,1,0,1|L], R):- signal_message(L,R1), append([z], R1, R).
signal_message([1,1,1,0,1,1,1,0,1,0,1,1,1|L], R):- signal_message(L,R1), append(['q'], R1, R).
signal_message([1,1,1,0,1,1,1|L],R) :- signal_message(L,R1), append([m], R1, R).
signal_message([1,1,1,0,1,0,1,0,1,1,1|L], R):- signal_message(L,R1), append([x], R1, R).
signal_message([1,1,1,0,1,0,1,1,1,0,1|L], R) :- signal_message(L,R1), append([c], R1, R).
signal_message([1,1,1,0,1,0,1,0,1|L],R) :- signal_message(L,R1), append([b], R1, R).
signal_message([1,1,1,0,1,0,1,1,1|L], R) :- signal_message(L,R1), append([k], R1, R).
signal_message([1,1,1,0,1,0,1|L], R) :- signal_message(L,R1), append([d], R1, R).
signal_message([1,1,1,0,1|L],R) :- signal_message(L,R1), append([n], R1, R).

signal_message([1,1,1,0,1,0,1,1,1,0,1,1,1|L], R):- signal_message(L,R1), append([y], R1, R).
signal_message([1,1,1|L], R):- signal_message(L,R1), append([t], R1, R).

signal_message([1,0,1,1,1|L], R) :- signal_message(L,R1), append([a],R1, R).

signal_message([1|L],R) :- signal_message(L,R1), append([e], R1, R).
signal_message([1,0,1,0,1,1,1,0,1,0,1|L],R) :- signal_message(L,R1), append(['e'''], R1, R).
signal_message([1,0,1,0,1,1,1,0,1|L],R):- signal_message(L,R1), append([f], R1, R).

signal_message([1,0,1,0,1,0,1|L], R) :- signal_message(L,R1), append([h], R1, R).
signal_message([1,0,1|L], R) :- signal_message(L,R1), append([i], R1,R).
signal_message([1,0,1,1,1,0,1,1,1,0,1,1,1|L],R) :- signal_message(L,R1), append([j], R1, R).

signal_message([1,0,1,1,1,0,1,0,1|L], R) :- signal_message(L,R1), append([l], R1, R).

signal_message([1,0,1,1,1,0,1,1,1,0,1|L], R) :- signal_message(L, R1), append([p], R1, R).

signal_message([1,0,1,1,1,0,1|L], R):- signal_message(L,R1), append([r], R1, R).
signal_message([1,0,1,0,1|L], R):- signal_message(L,R1), append(['s'], R1, R).

signal_message([1,0,1,0,1,1,1|L],R):- signal_message(L,R1), append([u], R1, R).
signal_message([1,0,1,0,1,0,1,1,1|L], R):- signal_message(L,R1), append([v], R1, R).
signal_message([1,0,1,1,1,0,1,1,1|L], R):- signal_message(L,R1), append([w], R1, R).