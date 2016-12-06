signal_morse([], []).

signal_morse([0|X], Y):- signal_morse_helper(X, [0], Y).
signal_morse([1|X], Y):- signal_morse_helper(X, [1], Y).

signal_morse_helper([], [], []).
signal_morse_helper([], X, Y):- signal_matcher(X, Y).

signal_morse_helper([0|L], [0|M], Y):- signal_morse_helper(L, [0,0|M], Y).
signal_morse_helper([1|L], [1|M], Y):- signal_morse_helper(L, [1,1|M], Y).

signal_morse_helper([0|L], [1|M], Y):- signal_morse_helper(L, [0], Y1), signal_matcher([1|M], Y2), append(Y2, Y1, Y).
signal_morse_helper([1|L], [0|M], Y):- signal_morse_helper(L, [1], Y1), signal_matcher([0|M], Y2), append(Y2, Y1, Y).

signal_matcher([1,1,1|_], [-]), !.
signal_matcher([1,1], ['.']).
signal_matcher([1,1], [-]).
signal_matcher([1], ['.']).

signal_matcher([0,0,0,0,0,0|_], ['#']).
signal_matcher([0,0,0,0,0], [^]).
signal_matcher([0,0,0,0,0], ['#']).
signal_matcher([0,0,0,0], [^]).
signal_matcher([0,0,0], [^]).
signal_matcher([0,0], []).
signal_matcher([0,0], [^]).
signal_matcher([0], []).
