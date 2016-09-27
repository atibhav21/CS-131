#use "hw1.ml"

(* Function subset *)
let subset_test0 = subset [] [1;2;3];;
let subset_test1 = subset [1] [1;2;3;4];;
let subset_test2 = subset [5] [1;2;3];;

let equal_test0 = equal_sets [1;3] [3;1;3];;
let equal_test1 = equal_sets [1;2;3] [1;5;7];;
let equal_test2 = equal_sets [1;2;3] [3;2;1];;

let set_union_test0 = equal_sets (set_union [] [1;2;3]) [1;2;3]
let set_union_test1 = equal_sets (set_union [3;1;3] [1;2;3]) [1;2;3]
let set_union_test2 = equal_sets (set_union [] []) []

let set_intersection_test0 = equal_sets (set_intersection [] [1;2;3]) []
let set_intersection_test1 = equal_sets (set_intersection [3;1;3] [1;2;3]) [1;3]
let set_intersection_test2 = equal_sets (set_intersection [1;2;3;4] [3;1;2;4]) [4;3;2;1]

let set_diff_test0 = equal_sets (set_diff [1;3] [1;4;3;1]) []
let set_diff_test1 = equal_sets (set_diff [4;3;1;1;3] [1;3]) [4]
let set_diff_test2 = equal_sets (set_diff [4;3;1] []) [1;3;4]
let set_diff_test3 = equal_sets (set_diff [] [4;3;1]) []

let computed_fixed_point_test0 = computed_fixed_point (=) (fun x -> x / 2) 1000000000 = 0
let computed_fixed_point_test1 = computed_fixed_point (=) (fun x -> x *. 2.) 1. = infinity
let computed_fixed_point_test2 = computed_fixed_point (=) sqrt 10. = 1.
let computed_fixed_point_test3 = ((computed_fixed_point (fun x y -> abs_float (x -. y) < 1.) (fun x -> x /. 2.) 10.) = 1.25)

(*
let computed_periodic_point_test0 = computed_periodic_point (=) (fun x -> x / 2) 0 (-1) = -1
let computed_periodic_point_test1 = computed_periodic_point (=) (fun x -> x *. x -. 1.) 2 0.5 = -1. *)

let while_away_test0 = equal_sets (while_away ((+) 3) ((>) 10) 0) [0; 3; 6; 9]

let my_while_away_test1 = equal_sets (while_away (( * )2) ((>) 150) 1) [1;2;4;8;16;32;64;128]
let my_while_away_test2 = equal_sets (while_away ((+) 1) ((>) 4) 5) []

let rle_decode_test0 = rle_decode [2,0; 1,6]
let rle_decode_test1 = rle_decode [3,"w"; 1,"x"; 0,"y"; 2,"z"]