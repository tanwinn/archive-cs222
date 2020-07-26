#lang racket

(require "hw3_environments.rkt")

;Problem 1
;Desugar - and cond
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
    ;and
    [(eq? (first expr) 'and)
        (list 'not (cons 'or (map (lambda (x) (list 'not x))
                                (map desugar (rest expr)))))]
    ;It's not sugar; leave it alone
    [else (cons (first expr) (map desugar (rest expr)))]))

;Problem 2
;zip two strings together
;args should have same length
(define (zip str1 str2)
    (define (zip-helper so-far str1-left str2-left)
        (cond
            [(= (string-length str1-left) 0) so-far]
            [else (zip-helper (string-append so-far
                                (substring str1-left 0 1)
                                (substring str2-left 0 1))
                        (substring str1-left 1)
                        (substring str2-left 1))]))
    (zip-helper "" str1 str2))

;repeat a string a fixed number of times
(define (repeat-string str times)
    (cond
        [(= times 0) ""]
        [(< times 0)
            (error "Can't repeat a string a negative number of times")]
        [else (string-append str (repeat-string str (- times 1)))]))

;stracket interpreter
(define (stracket-interpret expr)
    (cond
        ;Is it a string?
        [(string? expr) expr]
        ;Is it an integer?
        [(integer? expr) expr]
        ;Not a list is now an error
        [(not (list? expr)) (error "Invalid syntax")]
        ;In this case, interpret recursively
        [else (let ([interp-rest (map stracket-interpret (rest expr))]
                    [head (first expr)])
            (cond
                ;+ operation on strings
                [(and (eq? head '+) (andmap string? interp-rest))
                    (apply string-append interp-rest)]
                ;+ operation on integers
                [(and (eq? head '+) (andmap integer? interp-rest))
                    (apply + interp-rest)]
                ;* on wrong length
                [(and (eq? head '*) (not (= (length expr) 3)))
                    (error "* takes 2 arguments")]
                ;* operation on integers
                [(and (eq? head '*) (andmap integer? interp-rest))
                    (apply * (rest expr))]
                ;* operation on strings
                [(and (eq? head '*) (andmap string? interp-rest))
                    (apply zip (rest expr))]
                ;* operation on int then string
                [(and (eq? head '*) (and (integer? (first interp-rest))
                                            (string? (second interp-rest))))
                    (repeat-string (second interp-rest)
                                    (first interp-rest))]
                ;* operation on string then int
                [(and (eq? head '*) (and (string? (first interp-rest))
                                            (integer? (second interp-rest))))
                    (repeat-string (first interp-rest)
                                    (second interp-rest))]
                ;else error
                [else (error "Invalid syntax")]))]))

;Problem 3
;Test environment
(define (test-env)
    (let* ([env1 (make-empty-env)]
            [env2 (extend-env '(a b) '(3 2) env1)]
            [env3 (extend-env '(a c) '(1 7) env2)])
            env3))

;Look-up in environment
(define (lookup-env env sym)
    (cond
        ;Check 1: is it an environment?
        [(not (env? env)) (error "Environment expected")]
        ;Check 2: is it empty?
        [(empty-env? env) (error "Unbound variable")]
        ;Check 3: is it in the outermost associative list?
        [(in-assoc-list? (get-env-assoc-list env) sym)
            (assoc-list-get (get-env-assoc-list env) sym)]
        ;None of the above. Dig deeper
        [else (lookup-env (get-old-env env) sym)]))
