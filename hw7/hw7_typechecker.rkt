#lang racket

;Given a quoted racket expression, statically check its type
;Gives a type or an error
;Only supports integers (int) and booleans (bool)
;Only support + on two integers, = on two integers, and not on one boolean
(define (type-check expr)
  (cond
    ;Check for function type
    [(eq? expr '=) '(-> int int bool)]
    [(eq? expr '+) '(-> int int int)]
    [(eq? expr 'not) '(-> bool bool)]
    ;Check for atomic integer or boolean
    [(integer? expr) 'int]
    [(boolean? expr) 'bool]
    ;Not-list catch-all error case
    [(not (list? expr)) (error (format "Invalid syntax: ~a" expr))]
    ;Expression is of form (f a b c ...)
    ;Typecheck recursively
    [else
      ;Extract the function type we're applying
      (let ([func-type (type-check (first expr))])
        (cond
          ;Make sure it's actually a function type
          [(not (list? func-type))
            ;If not, error, since can't apply non-function type like a function
            (error (format "Can't apply non-function type: ~a [~a]"
                           expr
                           func-type))]
          ;Success case: It's a function type
          ;with the right number of arguments being applied to it
          [(= (length func-type) (+ (length expr) 1))
            ;Figure out what types were passed
            ;and retrieve the types that were expected to be passed
            (let ([rec-type-checks (map type-check (rest expr))]
                  ;take is a built-in Racket function that extracts
                  ;a prefix of a list of a given length
                  ;For example, (take '(1 2 3 4) 2) outputs '(1 2)
                  [expected-types (rest (take func-type (length expr)))])
              (if
                ;Check if the expected types match the received types
                (equal? rec-type-checks expected-types)
                ;If yes, type of expression is return type of function
                (last func-type)
                ;If no, that's a type error
                (error (format "~a failed to typecheck: ~a [expected ~a; got ~a]"
                               (first expr)
                               expr
                               expected-types
                               rec-type-checks))))]
          ;Fail case: Passed the wrong number of arguments to a function
          [else
            (error
              (format "Wrong number of arguments passed to function: ~a ~a"
                      expr
                      func-type))]))]))
