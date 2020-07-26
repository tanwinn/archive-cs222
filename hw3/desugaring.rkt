#lang racket

;Thanh Nguyen - hw3

(require "hw3_environments.rkt")

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
    ;It's not -; leave it alone
    [(eq? (first expr) 'and)
        (list 'not (list 'or 
            (map 
                (lambda (x) (list 'not (desugar x))) 
                (rest expr))))]
    [else (cons (first expr) (map desugar (rest expr)))]))

(define (interpret expr)
    (cond
        [(not (list? expr)) expr]
        [(and (eq? (first expr) '+)
            (andmap string? (rest expr)))
            (apply string-append (rest expr))]
        [(and (eq? (first expr) '+)
            (andmap integer? (rest expr)))
            (apply + (rest expr))]
        [(and 
            (eq? (first expr) '*)
            (string? (second expr))
            (integer? (third expr)))
            (let 
                ([x (make-list (third expr) (second expr))])
                (interpret (append (list '+) x)))]
        [(and 
            (eq? (first expr) '*)
            (integer? (second expr))
            (string? (third expr)))
            (interpret (list (first expr) (third expr) (second expr)))]
        [(and 
            (eq? (first expr) '*)
            (eq? (length expr) 3)
            (integer? (second expr))
            (integer? (third expr)))
            (* (second expr) (third expr))]))

(define (init-test-env)
    (define 
        env-1 
        (extend-env '(a b) '(3 2) (make-empty-env)))
    (extend-env '(a c) '(7 1) env-1))

(define (lookup-env env sym)
    (cond
        [(not (env? env)) (error "Not an environment")]
        [(empty-env? env) (error "Symbol not found")]
        [(in-assoc-list? 
            (get-env-assoc-list env) 
            sym)
            (assoc-list-get 
                (get-env-assoc-list env)
                sym)]
        [else (lookup-env (get-old-env env) sym)]))