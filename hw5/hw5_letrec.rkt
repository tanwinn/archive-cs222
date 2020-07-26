#lang racket

;Desugar the letrec's in this program
(letrec
    ([f (lambda (x)
          (if (< x 1)
              1
              (* 2 (g (- x 1)))))]
    [g (lambda (x)
          (+ 1 (f (- x 1))))])
  (letrec
      ([h (lambda (x)
            (if (< x 1)
                1
                (+ (f x)
                   (* x (h (- x 1))))))])
    (f (h 4))))
