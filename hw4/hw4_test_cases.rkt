#lang racket

;A few test cases that could be helpful for you
;Feel free to test more than just these

;Test case for #1
;should output 8
(let ([x 5])
  (let ([f (lambda (y) (+ x y))])
    (let ([x 7])
      (f 3))))

;Test case for #2
;should output 3
(let ([b (box 0)])
  (+ (begin (set-box! b (+ 1 (unbox b)))
        (unbox b))
      (begin (set-box! b (+ 1 (unbox b)))
            (unbox b))))

(if (and (eq? (first '(box 3)) 'box) (= (length '(box 3)) 2)) (make-pointer (cdr (store-alloc (make-empty-store) (second '(box 3))))) 0)
