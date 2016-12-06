
/* Compress_0s assumes that the list will have only 0s and 1s
 * Removes all the 0s at the beginning of the list
 */
compress_0s([], []).
compress_0s([1|L], [1|L]).
compress_0s([0|L], X):- compress_0s(L,X).

/*
 * Removes all the 1s at the beginning of the list
 */
compress_1s([], []).
compress_1s([0|L], [0|L]).
compress_1s([1|L], X) :- compress_1s(L, X).

/*
 * Finds the longest sequence of 0s and 1s in the current list
 */
return_longest([], [], []).
return_longest([], X, X).
return_longest([0|L], [0|M], Y):- return_longest(L, [0,0|M], Y).
return_longest([1|L], [1|M], Y):- return_longest(L, [1,1|M], Y).
return_longest([1|_], [0|M], [0|M]).
return_longest([0|_], [1|M], [1|M]).

/* Empty list passed in, so return the empty list*/
signal_morse([], []).

/* Compress this to 6 0s and then call signal_morse*/
/* We remove all the 0s that follow the first 6 0s and then return whatever we get */
signal_morse([0,0,0,0,0,0|L], R):- compress_0s(L,L1), signal_morse(L1,R1), append(['#'],R1,R).

/*
 Ambiguity with 5 0s. We only call this if we don't have any 0s following the 5 0s
 */
signal_morse([0,0,0,0,0|L], R):- return_longest(L, [0], [0]), signal_morse(L,R1),  append([^], R1, R).
signal_morse([0,0,0,0,0|L], R):- return_longest(L, [0], [0]), signal_morse(L, R1), append(['#'], R1, R).

/* Ambiguity with 4 0s, calls signal_morse if this is the longest sequence*/
signal_morse([0,0,0,0|L], R):- return_longest(L, [0], [0]), signal_morse(L, R1), append([^], R1, R).

/* 3 0s in a row so we have end of a letter,
 so we append the result of the rest of our call to the singleton list containing ^
 */
signal_morse([0,0,0|L], R) :- return_longest(L, [0], [0]), signal_morse(L,R1), append([^], R1, R).

/* Ambiguity with 2 0s*/
signal_morse([0,0|L], R):- return_longest(L, [0], [0]), signal_morse(L,R).
signal_morse([0,0|L], R):- return_longest(L, [0], [0]), signal_morse(L,R1), append([^], R1, R).

/* End of a dih or dah so just call signal_morse with the rest of the code.*/
signal_morse([0|L], R) :- return_longest(L, [0], [0]), signal_morse(L,R).

/* Our sequence begins with 3 or more 1's so we subsitute that with the - sign */
signal_morse([1,1,1|L], R) :- compress_1s(L,L1), signal_morse(L1,R1), append([-], R1, R).

/* Ambiguity with two one's in a row, only called if the starting sequence is 1,1
   Not called if the sequence is 1,1,1
*/
signal_morse([1,1|L],R) :- return_longest(L, [1], [1]), signal_morse(L,R1), append(['.'], R1, R).
signal_morse([1,1|L],R) :- return_longest(L, [1], [1]), signal_morse(L,R1), append([-], R1, R).

/* Sequence has just a single 1 so we use the '.' */
signal_morse([1|L], R) :- return_longest(L, [1], [1]), signal_morse(L,R1), append(['.'],R1,R).

 /* Approach for removing errors
  * ## According to what Tomer posted on piazza ##
  * An error token can be a part of the word
  * For the given example: M = [m,o,r,s,e,#,as].
  */

signal_message([], []).
signal_message(X, Y):- signal_morse(X, R), convert(R, [], Y1), remove_error(Y1, [], [], Y).

/*
 * Convert
 * Paramter 1: The list of the symbols -, ., ^, #
 * Parameter 2: Symbols of the current letter
 */
convert([], [], []).
convert([], X, Y):- morse(A, X), append([A], [], Y).
/* End of a letter so convert it to morse code*/
convert([^|L], X, Y):- morse(A, X), convert(L, [], Y1), append([A], Y1, Y).
/* End of a word so add # to list and convert the rest */
convert(['#'|L], X, Y):- morse(A, X), convert(L, [], Y1), append([A,'#'], Y1, Y).
/* A - or . so add it to the translation of the current letter*/
convert([X|L], H, R):- append(H, [X], H1), convert(L, H1 , R).

/*
 * Given translation of morse
 */
