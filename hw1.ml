(* Homework 1 CS 131 *)

(* Typedef for filter blind alleys *)
type ('nonterminal, 'terminal) symbol =
  | N of 'nonterminal
  | T of 'terminal 

(* returns true if list l contains element e*)
let rec contains e l =
	match l with 
	[] -> false
	| h::t -> if h = e then true
			 	else (contains e t)

(* returns true if a is a subset of b *)
let rec subset a b =
	match a with
	[] -> true
	| h::t -> if (contains h b) then (subset t b)
				else false 

(* returns true if a and b have the same elements *)
let rec equal_sets a b =
	if (subset a b) && (subset b a) then true
		else false

(* returns the union of set a and b *)
let set_union a b =
	a @ b 

(* returns the intersection of set a and b i.e., a n b *)
let rec set_intersection a b =
	 match a with
	 [] -> []
	 | h::t -> if (contains h b) then h::(set_intersection t b)
	 			else (set_intersection t b)

(* returns the set a - b *)
let rec set_diff a b =
	match a with 
	[] -> []
	| h::t -> if (contains h b) then (set_diff t b)
				else h::(set_diff t b)

(* returns the fixed point of x *)
(* returns the value*)
let rec computed_fixed_point eq f t = 
	let y = f(t) in 
	if (eq y t) then t
		else (computed_fixed_point eq f y)
	
(* Not Working *)

let rec calculate_p_calls eq f p x currentVal =
	let y = f(currentVal) in
	match p with 
	0 -> if ( eq currentVal x) then true
		else false
	| _ -> (calculate_p_calls eq f (p-1) x y)

let rec calculate_pth_call f p x =
	match p with
	0 -> x
	| _ -> (calculate_pth_call f (p-1) (f x))

let rec computed_periodic_point eq f p x =
	if (p = 0) then x 
else
	match (calculate_p_calls eq f p x x) with
	true -> (calculate_pth_call f p x)
	| false -> (computed_periodic_point eq f p (f x))
		

(* returns the longest list such that p x is true, x is updated using s x *)
let rec while_away s p x =
		if (p x) then 
			x::(while_away s p (s x))
	else []

(* return list of n e elements*)
let rec get_list n e =
		if (n = 0) then []
	else e::(get_list (n-1) e)

(* Decode a single item for rle_decode and return a list with that many elements*)
let decode_item i= 
	let (x,y) = i in
	let list_item = (get_list x y) in
	list_item

let rec rle_decode lp = 
	match lp with
	[] -> []
	| h::t -> (decode_item h)@(rle_decode t)

(* FILTER BLIND ALLEY RULES CODE*)

(* Might be stuck in infinite recursion between find_possible_replacements and is_terminal *)
(*
let rec find_possible_replacements a r =
	match r with 
	[] -> true
	| h::t -> match h with 
			  (x, y) -> match x with 
			  			a -> (is_terminal y r)
			  			| _ -> (find_possible_replacements a t)
			  | _ -> false

let rec is_terminal y g =
	match y with
		[] -> true
		| h::t -> match h with
				 T k -> (is_terminal t g)
				| N l -> (find_possible_replacements l g) && (is_terminal t g)

let is_blind_alley r e =
	match e with
	(x,y) -> (is_terminal y r)
	| _ -> false (* Not a rule *)

let rec filter_rules startingSymbol r = 
	match r with 
	[] -> []
	| h::t -> if (is_blind_alley r h) then (filter_rules t)
				else h @ (filter_rules t)

let rec filter_blind_alleys g =
	match g with
	(x, y) -> x::(filter_rules x y)
	| _ -> g
*)
(* Computed Fixed Point can have replacement to Non-terminal Symbols as a function, *)



