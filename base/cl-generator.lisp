(in-package :cl-generator)

(header)

(defmacro yield (&optional arg)
  (let ((x (gensym)))
    `(call/cc (lambda (,x) (make-iterable-object :next ,x :value ,arg)))))

(defmacro lambda* (args &body body)
  `(lambda ,args
       (with-call/cc
	 (lambda ()
	   (make-iterable-object :next nil :value (progn ,@body))))))

(defmacro lambda-yield (&body body)
  `(with-call/cc
       (lambda ()
	 (make-iterable-object :next nil :value (progn ,@body)))))

(defmacro defun* (name args &body body)
  `(defun ,name ,args (lambda-yield () ,@body)))

(defmacro defmacro* (name args &body body)
  `(defmacro ,name ,args (list 'lambda-yield () ,@body)))


