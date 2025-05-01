#lang racket

(require
  crypto
  crypto/all

  racket/serialize)

(use-all-factories!)

(struct wallet (private-key-datum public-key-datum) #:prefab)

(define (wallet-private-key w)
  (datum->pk-key (wallet-private-key-datum w)
                 'PrivateKeyInfo))

(define (wallet-public-key w)
  (datum->pk-key (wallet-public-key-datum w)
                 'SubjectPublicKeyInfo))

(define (make-wallet #:key-size [key-size 2048])
  (let* ([priv (generate-private-key 'rsa `((nbits ,key-size)))]
         [pub  (pk-key->public-only-key priv)])
    (wallet
     (pk-key->datum priv 'PrivateKeyInfo)
     (pk-key->datum pub  'SubjectPublicKeyInfo))))

(define (serialize-object obj)
  (serialize obj))

(define (deserialize-object sexp)
  (deserialize sexp))

(define (save-wallet w filepath)
  (call-with-output-file filepath
    (λ (out) (write (serialize-object w) out))
    #:exists 'replace))

(define (load-wallet filepath)
  (call-with-input-file filepath
    (λ (in) (deserialize-object (read in)))))

; Export everything for now to make testing and API exploration easy;
; we’ll trim this to the minimal public interface later.
(provide (struct-out wallet)
         wallet-private-key
         wallet-public-key
         make-wallet
         serialize-object
         deserialize-object
         save-wallet
         load-wallet)
