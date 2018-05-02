(in-package :cl-generator)

(defmacro yield (&rest args)
  (let ((x (gensym)))
    `(cl-cont:call/cc (lambda (,x) (values ,x ,@args)))))

(defmacro lambda* (init &rest form)
  `(cl-cont:with-call/cc (lambda ,init ,@form nil)))
