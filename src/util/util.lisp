(in-package :cl-generator-util)

(defmacro for (expr &body body)
  (let* ((var (car `,expr))	 
         (generator (eval (cadr `,expr)))
         (iter (gensym "iter")))
    `(let ((,iter ,generator))
       (labels ((f (,var)
                  ,@body
                  (if (not (null (iter-next ,iter))) (f (funcall (iter-next ,iter))))))
         (f (funcall (iter-next ,iter)))))))

