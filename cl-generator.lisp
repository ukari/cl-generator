(in-package :cl-generator)

(defmacro yield (&rest args)
  (let ((x (gensym)))
    `(cl-cont:call/cc (lambda (,x) (values ,x ,@args)))))

(defmacro lambda* (init &rest form)
  `(cl-cont:with-call/cc (lambda ,init (values nil ,@form))))

(defmacro defun* (name init &rest form)
  `(defun ,name ,init (lambda* () ,@form)))
