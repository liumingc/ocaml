(* TEST
   * expect
*)

let rec x = (x; ());;
[%%expect{|
val x : unit = ()
|}];;

let rec x = "x";;
[%%expect{|
val x : string = "x"
|}];;

let rec x = let x = () in x;;
[%%expect{|
val x : unit = ()
|}];;

let rec x = let y = (x; ()) in y;;
[%%expect{|
val x : unit = ()
|}];;

let rec x = let y = () in x;;
[%%expect{|
Line 1, characters 12-27:
  let rec x = let y = () in x;;
              ^^^^^^^^^^^^^^^
Error: This kind of expression is not allowed as right-hand side of `let rec'
|}];;

let rec x = [y]
and y = let x = () in x;;
[%%expect{|
val x : unit list = [()]
val y : unit = ()
|}];;

let rec x = [y]
and y = let rec x = () in x;;
[%%expect{|
val x : unit list = [()]
val y : unit = ()
|}];;

let rec x =
  let a = x in
  fun () -> a ()
and y =
  [x];;
[%%expect{|
val x : unit -> 'a = <fun>
val y : (unit -> 'a) list = [<fun>]
|}];;

let rec x = [|y|] and y = 0;;
[%%expect{|
val x : int array = [|0|]
val y : int = 0
|}];;


let rec x = (y, y)
and y = fun () -> ignore x;;
[%%expect{|
val x : (unit -> unit) * (unit -> unit) = (<fun>, <fun>)
val y : unit -> unit = <fun>
|}];;

let rec x = Some y
and y = fun () -> ignore x
;;
[%%expect{|
val x : (unit -> unit) option = Some <fun>
val y : unit -> unit = <fun>
|}];;

let rec x = ignore x;;
[%%expect{|
Line 1, characters 12-20:
  let rec x = ignore x;;
              ^^^^^^^^
Error: This kind of expression is not allowed as right-hand side of `let rec'
|}];;

let rec x = y 0 and y _ = ();;
[%%expect{|
Line 1, characters 12-15:
  let rec x = y 0 and y _ = ();;
              ^^^
Error: This kind of expression is not allowed as right-hand side of `let rec'
|}];;

let rec b = if b then true else false;;
[%%expect{|
Line 1, characters 12-37:
  let rec b = if b then true else false;;
              ^^^^^^^^^^^^^^^^^^^^^^^^^
Error: This kind of expression is not allowed as right-hand side of `let rec'
|}];;

let rec x = function
    Some _ -> ignore (y [])
  | None -> ignore (y [])
and y = function
    [] -> ignore (x None)
  | _ :: _ -> ignore (x None)
    ;;
[%%expect{|
val x : 'a option -> unit = <fun>
val y : 'a list -> unit = <fun>
|}];;

let rec x = { x with contents = 3 }  [@ocaml.warning "-23"];;
[%%expect{|
val x : int ref = {contents = 3}
|}];;

