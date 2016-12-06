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






(* Add stuff to derivationList when calling the and_matcher because the rule is will be part of the derivation that we're trying*)
let rec make_or_matcher ruleList currentRuleList currentSymbol acceptor derivationList fragment =
	match fragment with 
		(* If fragment is empty, then pass to acceptor*)
		| [] -> acceptor derivationList []
		| h::t ->
			match (currentRuleList) with
			| [] -> None (* No Rules Found/left to use for the derivation list*)
			| currentRule::nextRules ->
				match (make_and_matcher ruleList currentRule acceptor (derivationList@[(currentSymbol,currentRule)]) fragment) with
				(* If and_matcher returns None, try the next rule, or if it doesn't then return whatever it returned *)
				| None -> (make_or_matcher ruleList nextRules currentSymbol acceptor derivationList fragment)
				| ok -> ok
				(*match currentRule with
							 	| [] -> (make_or_matcher ruleList nextRules currentSymbol acceptor derivationList fragment)
							 	| firstSym::tail -> match firstSym with
							 						| N x -> (make_or_matcher ruleList currentRuleList currentSymbol acceptor derivationList fragment)
							 						| T x -> if (x=h) then (make_and_matcher ) (* Terminal matched so pass in rest of the rule and the rest of the fragment to make_and_matcher*)
							 								 else (make_or_matcher ruleList nextRules currentSymbol acceptor derivationList fragment)*)

and make_and_matcher ruleList currentRule acceptor derivationList fragment =
		match currentRule with 
		(* Rule is empty so we pass it to the acceptor*)
		| [] -> acceptor derivationList fragment
		| h::t ->  match fragment with 
			(* Rule isn't empty but fragment is, so return none*)
			 | [] -> None
			(* get the first term from the fragment*)
			 | firstTerm::tail ->match h with
			 					 (* Another non terminal found so call make_or_matcher*)
			 					 | N x -> (make_or_matcher ruleList (ruleList x) x (make_and_matcher ruleList t acceptor) derivationList fragment)
			 					 (* If terminal found, check the rest of the items in the rule, else return None*)
			 					 | T x -> if(firstTerm = x) then (make_and_matcher ruleList t acceptor derivationList tail)
			 					 		  else None