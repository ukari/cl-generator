(in-package :cl-generator-test)

(defun* test-numbers ()
  (let ((i 0))
    (loop while (< i 10)
       do (yield i)
         (incf i))))

(define-test for
  (let ((collect nil))
    (for (x (test-numbers)) (setf collect (append collect (list x))))
    (assert-equal (list 0 1 2 3 4 5 6 7 8 9) collect)))
