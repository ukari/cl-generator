(in-package :cl-generator-test)

(define-test lambda*-common
  (let* ((generator (lambda* (x) (yield (+ x 1))))
         (iter (funcall generator 4)))
    (assert-true (iter-p iter))
    (assert-eq 5 (funcall (iter-next iter)))
    (assert-eq "end" (funcall (iter-next iter) "end"))
    (assert-nil (iter-next iter))))

(define-test lambda*-values
  (let* ((generator (lambda* () (yield) (values 2 3)))
         (iter (funcall generator)))
    (funcall (iter-next iter))
    (assert-equal (list 2 3) (multiple-value-list (funcall (iter-next iter))))))

(define-test lambda*-no-values
  (let* ((generator (lambda* () (yield) (values)))
         (iter (funcall generator)))
    (funcall (iter-next iter))
    (assert-eq 0 (length (multiple-value-list (funcall (iter-next iter)))))))

(define-test yield-values
  (let* ((generator (lambda* () (yield (values 1 2))))
         (iter (funcall generator)))
    (assert-equal (list 1 2) (multiple-value-list (funcall (iter-next iter))))))

(define-test yield-no-values
  (let* ((generator (lambda* () (yield (values))))
         (iter (funcall generator)))
    (assert-eq 0 (length (multiple-value-list (funcall (iter-next iter)))))))

(define-test yield*
  (let* ((a (lambda* () (yield 1) (yield 2)))
         (b (lambda* () (yield* (funcall a))))
         (iter (funcall b)))
    (assert-eq 1 (funcall (iter-next iter)))
    (assert-eq 2 (funcall (iter-next iter)))
    (funcall (iter-next iter))
    (assert-nil (iter-next iter))))

(define-test yield*-common
    (let* ((a (lambda* () (yield)))
           (b (lambda* () (yield* (funcall a))))
           (iter (funcall b)))
      (funcall (iter-next iter))
      (assert-eq "end" (funcall (iter-next iter) "end"))
      (assert-nil (iter-next iter))))

(define-test yield*-return
  (let* ((a (lambda* () (yield 1) (yield 2) (values 3)))
         (b (lambda* () (yield* (funcall a))))
         (iter (funcall b)))
    (funcall (iter-next iter))
    (funcall (iter-next iter))
    (assert-eq 3 (funcall (iter-next iter)))))

(define-test yield*-return-1
  (let* ((a (lambda* () (yield 1) (yield 2) (values 3)))
         (b (lambda* () (yield* (funcall a)) 4))
         (iter (funcall b)))
    (funcall (iter-next iter))
    (funcall (iter-next iter))
    (assert-eq 4 (funcall (iter-next iter)))))

(define-test yield*-return-values
  (let* ((a (lambda* () (yield 1) (yield 2) (values 3 4)))
         (b (lambda* () (yield* (funcall a))))
         (iter (funcall b)))
    (funcall (iter-next iter))
    (funcall (iter-next iter))
    (assert-equal (list 3 4) (multiple-value-list (funcall (iter-next iter))))))

(define-test yield*-return-no-values
  (let* ((a (lambda* () (yield 1) (yield 2) (values)))
         (b (lambda* () (yield* (funcall a))))
         (iter (funcall b)))
    (funcall (iter-next iter))
    (funcall (iter-next iter))
    (assert-eq 0 (length (multiple-value-list (funcall (iter-next iter)))))))

(define-test yield-cur-copy-first
  (let* ((generator (lambda* () (yield 1) (yield 2) (yield 3)))
         (x (funcall generator))
         (y (funcall (iter-cur x))))
    (assert-eq (funcall (iter-next x)) (funcall (iter-next y)))))

(define-test yield-cur-copy-tail
  (let* ((generator (lambda* () (yield 1) (yield 2) (yield 3)))
         (x (funcall generator))
         (y))
    (funcall (iter-next x))
    (setf y (funcall (iter-cur x)))
    (assert-eq (funcall (iter-next x)) (funcall (iter-next y)))))

(define-test yield*-cur-copy-first
  (let* ((a (lambda* () (yield 1) (yield 2) (yield 3)))
         (b (lambda* () (yield* (funcall a)) (yield 4) (yield 5)))
         (x (funcall b))
         (y (funcall (iter-cur x))))
    (assert-eq (funcall (iter-next x)) (funcall (iter-next y)))))

(define-test yield*-cur-copy-tail
  (let* ((a (lambda* () (yield 1) (yield 2) (yield 3)))
         (b (lambda* () (yield* (funcall a)) (yield 4) (yield 5)))
         (x (funcall b))
         (y))
    (funcall (iter-next x))
    (setf y (funcall (iter-cur x)))
    (assert-eq (funcall (iter-next x)) (funcall (iter-next y)))))

(defun* test-defun* (x)
  (yield x))

(define-test defun*
  (let* ((x (test-defun* 0)))
    (assert-eq 0 (funcall (iter-next x)))
    (assert-eq "end" (funcall (iter-next x) "end"))))

(defmacro* test-defmacro* (f)
  `(funcall ,f (yield 5)))

(define-test defmacro*
  (let* ((x (test-defmacro* (lambda (x) (+ 1 x)))))
    (assert-eq 5 (funcall (iter-next x)))
    (assert-eq 1 (funcall (iter-next x) 0))))

(defun* fib (x y)
  (yield y)
  (yield* (fib y (+ x y))))

(defun fibonacci ()
  (fib 0 1))

(define-test functional-fibonacci
  (let* ((iter (fibonacci))
         (copy (funcall (iter-cur iter))))
    (assert-eq 1 (funcall (iter-next iter)))
    (assert-eq 1 (funcall (iter-next iter)))
    (assert-eq 2 (funcall (iter-next iter)))
    (assert-eq 3 (funcall (iter-next iter)))
    (assert-eq 5 (funcall (iter-next iter)))
    (assert-eq 1 (funcall (iter-next copy)))
    (assert-eq 1 (funcall (iter-next copy)))
    (assert-eq 2 (funcall (iter-next copy)))
    (assert-eq 3 (funcall (iter-next copy)))
    (assert-eq 5 (funcall (iter-next copy)))
    (assert-eq 8 (funcall (iter-next iter)))
    (setf copy (funcall (iter-cur iter)))
    (assert-eq 13 (funcall (iter-next copy)))))
