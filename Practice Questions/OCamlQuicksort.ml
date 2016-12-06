

let rec quicksort = function
	| [] -> []
	| h::t ->
			let rec partition nlist pivot smallerList largerList =
				match nlist with 
					| [] -> (smallerList, largerList)
					| firstEl::rest -> if firstEl < pivot then (partition rest pivot (firstEl::smallerList) largerList)
							else (partition rest pivot smallerList (firstEl::largerList))
			in 
				let (x,y) = (partition t h [] []) in
					(quicksort x)@[h]@(quicksort y)

