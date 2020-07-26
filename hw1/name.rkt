#lang racket
;A person "class"
;Create a person "object" using (define x (person fname lname))
;where x is the variable name holding the person
;fname and lname are strings, the first and last name
;To ask person x for their first name, do (x 'first)
;To ask person x for their last name, do (x 'last)
;To ask person x for their full name, do (x 'name)
(define (person firstname lastname)
    (lambda (message)
        (cond
            [(equal? message 'first) firstname]
            [(equal? message 'last) lastname]
            [(equal? message 'name)
                (string-append firstname " " lastname)])))

;Example code
;Uncomment to use
;(define me (person "Nathan" "Fox"))
;(me 'first) ;Outputs "Nathan"
;(me 'last) ;Outputs "Fox"
;(me 'name) ;Outputs "Nathan Fox"
