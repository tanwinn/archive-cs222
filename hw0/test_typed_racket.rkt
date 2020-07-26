#lang typed/racket
(define (triple [x : Number]) : Number
    (+ x x x))
