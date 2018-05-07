(in-package :cl-generator-util)

(cl-generator:header)

(defmacro for (expr &body body)
  (let* ((var (car `,expr))	 
         (generator (eval (cadr `,expr)))
         (iter (gensym "iter")))
    `(let ((,iter (funcall ,generator)))
       (labels ((f (,var)
                  ,@body
                  (setf ,iter (funcall (iterable-object-next ,iter)))
                  (if (not (null (iterable-object-next ,iter)))
                      (f (iterable-object-value ,iter)))))
         (f (iterable-object-value ,iter))))))

