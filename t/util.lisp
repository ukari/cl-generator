(in-package :cl-generator-test)

(defun* test-numbers ()
  (let ((i 0))
    (loop while (< i 10)
       do (yield (values i (* 2 i)))
         (incf i))))

(define-test for
  (let ((collect0 nil)
        (collect1 nil))
    (for (x y (test-numbers))
      (setf collect0 (append collect0 (list x)))
      (setf collect1 (append collect1 (list y))))
    (assert-equal (list 0 1 2 3 4 5 6 7 8 9) collect0)
    (assert-equal (list 0 2 4 6 8 10 12 14 16 18) collect1)))
