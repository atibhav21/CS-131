#use "hw2.ml";;

type food_nonterminals =
  | Breakfast |Cereal | Sandwich | Ingredient | CerealBrand | Meat


let food_grammar =
	(Breakfast, 
		function 
		| Breakfast -> [[N Cereal;N Sandwich];
						[N Sandwich];
						[N Cereal];
						[N Ingredient]]
		| Cereal -> [[N Ingredient; N CerealBrand]]
		| CerealBrand -> [[T"Golden Grahams"]; [T"Cinnamon Toast Crunch"]; [T"Trix"]; [T"Reese Puff"]]
		| Sandwich -> [[N Ingredient; N Meat; N Ingredient];
					   [N Ingredient]]
		| Meat -> [[T"Salami"];[T"Ham"];[T"Sausage"];[T"Bologna"]]
		| Ingredient -> [[T"Bread"];[T"Milk"];[T"Salt"];[T"Pepper"]])

(* Accept suffixes that only begin with milk*)
let accept_milk derivation suff= match suff with 
				| h::t -> if (h = "Milk") then Some(derivation, h::t)
						  else None
				| _ -> None
let test_0 = (parse_prefix food_grammar accept_milk ["Milk";"Trix";"Bread";"Salami";]) = None
let test_01 = (parse_prefix food_grammar accept_all ["Milk";"Trix";"Bread";"Salami"]) = 
	Some
   ([(Breakfast, [N Cereal; N Sandwich]);
     (Cereal, [N Ingredient; N CerealBrand]); (Ingredient, [T "Milk"]);
     (CerealBrand, [T "Trix"]); (Sandwich, [N Ingredient]);
     (Ingredient, [T "Bread"])],
    ["Salami"])

let test_1 = (parse_prefix food_grammar accept_milk ["Milk";"Reese Puff";"Bread";"Salami";"Pepper";"Milk"]) =
	Some
   ([(Breakfast, [N Cereal; N Sandwich]);
     (Cereal, [N Ingredient; N CerealBrand]); (Ingredient, [T "Milk"]);
     (CerealBrand, [T "Reese Puff"]);
     (Sandwich, [N Ingredient; N Meat; N Ingredient]);
     (Ingredient, [T "Bread"]); (Meat, [T "Salami"]);
     (Ingredient, [T "Pepper"])],
    ["Milk"])

type english_grammar_nonterminals = 
	| Sentence | Noun | Verb | Adjective | Article | NP | VP 

let accept_all derivation string = Some(derivation,string)

let english_grammar =
	(Sentence, 
		function
		| Sentence -> [[N NP; N VP]; [N Noun; N Verb]; ]
		| Noun -> [[T"I"];[T"John"];[T"He"];[T"food"];[T"football"]]
		| Verb -> [[T"plays"];[T"eats"];[T"was"]]
		| Adjective -> [[T"great"]; [T"amazing"]]
		| Article -> [[T"a"];[T"the"]]
		| NP -> [[N Noun];[N Article; N Noun]]
		| VP -> [[N Adjective; N Verb];[N Verb; N NP]]
	)

let test_2 = (parse_prefix english_grammar accept_all ["John";"plays";"football";"on";"Wednesday"])
		= Some
   ([(Sentence, [N NP; N VP]); (NP, [N Noun]); (Noun, [T "John"]);
     (VP, [N Verb; N NP]); (Verb, [T "plays"]); (NP, [N Noun]);
     (Noun, [T "football"])],
    ["on"; "Wednesday"])

let english_grammar_fails =
	(Sentence,
		function
		| Sentence -> [[N NP; N VP]; [N Noun; N Verb]; ]
		| Noun -> [[T"I"];[T"John"];[T"He"];[T"food"];[T"football"]]
		| Verb -> [[T"plays"];[T"eats"];[T"was"]]
		| Adjective -> [[T"great"]; [T"amazing"]]
		| Article -> [[T"a"];[T"the"]]
		| NP -> [[N NP];[N Noun];[N Article; N Noun]]
		| VP -> [[N Adjective; N Verb];[N Verb; N NP]])

(* This test fails since english_grammar_fails isn't left associative, leads to infinite recursion*)
let test_3 = (parse_prefix english_grammar_fails accept_all ["John";"plays";"football";"on";"Wednesday"])

(*)
let awkish_grammar =
  (Expr,
   function
     | Expr ->
         [[N Term; N Binop; N Expr];
          [N Term]]
     | Term ->
	 [[N Num];
	  [N Lvalue];
	  [N Incrop; N Lvalue];
	  [N Lvalue; N Incrop];
	  [T"("; N Expr; T")"]]
     | Lvalue ->
	 [[T"$"; N Expr]]
     | Incrop ->
	 [[T"++"];
	  [T"--"]]
     | Binop ->
	 [[T"+"];
	  [T"-"]]
     | Num ->
	 [[T"0"]; [T"1"]; [T"2"]; [T"3"]; [T"4"];
	  [T"5"]; [T"6"]; [T"7"]; [T"8"]; [T"9"]])
*)
