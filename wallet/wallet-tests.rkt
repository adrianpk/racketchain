#lang racket

(require
  rackunit
  (file "wallet.rkt"))

(module+ test
  (define w (make-wallet #:key-size 512))
  (check-true (wallet? w)
              "wallet? should recognize a wallet struct")

  (define serialized (serialize-object w))
  (define w2         (deserialize-object serialized))
  (check-true (equal? w w2)
              "Deserialized wallet should equal original")

  (define test-file "temp-wallet.dat")
  (save-wallet w test-file)
  (define w3 (load-wallet test-file))
  (check-true (equal? w w3)
              "Loaded wallet should equal original after save")

  (delete-file test-file))
