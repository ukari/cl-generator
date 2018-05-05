(in-package :cl-generator)

(defmacro yield (&rest args)
  (let ((x (gensym)))
    `(call/cc (lambda (,x) (values ,x ,@args)))))

(defmacro lambda* (args &body body)
  (let ((dmz (gensym)))
    `(lambda ,args
       (with-call/cc
	 (lambda (&rest ,dmz)
	   (declare (ignore ,dmz))
	   (values nil ,@body))))))

(defmacro lambda-yield (args &body body)
  (let ((dmz (gensym)))
    `(with-call/cc
       (lambda (,@args &rest ,dmz)
	 (declare (ignore ,dmz))
	 (values nil ,@body)))))

(defmacro defun* (name args &body body)
  `(defun ,name ,args (lambda-yield () ,@body)))

(defmacro defmacro* (name args &body body)
  `(defmacro ,name ,args (list 'lambda-yield () ,@body)))

