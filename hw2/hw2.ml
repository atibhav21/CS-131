type ('nonterminal, 'terminal) symbol =
  | N of 'nonterminal
  | T of 'terminal

let rec convert_grammar_helper ruleList matchSymbol =
	match ruleList with
	[] -> []
	| (x,y)::t -> if (x = matchSymbol) then y::(convert_grammar_helper t matchSymbol)
					else (convert_grammar_helper t matchSymbol)


let convert_grammar gram1 =
	match gram1 with
	(x,y) -> x, (convert_grammar_helper y)

let rec make_or_matcher ruleList currentRuleList currentSymbol acceptor derivationList fragment =
	match fragment with
	| [] -> acceptor derivationList fragment
	| x::y -> match currentRuleList with
		| [] -> None (* No rules left*)
		| firstRule::restRules -> (* call match_and because we want to match all the symbols in the rule*)
								match (make_and_matcher ruleList firstRule acceptor (derivationList@[(currentSymbol, firstRule)]) fragment) with
								 | None -> (* check next rule*)
								 			(make_or_matcher ruleList restRules currentSymbol acceptor derivationList fragment)
								 | ok -> ok (* found a match so return as it is*)

and make_and_matcher ruleList currentRule acceptor derivationList fragment =
	match currentRule with
	(* No terms left in the rule*)
	| [] -> acceptor derivationList fragment
	| firstTerm::restTerms -> match fragment with
							| [] -> None (* Rule has terms but fragment is empty *)
							| term::tail -> match firstTerm with
										(* Call make_or_matcher since we encountered a non-terminal *)
										| N x -> make_or_matcher ruleList (ruleList x) x (make_and_matcher ruleList restTerms acceptor) derivationList fragment
										| T x ->  if (x = term) then (make_and_matcher ruleList restTerms acceptor derivationList tail)
												 else None


	
let rec parse_prefix gram accept frag =
	match gram with
	| (x,y) -> (make_or_matcher y (y x) x accept [] frag)

	(*match fragment with 
		| [] -> acceptor derivationList [] (*Empty fragment so go to acceptor*)
		| h::t -> 
				match (currentRule) with
				| [] -> None 
				| currentRule::nextRules ->
					match currentRule with
					| [] -> acceptor (currentRule::derivationList) t
					| firstSym::tail -> match firstSym with
									| N x -> (make_or_matcher ruleList (currentRuleList x) startSymbol derivationList acceptor fragment)
									| T x -> if (x=h) then ()*)

(*let rec matcher startSymbolOfRule symbolToMatch ruleList currentRule fragment =
	match fragment with
	[] -> Some(currentRule)
	| a::b -> match (ruleList symbolToMatch) with
			| [] -> None
			| h::t -> match h with 
			 		| firstSym::tail -> match firstSym with
			 						| T x -> if (x = a) then (matcher startSymbolOfRule (get_first_sym tail) ruleList currentRule (List.tl fragment))
			 							 else None
			 						| N x -> (matcher startSymbolOfRule x ruleList currentRule fragment)
*)
(*
let rec make_or_matcher startSymbol ruleList derivation currentSymbol accept frag =
	let replacementList = (ruleList currentSymbol) in 
	match replacementList with
	| [] -> derivation
	| h::t -> (* h contains the first rule, t contains the rest of the replacements*)
				match h with 
				| firstVal::tail -> match firstVal with 
									| N x -> (* non-terminal, so make an and_matcher with all the values in this *)
									| T x -> match frag with 
											| [] -> derivation
											| firstTerminal::restFrag -> if firstTerminal = x then (make_and_matcher )

*)
(*
let rec parse_prefix gram accept frag = 
	match gram with 
	| (startSymbol, ruleList) -> 
								(* at this point, h contains the prefix, we want to check if h can be applied to accept frag*)
								
	
let rec match_fragment make_a_matcher = function
	| [] -> match_nothing
	| head::tail -> 
			let head_matcher = make_a_matcher head 
			and tail_matcher = match_fragment make_a_matcher tail 
		in fun frag accept ->
					let ormatch = head_matcher frag accept
				in match ormatch with
					| None -> tail_matcher frag accept
					| _ -> ormatch*)