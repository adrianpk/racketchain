#lang racket

(require racket/crypto
         racket/serialize)

(struct wallet (private-key public-key) #:prefab)

(define (make-wallet #:key-size [key-size 2048])
  (define private-key
    (generate-private-key 'rsa
                          (list (list 'nbits key-size))))
  (define public-key
    (pk-key->public-only-key private-key))
  (wallet private-key public-key))

(provide wallet make-wallet)
