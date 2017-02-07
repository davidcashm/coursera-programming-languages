(* Coursera Programming Languages, Homework 3, Provided Code *)

exception NoAnswer

datatype pattern = Wildcard
		 | Variable of string
		 | UnitP
		 | ConstP of int
		 | TupleP of pattern list
		 | ConstructorP of string * pattern

datatype valu = Const of int
	      | Unit
	      | Tuple of valu list
	      | Constructor of string * valu

fun g f1 f2 p =
    let 
	val r = g f1 f2 
    in
	case p of
	    Wildcard          => f1 ()
	  | Variable x        => f2 x
	  | TupleP ps         => List.foldl (fn (p,i) => (r p) + i) 0 ps
	  | ConstructorP(_,p) => r p
	  | _                 => 0
    end

(**** for the challenge problem only ****)

datatype typ = Anything
	     | UnitT
	     | IntT
	     | TupleT of typ list
	     | Datatype of string


fun only_capitals strs = List.filter (fn str => Char.isUpper (String.sub (str, 0))) strs

fun longest_string1 strs = foldl
			       (fn (s,longest) => if String.size s > String.size longest then s else longest)
			       ""
			       strs

fun longest_string2 strs = foldl
			       (fn (s,longest) => if String.size s >= String.size longest then s else longest)
			       ""
			       strs

fun longest_string_helper f strs = foldl
			       (fn (s,longest) => if f (String.size s , String.size longest) then s else longest)
			       ""
			       strs

val longest_string3 = longest_string_helper op>
val longest_string4 = longest_string_helper op>=

val longest_capitalized = longest_string1 o only_capitals

val rev_string = String.implode o rev o String.explode
    
fun first_answer f vals =
		 case vals of
		     [] => raise NoAnswer
		  |  v :: vs => case f v of
				    NONE => first_answer f vs
				 |  SOME result => result
fun all_answers f vals =
  case vals of
           [] => SOME [] 
    | v :: vs => case f v of
		     NONE => NONE (* Any NONE result immediately returns NONE for the entire function *)
            | SOME result => case all_answers f vs of
					NONE => NONE
				     | SOME rest_result => SOME (result @ rest_result)

val count_wildcards = g (fn () => 1) (fn v => 0)
val count_wild_and_variable_lengths = g (fn () => 1) String.size
fun count_some_var (str, pattern) = g (fn () => 0) (fn v => if v = str then 1 else 0) pattern 

fun check_pat pattern =
  let
      fun collect_variables pat =
	case pat of
	    Variable x        => [x]
	  | TupleP ps         => List.foldl (fn (p,r) => r @ collect_variables p) [] ps
	  | ConstructorP(_,p) => collect_variables p
	  | _                 => []
      fun no_repeats vars =
	case vars of
	    [] => true
	 |  v :: vs => if List.exists (fn x => x=v) vs then false else no_repeats vs
  in
      no_repeats (collect_variables pattern)    
  end

fun match (value, pattern) =
  case (value, pattern) of
      (_, Wildcard) => SOME []
   |  (v, Variable x) => SOME [(x, v)]
   |  (Unit, UnitP) => SOME []
   |  (Const x, ConstP y) => if x = y then SOME [] else NONE
   |  (Constructor(s1, v), ConstructorP(s2,p)) => if s1 = s2 then match(v,p) else NONE
   |  (Tuple vs, TupleP ps) => all_answers match (ListPair.zip (vs, ps))
   |  _ => NONE
  
fun first_match value patterns =
  SOME (first_answer (fn pattern => match (value, pattern)) patterns)
       handle NoAnswer => NONE
