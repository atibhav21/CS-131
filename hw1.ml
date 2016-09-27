(* Homework 1 CS 131 *)

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
let rec computed_fixed_point eq f x = 
	let y = f(x) in 
	if (eq y x) then x
		else (computed_fixed_point eq f y)
	
(* Not Working *)
(*
let rec computed_periodic_point eq p f x =
	let y = f(x) in
	if (p = 0) then
		if (eq y x) then x
		else (computed_periodic_point eq p f y)
	else
		(computed_periodic_point eq (p-1) f y)*)

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






