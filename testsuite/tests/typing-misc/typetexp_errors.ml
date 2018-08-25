(* TEST
   * expect
*)

type ('a,'at,'any,'en) t = A of 'an
[%%expect {|
Line 1, characters 32-35:
  type ('a,'at,'any,'en) t = A of 'an
                                  ^^^
Error: The type variable 'an is unbound in this type declaration.
Hint: Did you mean 'a, 'any, 'at or 'en?
|}
]
