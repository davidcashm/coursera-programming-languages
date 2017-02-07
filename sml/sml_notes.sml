(* This is a comment *)

(* To start repl in emacs: alt-x,sml-run,sml *)
val x = 34; (* x is an int *)
val y = 17;
val z = (x+y) + (y+2)
val abs_z = if z < 0 then (0-z) else z;
val abs_z2 = abs z;
fun pow (x : int, y : int) =
  if y = 0 then 1
  else x * pow(x,y-1);
val q = (1,2);
val r = #1 q;
val s = #2 q;
fun sum_pair (p1: int*int, p2: int*int) =
  (#1 p1 + #1 p2, #2 p1 + #2 p2);
val z = sum_pair((1,2),(3,4));
val l = [1,2,3];
val l2 = 1 :: 2 :: 3 :: 4 :: nil
val empty = null l2
val h = hd l;
val t = tl l;

fun sum_list (xs : int list) =
  if null xs
  then 0
  else hd xs + sum_list (tl xs);

val sm = sum_list [1,2,3,4]

fun list_product (xs : int list) =
  if null xs
  then 1
  else hd xs * list_product(tl xs);

fun countdown (x : int) =
  if x = 0
  then []
  else x :: (countdown (x-1))

fun append (xs : int list, ys : int list) =
  if xs = []
  then ys
  else (hd xs) :: append((tl xs),ys);

fun let_example (z : int) =
  let val x = if z > 0 then z else 34
      val y = x + z - 4 (* Could also define functions in a let expression *)
  in x + y + z
  end;

(* t option *)
val something = SOME 1;
val nothing = NONE;
val v = 3 + valOf something (* valOf nothing would throw exception *);
val foo = (3 > 0) andalso (3 < 4) orelse (not (1 < 2))
val ne = 3 <> 2

		  (* Union types *)
datatype mytype = TwoInts of int*int
	| Str of string
        | Pizza

fun f (x : mytype) =
  case x of
      Pizza => 3
   |  TwoInts(i1,i2) => i1+i2
   |  Str s => String.size s


type coord = int*int

fun swapx (c : coord) =
  (#2 c, #1 c)

datatype ('a, 'b) tree =
	 Node of 'a * ('a,'b) tree * ('a, 'b) tree
	 | Leaf of 'b

val tr = Node (1, Leaf "a", Leaf "b")
	      
	      (* Anonymous functions *)
val myfun = fn x => x+1
			  
infix !>

fun x !> f = f x

val sqrt_of_abs = Math.sqrt o Real.fromInt o abs
fun sqrt_of_abs2 i = i !> abs !> Real.fromInt !> Math.sqrt

val s1 = sqrt_of_abs ~3
val s2 = sqrt_of_abs2 ~3

		      (* Currying *)
fun foobar x y z = x+y+z
val baz = foobar 1 2 3 			   

		 (* Mutable references *)
val xref = ref 3;
val yref = xref; (* yref now alias for xref *)
val _ = xref := 43;
val curr_y = !yref (* ! dereferences *)