let rec c = { c with Complex.re = 1.0 };;
[%%expect{|
Line 1, characters 12-39:
  let rec c = { c with Complex.re = 1.0 };;
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^
Error: This kind of expression is not allowed as right-hand side of `let rec'
|}];;

let rec x = `A y
and y = fun () -> ignore x
;;
[%%expect{|
val x : [> `A of unit -> unit ] = `A <fun>
val y : unit -> unit = <fun>
|}];;

let rec x = { contents = y }
and y = fun () -> ignore x;;
[%%expect{|
val x : (unit -> unit) ref = {contents = <fun>}
val y : unit -> unit = <fun>
|}];;

let r = ref (fun () -> ())
let rec x = fun () -> r := x;;
[%%expect{|
val r : (unit -> unit) ref = {contents = <fun>}
val x : unit -> unit = <fun>
|}];;

let rec x = fun () -> y.contents and y = { contents = 3 };;
[%%expect{|
val x : unit -> int = <fun>
val y : int ref = {contents = 3}
|}];;

let r = ref ()
let rec x = r := x;;
[%%expect{|
val r : unit ref = {contents = ()}
Line 2, characters 12-18:
  let rec x = r := x;;
              ^^^^^^
Error: This kind of expression is not allowed as right-hand side of `let rec'
|}];;

let rec x =
  for i = 0 to 1 do
    let z = y in ignore z
  done
and y = x; ();;
[%%expect{|
Line 2, characters 2-52:
  ..for i = 0 to 1 do
      let z = y in ignore z
    done
Error: This kind of expression is not allowed as right-hand side of `let rec'
|}];;

let rec x =
  for i = 0 to y do
    ()
  done
and y = 10;;
[%%expect{|
Line 2, characters 2-33:
  ..for i = 0 to y do
      ()
    done
Error: This kind of expression is not allowed as right-hand side of `let rec'
|}];;

let rec x =
  for i = y to 10 do
    ()
  done
and y = 0;;
[%%expect{|
Line 2, characters 2-34:
  ..for i = y to 10 do
      ()
    done
Error: This kind of expression is not allowed as right-hand side of `let rec'
|}];;

let rec x =
  while false do
    let y = x in ignore y
  done
and y = x; ();;
[%%expect{|
Line 2, characters 2-49:
  ..while false do
      let y = x in ignore y
    done
Error: This kind of expression is not allowed as right-hand side of `let rec'
|}];;

let rec x =
  while y do
    ()
  done
and y = false;;
[%%expect{|
Line 2, characters 2-26:
  ..while y do
      ()
    done
Error: This kind of expression is not allowed as right-hand side of `let rec'
|}];;

let rec x =
  while y do
    let y = x in ignore y
  done
and y = false;;
[%%expect{|
Line 2, characters 2-45:
  ..while y do
      let y = x in ignore y
    done
Error: This kind of expression is not allowed as right-hand side of `let rec'
|}];;



let rec x = y.contents and y = { contents = 3 };;
[%%expect{|
Line 1, characters 12-22:
  let rec x = y.contents and y = { contents = 3 };;
              ^^^^^^^^^^
Error: This kind of expression is not allowed as right-hand side of `let rec'
|}];;

let rec x = assert y and y = true;;
[%%expect{|
Line 1, characters 12-20:
  let rec x = assert y and y = true;;
              ^^^^^^^^
Error: This kind of expression is not allowed as right-hand side of `let rec'
|}];;

(* Recursively constructing arrays of known non-float type is permitted *)
let rec deep_cycle : [`Tuple of [`Shared of 'a] array] as 'a
  = `Tuple [| `Shared deep_cycle |];;
[%%expect{|
val deep_cycle : [ `Tuple of [ `Shared of 'a ] array ] as 'a =
  `Tuple [|`Shared <cycle>|]
|}];;

(* Constructing float arrays was disallowed altogether at one point
   by an overzealous check.  Constructing float arrays in recursive
   bindings is fine when they don't partake in the recursion. *)
let rec _x = let _ = [| 1.0 |] in 1. in ();;
[%%expect{|
- : unit = ()
|}];;

(* The builtin Pervasives.ref is currently treated as a constructor.
   Other functions of the same name should not be so treated. *)
let _ =
  let module Pervasives =
  struct
    let ref _ = assert false
  end in
  let rec x = Pervasives.ref y
  and y = fun () -> ignore x
  in (x, y)
;;
[%%expect{|
Line 6, characters 14-30:
    let rec x = Pervasives.ref y
                ^^^^^^^^^^^^^^^^
Error: This kind of expression is not allowed as right-hand side of `let rec'
|}];;

(* An example, from Leo White, of let rec bindings that allocate
   values of unknown size *)
let foo p x =
  let rec f =
    if p then (fun y -> x + g y) else (fun y -> g y)
  and g =
    if not p then (fun y -> x - f y) else (fun y -> f y)
  in
  (f, g)
;;
[%%expect{|
Line 3, characters 4-52:
      if p then (fun y -> x + g y) else (fun y -> g y)
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Error: This kind of expression is not allowed as right-hand side of `let rec'
|}];;

let rec x =
  match let _ = y in raise Not_found with
    _ -> "x"
  | exception Not_found -> "z"
and y = match x with
  z -> ("y", z);;
[%%expect{|
Line 2, characters 2-85:
  ..match let _ = y in raise Not_found with
      _ -> "x"
    | exception Not_found -> "z"
Error: This kind of expression is not allowed as right-hand side of `let rec'
|}];;
