(in-package :cl-generator)

(defmacro yield (&rest args)
  (let ((x (gensym)))
    `(cl-cont:call/cc (lambda (,x) (values ,x ,@args)))))

(defmacro lambda* (init &body body)
  `(cl-cont:with-call/cc (lambda ,init (values nil ,@body))))

(defmacro defun* (name args &body body)
  `(defun ,name ,args (lambda* () ,@body)))

(defmacro defmacro* (name args &body body)
  `(defmacro ,name ,args (list 'lambda* () ,@body)))