morse(a, ['.',-]).           % A
morse(b, [-,'.','.','.']).	   % B
morse(c, [-,'.',-,'.']).	   % C
morse(d, [-,'.','.']).	   % D
morse(e, ['.']).		   % E
morse('e''', ['.','.',-,'.','.']). % É (accented E)
morse(f, ['.','.',-,'.']).	   % F
morse(g, [-,-,'.']).	   % G
morse(h, ['.','.','.','.']).	   % H
morse(i, ['.','.']).	   % I
morse(j, ['.',-,-,-]).	   % J
morse(k, [-,'.',-]).	   % K or invitation to transmit
morse(l, ['.',-,'.','.']).	   % L
morse(m, [-,-]).	   % M
morse(n, [-,'.']).	   % N
morse(o, [-,-,-]).	   % O
morse(p, ['.',-,-,'.']).	   % P
morse(q, [-,-,'.',-]).	   % Q
morse(r, ['.',-,'.']).	   % R
morse(s, ['.','.','.']).	   % S
morse(t, [-]).	 	   % T
morse(u, ['.','.',-]).	   % U
morse(v, ['.','.','.',-]).	   % V
morse(w, ['.',-,-]).	   % W
morse(x, [-,'.','.',-]).	   % X or multiplication sign
morse(y, [-,'.',-,-]).	   % Y
morse(z, [-,-,'.','.']).	   % Z
morse(0, [-,-,-,-,-]).	   % 0
morse(1, ['.',-,-,-,-]).	   % 1
morse(2, ['.','.',-,-,-]).	   % 2
morse(3, ['.','.','.',-,-]).	   % 3
morse(4, ['.','.','.','.',-]).	   % 4
morse(5, ['.','.','.','.','.']).	   % 5
morse(6, [-,'.','.','.','.']).	   % 6
morse(7, [-,-,'.','.','.']).	   % 7
morse(8, [-,-,-,'.','.']).	   % 8
morse(9, [-,-,-,-,'.']).	   % 9
morse('.', ['.',-,'.',-,'.',-]).   % '.' (period)
morse(',', [-,-,'.','.',-,-]). % , (comma)
morse(:, [-,-,-,'.','.','.']).   % : (colon or division sign)
morse(?, ['.','.',-,-,'.','.']).   % ? (question mark)
morse('''',['.',-,-,-,-,'.']). % ' (apostrophe)
morse(-, [-,'.','.','.','.',-]).   % - (hyphen or dash or subtraction sign)
morse(/, [-,'.','.',-,'.']).     % / (fraction bar or division sign)
morse('(', [-,'.',-,-,'.']).   % ( (left-hand bracket or parenthesis)
morse(')', [-,'.',-,-,'.',-]). % ) (right-hand bracket or parenthesis)
morse('"', ['.',-,'.','.',-,'.']). % " (inverted commas or quotation marks)
morse(=, [-,'.','.','.',-]).     % = (double hyphen)
morse(+, ['.',-,'.',-,'.']).     % + (cross or addition sign)
morse(@, ['.',-,-,'.',-,'.']).   % @ (commercial at)

% Error.
morse(error, ['.','.','.','.','.','.','.','.']). % error - see below

% Prosigns.
morse(as, ['.',-,'.','.','.']).          % AS (wait A Second)
morse(ct, [-,'.',-,'.',-]).          % CT (starting signal, Copy This)
morse(sk, ['.','.','.',-,'.',-]).        % SK (end of work, Silent Key)
morse(sn, ['.','.','.',-,'.']).          % SN (understood, Sho' 'Nuff)

/* Remove Errors */

/* First argument is for iterating over the entire list
  * Second argument is the list which is free of errors, already been processed
  * Third argument is the word that we are currently examining
  * Fourth argument is the result of removing the errors
  */
remove_error([], [], [], []).
remove_error([], L, X, Y):- append(L, X, Y).
/* Error encountered so delete the current word and process the rest */
remove_error([error|M], L, _, Y):- remove_error(M, L, [], Y),!.
/* End of a word so append the current word, # and then process the rest*/
remove_error(['#'|M], L, X, Y):- append(L, X, Y1), append(Y1, ['#'], Y2), remove_error(M, Y2, [], Y), !.
/* Letter within a word */
remove_error([A|M], L , X, Y):- append(X, [A], X1), remove_error(M, L, X1, Y).
