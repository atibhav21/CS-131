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
(* Modified Algorithm -
	Loop :
		1. Go through list to find directly terminating symbols
		2. Iterate through rules to find out if any other symbol is terminating
		3. If any new terminating symbol is found, add it to list
		4. If terminal symbols list changes (perform verification of list not changing using computed_fixed_point), then go back to loop
			else we're done
		5. Go through every rule, removing the rules which contain symbols that are not in the terminating list
		6. Return rules list in the form startingSymbol, updated_rules_list
*)



(* This function checks against declared items in listOfTerminal Items*)
let rec is_terminating y listOfTerminalItems =
	match y with 
	[] -> true
	| h::t -> match h with
				T x -> (is_terminating t listOfTerminalItems)
				| N x -> (contains x listOfTerminalItems) && (is_terminating t listOfTerminalItems)

(* Basic function to add symbols to list without duplicates. Saves Memory + Time*)
let addSymbolToList item l =
	if(contains item l) then l
else item::l

(* Finds if a symbol is directly terminating or not. Returns a list of symbols that are terminating *)	
(* Directly Terminating -> That are of the form (Expr, [T"f"]) *)		 	
let rec find_terminating_symbols rul = 
	match rul with
	[] -> []
	| h::t -> match h with 
			 (x,y) -> if( is_terminating y []) then (addSymbolToList x (find_terminating_symbols t))
			 			else (find_terminating_symbols t)

(* This function checks if the replacement has the same symbol or not. If it does, then this replacement will be useless to generate a terminating sequence*)
let rec contains_same_symbol startSymbol sequence =
	match sequence with
	[] -> false
	| h::t -> match h with
			N x -> if (x = startSymbol) then true
					else (contains_same_symbol startSymbol t)
			| T x -> (contains_same_symbol startSymbol t)

(* Called every time with entire list again, every time a new entry is added *)
(* Recursive function to find terminating symbols*)
let rec filter_alleys rules terminating_symbols =
	match rules with
	[] -> terminating_symbols
	| (sym, rule)::t -> if (is_terminating rule terminating_symbols) then (filter_alleys t (addSymbolToList sym terminating_symbols))
							else (filter_alleys t (terminating_symbols))

let wrapper_function_filter (rules, terminating_symbols) =
	(* wrapper function since just having filter_alleys does not go through entire list of rules when reiterating through entire list*)
	(rules, (filter_alleys rules terminating_symbols))

let eq_tuples (a,b) (x,y)=
	(equal_sets b y)

let rec check_rule rule terminating_symbols =
	match rule with 
	[] -> true
	| h::t -> match h with 
				| T x -> (check_rule t terminating_symbols)
				| N x -> if (contains x terminating_symbols) then (check_rule t terminating_symbols)
							else false (* Non terminating symbol found, => blind alley found, since not in list and starts with N*)

let rec remove_non_terminal terminating_symbols rules_list return_rules_list =
	match rules_list with
	[] -> return_rules_list
	| h::t -> match h with 
			(x,y) ->  if (check_rule y terminating_symbols) (* If true, then rule contains no non-terminating rules contains no non-terminating symbols *)
				then (remove_non_terminal terminating_symbols t (return_rules_list@[(x,y)]))
			else (remove_non_terminal terminating_symbols t return_rules_list)

let filter_blind_alleys g =
	match g with 
	(startSymbol, rules_list) -> let directly_terminating = (find_terminating_symbols rules_list) in
								match (computed_fixed_point eq_tuples (wrapper_function_filter) (rules_list, directly_terminating)) with
								(x,y) -> (startSymbol, (remove_non_terminal y rules_list [])) (* remove all the non-terminal values *) 


	(*(startSymbol, (filter_alleys rules_list (find_terminating_symbols rules_list)))*)


