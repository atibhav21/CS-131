(* Not Working *)
(*
let rec calculate_p_calls eq f p t =
	match p with 
	0 -> if ( eq (f t) t) then true
		else false
	| _ -> (calculate_p_calls eq f(f x) (p-1) t)

let rec calculate_pth_call f p t =
	match p with
	0 -> (f t)
	| _ -> (calculate_pth_call f (p-1) (f t))

let rec computed_periodic_point eq f p t =
	match (calculate_p_calls eq f p t) with
	true -> (calculate_pth_call f p t)
	| false -> (calculate_p_calls eq f p f(t))

*)

(*
let rec computed_periodic_point eq f p t =
	let y = (f t) in
		if (p = 0) && (eq y t) then y
	else

	| _ -> match (computed_periodic_point eq f(f x) (p-1) t) with 
		-1 -> (computed_periodic_point eq f p y)
*)

(*This function just checks if the sequence generated is directly terminating or not*)
let rec is_terminating y =
	match y with 
	[] -> true
	| h::t -> match h with 
				T x -> (is_terminating t)
				| N x -> false

(* This function checks against declared items in listOfTerminal Items*)
let rec is_terminating y listOfTerminalItems =
	match y with 
	[] -> true
	| h::t -> match h with
				T x -> (is_terminating t)
				| N x -> (contains x listOfTerminalItems) && (is_terminating t listOfTerminalItems)

(* This function returns a list of all the possible replacements for a non-terminating symbol*)
let rec find_replacements sym rul =
	match rul with
	[] -> []
	| h::t -> match h with 
			 	(x,y) -> if (x = sym) then y::(find_replacements sym t) (* Replacement Phrase Found for sym *)
			 			else (find_replacements sym t)
			 	
(* Finds if a symbol is directly terminating or not. Returns a list of symbols that are terminating *)			 	
let rec find_terminating_symbols rul = 
	match rul with
	[] -> []
	| h::t -> match h with 
			 (x,y) -> if( is_terminating y) then x::(find_terminating_symbols t)
			 			else (find_terminating_symbols t)

(* This function checks if the replacement has the same symbol or not. If it does, then this replacement will be useless to generate a terminating sequence*)
let rec contains_same_symbol startSymbol sequence =
	match sequence with
	[] -> false
	| h::t -> match h with
			N x -> if (x = startSymbol) then true
					else (contains_same_symbol startSymbol t)
			| T x -> (contains_same_symbol startSymbol t)

let rec check_replacement startSymbol replacement listOfTerminalItems =
	if (contains_same_symbol startSymbol replacement) then false

let rec check_replacement_with_list replacementRule listOfTerminalItems =
	match replacementRule with
	[] -> true
	| h::t -> match h with 
			 T x -> check_replacement_with_list(t listOfTerminalItems)
			 | N x -> (contains x listOfTerminalItems) && (check_replacement_with_list t listOfTerminalItems)

let rec check_all_replacements startSymbol listOfReplacements listOfTerminalItems = 
	match listOfReplacements with
	[] -> []
	| h::t -> if (check_replacement_with_list h listOfTerminalItems) then (check_all_replacements startSymbol t (listOfTerminalItems)) 
				else 
					if (check_replacement startSymbol h) 
					then 
				(* Use computed_fixed_point/ computed_periodic_point to see whether h is terminating or not*)
				(* If h is terminating, add it to list, return list, else return list*)
				(* if replacement contains N symbol then move onto next replacement *)

let rec filter_alleys startSymbol rules listOfTerminalItems =
	let replacements = (find_replacements startSymbol rules) in


let rec filter_blind_alleys g =
	match g with 
	(x,y) -> let terminal_values = (find_terminating_symbols y) in
				(x, (filter_alleys x y terminal_values))

	
		
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

(*
let rec check_replacement startSymbol replacement listOfTerminalItems =
	if (contains_same_symbol startSymbol replacement) then false

let rec check_replacement_with_list replacementRule listOfTerminalItems =
	match replacementRule with
	[] -> true
	| h::t -> match h with 
			 T x -> check_replacement_with_list(t listOfTerminalItems)
			 | N x -> (contains x listOfTerminalItems) && (check_replacement_with_list t listOfTerminalItems)

let rec check_all_replacements startSymbol listOfReplacements listOfTerminalItems = 
	match listOfReplacements with
	[] -> []
	| h::t -> if (check_replacement_with_list h listOfTerminalItems) then (check_all_replacements startSymbol t (listOfTerminalItems)) 
				else 
					if (check_replacement startSymbol h) 
					then 
				(* Use computed_fixed_point/ computed_periodic_point to see whether h is terminating or not*)
				(* If h is terminating, add it to list, return list, else return list*)
				(* if replacement contains N symbol then move onto next replacement *)
*)

(*let check_item symbol rules_list terminal_values =
	let replacement_items = (find_replacements symbol) in
	return (check_replacements symbol rules_list terminal_values replacement_items)*)

(*
let remove_terminating_symbol symbol =
	match symbol with
	T x -> x
	| N x -> x
*)
(*)
(* Check whether the symbols in a replacement are terminating or not*)
let rec check_replacement sym rules_list terminal_values replacement_items =
	match replacement_items with
	[] -> false
	| h::t -> if(is_terminating h terminal_values) then true
			else
					if (contains_same_symbol sym h) then (check_replacement sym rules_list terminal_values t)
				else 
					(check_recursive_item h rules_list terminal_values)

(* This function recursively checks for if a rule replacement is terminating or not (helper recursive function)*)
and check_recursive_item rule rules_list terminal_values =
	match rule with 
	[] -> true
	| h::t -> if not (check_replacement (remove_terminating_symbol h) rules_list terminal_values (find_replacements h rules_list)) then false
				else (check_recursive_item t rules_list terminal_values)
*)
(* Uncomment)
let rec check_rule rule rules_list terminal_values =
	match rule with 
	[] -> true
	| h::t -> let item = (remove_terminating_symbol h) in
				if (contains item terminal_values) then (check_rule t rules_list terminal_values)

				else if ( check_replacement item rules_list terminal_values (find_replacements h rules_list)) 
				then (check_rule t rules_list (item::(terminal_values)))

				else false

let remove_first_item h =
	match h with
	(x,y) -> y

let get_first_item h =
	match h with 
	(x,y) -> x

(*line 205, terminal_values is causing syntax error*)
let rec filter_alleys rules_iterative rules_constant =
	let terminal_values = (find_terminating_symbols rules_constant) in
	match rules_iterative with
	[] -> []
	| h::t -> if(check_rule (remove_first_item h) rules_constant terminal_values) then (get_first_item h)::(filter_alleys t rules_constant)
			 			else (filter_alleys t rules_constant)


let rec filter_blind_alleys g =
	match g with 
	(x,y) ->  x, (filter_alleys y y)

	*)
		
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

(*This function just checks if the sequence generated is directly terminating or not*)
(*let rec is_terminating y =
	match y with 
	[] -> true
	| h::t -> match h with 
				T x -> (is_terminating t)
				| N x -> false*)

(*
(* This function returns a list of all the possible replacements for a non-terminating symbol*)
let rec find_replacements sym rul =
	match rul with
	[] -> []
	| h::t -> match h with 
			 	(x,y) -> if (x = sym) then y::(find_replacements sym t) (* Replacement Phrase Found for sym *)
			 			else (find_replacements sym t)

*)
