(in-package :cl-generator)

(header)

(defmacro yield (&optional arg)
  (let ((x (gensym)))
    `(call/cc (lambda (,x) (make-iterable-object :next ,x :value ,arg)))))

(defmacro lambda* (args &body body)
  (let ((dmz (gensym)))
    `(lambda ,args
       (with-call/cc
	 (lambda (&rest ,dmz)
	   (declare (ignore ,dmz))
	   (make-iterable-object :next nil :value ,@body))))))

(defmacro lambda-yield (args &body body)
  (let ((dmz (gensym)))
    `(with-call/cc
       (lambda (,@args &rest ,dmz)
	 (declare (ignore ,dmz))
	 (make-iterable-object :next nil :value ,@body)))))

(defmacro defun* (name args &body body)
  `(defun ,name ,args (lambda-yield () ,@body)))

(defmacro defmacro* (name args &body body)
  `(defmacro ,name ,args (list 'lambda-yield () ,@body)))

