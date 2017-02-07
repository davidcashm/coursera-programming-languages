(* Dan Grossman, Coursera PL, HW2 Provided Code *)

(* if you use this function to compare two strings (returns true if the same
   string), then you avoid several of the functions in problem 1 having
   polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
  s1 = s2

(* put your solutions for problem 1 here *)
fun all_except_option( s : string, strs : string list) =
  case strs of
      [] => NONE
   |  h :: rest => if h = s then SOME rest
		   else case all_except_option(s,rest) of
			    NONE => NONE
			 |  SOME result => SOME (h :: result)

fun get_substitutions1( strs : string list list, s : string) =
  case strs of
      [] => []
    | names :: rest => case all_except_option (s, names) of
			   NONE => get_substitutions1(rest, s)
			|  SOME result => result @ get_substitutions1(rest,s)

fun get_substitutions2( strs : string list list, s : string) =
  let fun helper(remaining, accumulated) =
	case remaining of
	    [] => accumulated
	  | names :: rest => case all_except_option (s, names) of
			   NONE => helper(rest, accumulated)
			|  SOME result => helper(rest, result @ accumulated)
  in helper(strs, [])
  end

fun similar_names (strs: string list list, name) =
  let val {first = f, middle = m, last = l} = name
      val similars = get_substitutions1(strs, f)
      fun mapper(newfirsts) = case newfirsts of
				  [] => []
			       |  name :: rest => ({first=name, middle=m, last=l} :: mapper(rest))
  in
      name :: mapper(similars)
  end
      

(* you may assume that Num is always used with values 2, 3, ..., 10
   though it will not really come up *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove

(* put your solutions for problem 2 here *)
fun card_color (s, r) =
  case s of
      Clubs => Black
    | Spades => Black
    | _ => Red

fun card_value (s, r) =
  case r of
      Ace => 11
    | Num n => n
    | _ => 10

fun remove_card (cs : card list, c : card, e) =
  case cs of
      [] => raise e
   |  ctest :: rest => if ctest = c then rest else ctest :: remove_card(rest, c, e)

fun all_same_color (cs : card list) =
  case cs of
      [] => true
   |  [c] => true
   |  c1 :: c2 :: rest => card_color(c1) = card_color(c2) andalso all_same_color(c2::rest)
								     
fun sum_cards (cs : card list) =
  let fun accumulator (cards, result) =
	case cards of
	    [] => result
	 |  c :: rest => accumulator(rest, result + card_value(c))
  in
      accumulator(cs, 0)
  end

fun score (cs : card list, goal) =
  let val sum = sum_cards cs
      val prelim = if sum > goal then 3*(sum - goal) else goal - sum
      val div_factor = if all_same_color cs then 2 else 1
  in
      prelim div div_factor
  end

fun officiate (cs : card list, moves : move list, goal) =
  let fun score_it (h) = score(h, goal)
      fun do_moves(held, cs, moves) =
	if (sum_cards held) > goal then score_it held else
	case moves of
	    [] => score_it held
          | Discard c :: other_moves => do_moves(remove_card(held, c, IllegalMove), cs, other_moves)
	  | Draw :: other_moves => case cs of
				[] => score_it held
		             |  next_card :: other_cards => do_moves(next_card :: held, other_cards, other_moves)
  in
      do_moves([], cs, moves)
  end
