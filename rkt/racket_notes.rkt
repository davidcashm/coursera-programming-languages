#lang racket
; This is a comment

; Automatically exports all definitions
(provide (all-defined-out))

; Define a variabe
(define s "hello")

; Arithmetic
(+ 2 2)

(define x 3)
(define y (+ x 2))

; Define a function
(define cube1
  (lambda (x)
    (* x x x))) ; * takes any number of arguments

; Syntactic sugar for lambda:
(define (cube2 x)
  (* x x x))

(define (pow1 x y)
  (if (= y 0)
      1
      (* x (pow1 x (- y 1)))))

(define nullval null) ; Empty list
(define alist (list 1 2 3))
(define blist (cons 0 alist))
(if (null? alist) "empty" (car alist))
(if (list? alist) "I'm a list" "I'm not a list")

; Note: any value other than #f is treated as true (even null, 0, etc.)
(define (checktype val)
  (cond [(number? val) "I'm a number"]
        [(list? val) "I'm a list"]
        [#t "I don't know what I am"]))

; Normal let: e2 doesn't look at e1 bindings
; let ((v1 e1) (v2 e2) ...) body

; let* is the same except that subsequent let assignments
; do look at previous bindings.  (Equivalent to nesting let statements)

; letrec allows mutual recursion - all variables enter namespace
; before expression are evaluated

; Can also use local define statements instead of let to define local functions

(define foo 5)
(set! foo 3)
foo

; Can create any pair with cons, not just lists as second argument:
(define apair (cons 1 2))

; Pairs and lists are immutable.  Need mcons to create mutable lists.
; But normal list functions won't work on mutable lists
(define mpr (mcons 1 (mcons #t "hi")))
(mcar mpr)
(mcdr mpr)
(set-mcdr! mpr (mcons 1 47))
(set-mcar! mpr 12)

; Macros
(define-syntax my-if
  (syntax-rules (then else)
    [(my-if e1 then e2 else e3) (if e1 e2 e3)]
    [(my-if e1 then e2) (if e1 e2 #f)]))
