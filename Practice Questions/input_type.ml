let accept_all derivation string =
   Some(derivation, string)
   in let accept_empty_suffix derivation = 
      function
      | [] -> Some(derivation, [])
      | _ -> None
     in accept_all accept_empty_suffix "aoogah!"