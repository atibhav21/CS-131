#use "hw1.ml"

type testing_symbols =
	| A | B | C | D 

(* Function subset *)

let my_subset_test0 = subset [] ["a"; "b"; "c"]
let my_subset_test1 = subset ["b"; "a"] ["a"; "b"; "c"]
let my_subset_test2 = not (subset ["x"] ["a"; "b"; "c"])


let my_equal_sets_test0 = equal_sets ["b";"a";"c"] ["a"; "b"; "c"]
let my_equal_sets_test0 = equal_sets ["b";"a";"c";"b";"a";"c"] ["a";"b";"c"]
let my_equal_sets_test1 = not (equal_sets ["b";"a"]["b";"a";"c"])


let my_set_union_test2 = equal_sets (set_union [] []) []
let my_set_union_test0 = equal_sets (set_union ["b";"a"] ["c"]) ["a";"b";"c"]
let my_set_union_test1 = equal_sets (set_union [A;B;D] [A;B;C]) [A;B;C;D]
 

let my_set_intersection_test0 = equal_sets (set_intersection [A;B] [C;D]) []
let my_set_intersection_test1 = equal_sets (set_intersection [A;B;C] [A;B;C;D]) [A;B;C]
let my_set_intersection_test2 = equal_sets (set_intersection [A;B;C] [C;D]) [C]

let my_set_diff_test0 = equal_sets (set_diff [A;B;C] [A]) [B;C]
let my_set_diff_test1 = equal_sets (set_diff [A;B;C] [A;B;C;D]) []
let my_set_diff_test2 = equal_sets (set_diff [A;B] [C;D]) [A;B]


let my_computed_fixed_point_test0 = computed_fixed_point (=) (fun x -> x / 1) 100 = 100
let my_computed_fixed_point_test1 = computed_fixed_point (=) (fun x -> x / 3) 181 = 0


let my_computed_periodic_point_test0 = computed_periodic_point (=) (fun x -> x/2) 3 (100) = 0
let my_computed_periodic_point_test1 = computed_periodic_point (=) (fun x -> x/2) 1 (1000000000) = 0
let my_computed_periodic_point_test2 = computed_periodic_point (=) (fun x-> x*.2.) 1 (1.) = infinity
let my_computed_periodic_point_test3 = computed_periodic_point (=) sqrt 1 10. = 1.


let my_while_away_test1 = equal_sets (while_away (( * )2) ((>) 150) 1) [1;2;4;8;16;32;64;128]
let my_while_away_test2 = equal_sets (while_away ((+) 1) ((>) 4) 5) []


let my_rle_decode_test0 = equal_sets (rle_decode [2,A; 1,B; 3,C; 0, D]) [A;A;B;C;C;C]


(* FILTER BLIND ALLEY FUNCTION TESTS*)

type food_nonterminals =
	| Fruit | Vegetable | Snack | Drink | Meal 

let food_rules = 
	[ 	Fruit, [T"Apple"];
		Fruit, [T"Banana"];
		Fruit, [T"Orange"];
		Vegetable, [T"Carrot"];
		Snack, [N Fruit];
		Snack, [N Snack];
		Meal, [N Fruit; N Drink; N Snack];
		Meal, [N Fruit; N Snack];
	]

let my_filter_blind_alleys_test0 = filter_blind_alleys (Fruit, food_rules) = (Fruit, 
	  [ Fruit, [T"Apple"];
		Fruit, [T"Banana"];
		Fruit, [T"Orange"];
		Vegetable, [T"Carrot"];
		Snack, [N Fruit];
		Snack, [N Snack];
		Meal, [N Fruit; N Snack];
	])