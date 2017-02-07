fun is_older (d1: int*int*int, d2: int*int*int) =
  #1 d1 < #1 d2 orelse
  (#1 d1 = #1 d2 andalso
   (#2 d1 < #2 d2 orelse
    (#2 d1 = #2 d2 andalso #3 d1 < #3 d2)));

fun number_in_month (ds : (int*int*int) list, m : int) =
  if null ds
  then 0
  else let val v = if #2 (hd ds) = m then 1 else 0
           val rest = number_in_month (tl ds, m) in
	   v + rest end;

fun number_in_months (ds : (int*int*int) list, ms : int list) =
  if null ms
  then 0
  else (number_in_month(ds, hd ms) + number_in_months(ds, tl ms));

fun dates_in_month (ds : (int*int*int) list, m : int) =
  if null ds
  then []
  else let val d = hd ds in
	   if #2 d = m then
	       d :: dates_in_month(tl ds, m)
	   else
	       dates_in_month(tl ds, m)
       end;

fun dates_in_months (ds : (int*int*int) list, ms : int list) =
  if null ms
  then []
  else (dates_in_month(ds, hd ms) @ dates_in_months(ds, tl ms));

fun get_nth (strs : string list, n : int) =
  if n = 1
  then hd strs
  else get_nth (tl strs, n-1)

val months = ["January", "February", "March", "April",
	     "May", "June", "July", "August", "September", "October", "November", "December"]
val days = [31,28,31,30,31,30,31,31,30,31,30,31]

fun date_to_string (d : int*int*int) =
  get_nth(months, #2 d) ^ " " ^ Int.toString(#3 d) ^ ", " ^ Int.toString(#1 d)


fun number_before_reaching_sum (sum : int, ns : int list) =
  if hd ns >= sum
  then 0
  else 1 + number_before_reaching_sum (sum - hd(ns), tl(ns))

fun what_month (d : int) =
  1 + number_before_reaching_sum(d, days)

fun month_range (d1 : int, d2 : int) =
  if d1 > d2 then [] else
  let fun enumerate(from : int) =
	if from = d2 then [what_month d2] else (what_month from) :: enumerate(from+1)
  in enumerate(d1)
  end
      
fun oldest (ds : (int*int*int) list) =
  if null ds then NONE
  else let val rest_oldest = oldest (tl ds)
           val curr = hd ds in
	   if not (isSome rest_oldest) orelse is_older(curr, valOf rest_oldest)
	   then SOME curr
	   else rest_oldest
       end
