#lang racket

;Desugaring example from class
;Lexically replace (- a b) with (- a (* -1 b))
(define (desugar expr)
  (cond
    ;Base case: an atom
    [(not (list? expr)) expr]
    ;If we have a 3-item list with -
    ;do that replacement
    [(and (eq? (first expr) '-)
                (= (length expr) 3))
      (list '+ (desugar (second expr))
            (list '* -1 (desugar (third expr))))]
    ; Q1
    [(and (eq? (first expr) '-)
                (= (length expr) 2))
      (list '* -1 (desugar (second expr)))]
    ; Q2
    [(and (eq? (first expr) 'define) (= (length expr) 3))
      (list 'define (first (second expr)) (list 'lambda (rest (second expr)) (third expr)))]
    ; Q3
    [(and (eq? (first expr) 'cond) (>= (length expr) 4))
      (list 'if (desugar (rest expr)))]
    [(= (length expr) 2)
      ]
    ;It's not -; leave it alone
    [else (cons (first expr) (map desugar (rest expr)))]))
