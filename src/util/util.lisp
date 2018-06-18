(in-package :cl-generator-util)

(defmacro for (expr &body body)
  (let* ((var (car `,expr))	 
         (generator (eval (cadr `,expr)))
         (iter (gensym "iter")))
    `(let ((,iter (funcall ,generator)))
       (labels ((f (,var)
                  ,@body
                  (setf ,iter (funcall (iter-next ,iter)))
                  (if (not (null (iter-next ,iter)))
                      (f (iter-value ,iter)))))
         (f (iter-value ,iter))))))

