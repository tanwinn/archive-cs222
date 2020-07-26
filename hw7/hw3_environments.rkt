#lang racket

;Associative lists
(provide make-empty-assoc-list empty-assoc-list? assoc-list?)
(provide assoc-list-syms assoc-list-vals assoc-list-get)
(provide in-assoc-list? make-assoc-list)

;Associative lists

;Empty associative list
(define (make-empty-assoc-list) (cons null null))

;Associative list constructor
(define (make-assoc-list syms vals)
  (cond
    ;Do the lists have the same length?
    [(not (= (length syms) (length vals)))
      (error "Lists must have same length")]
    ;Does the syms list have duplicates?
    [(check-duplicates syms)
      (error "Symbols list must not contain duplicates")]
    ;Ok, good to go!
    [else (cons syms vals)]))

;Is it the empty associative list?
(define (empty-assoc-list? L)
  (cond
    [(equal? L (make-empty-assoc-list)) #t]
    [else #f]))

;Is it an associative list?
(define (assoc-list? L)
  (cond
    ;Positive base case: It's the empty associative list
    [(empty-assoc-list? L) #t]
    ;Negative base case: It's not a pair
    [(not (pair? L)) #f]
    ;Negative base case: car is not a list
    [(not (list? (car L))) #f]
    ;Negative base case: cdr is not a list
    [(not (list? (cdr L))) #f]
    ;Negative base case: one half of L is empty
    [(or (null? (car L)) (null? (cdr L))) #f]
    ;Negative base case: there are duplicates among the symbols
    [(check-duplicates (car L)) #f]
    ;Recursive step: Is the first symbol actually a symbol,
    ;and is the rest an associative list?
    [else (and (symbol? (caar L))
                (assoc-list? (cons (cdar L) (cddr L))))]))

;Get the symbols of the associative list L
(define (assoc-list-syms L)
  (car L))

;Get the values of the associative list L
(define (assoc-list-vals L)
  (cdr L))

;Get the associated value to sym in associative list L
(define (assoc-list-get L sym)
  ;Give the symbols and values names for ease of reference
  (let
    ([syms (assoc-list-syms L)]
    [vals (assoc-list-vals L)])
    (cond
      ;Negative base case: Is the list empty?
      [(empty-assoc-list? L) (error (format "symbol not in list: ~a" sym))]
      ;Positive base case: Is the queried symbol at the head?
      ;If so, get the value
      [(equal? (first syms) sym) (first vals)]
      ;Recursive case: Look in the rest of the associative list
      [else (assoc-list-get (cons (rest syms) (rest vals)) sym)])))

;Is the given symbol in the associative list?
(define (in-assoc-list? L sym)
  (if (member sym (assoc-list-syms L))
        #t
        #f))

;Environments

(provide make-empty-env extend-env empty-env? env?)
(provide extended-env? get-env-assoc-list get-old-env)

;Create an empty environment
(define (make-empty-env) 'empty-env)

;Extend the given environment with the given associative list
(define (extend-env syms vals old-env)
    (cons (make-assoc-list syms vals) old-env))

;Is the given thing an empty environment?
(define (empty-env? env)
    (equal? env (make-empty-env)))

;Is the given thing an extended environment?
(define (extended-env? env)
    (and
        ;Is it a pair?
        (pair? env)
        ;Is the car an associative list?
        (assoc-list? (car env))
        ;Is the cdr an environment?
        (or (empty-env? (cdr env)) (extended-env? (cdr env)))))

;Is the given thing an environment?
(define (env? env)
    (or (empty-env? env) (extended-env? env)))

;Get the associative list from the environment
(define (get-env-assoc-list env)
    (cond
        ;Was an extended environment passed?
        [(not (extended-env? env))
            (error (format "Extended environment expected, received ~a"
                            env))]
        [else (car env)]))

;Get the old environment from the environment
(define (get-old-env env)
    (cond
        ;Was an extended environment passed?
        [(not (extended-env? env))
        (error (format "Extended environment expected, received ~a"
                        env))]
        [else (cdr env)]))
