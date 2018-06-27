(in-package :cl-generator-util)

(defmacro for (expr &body body)
  (let* ((var (car `,expr))	 
         (generator (eval (cadr `,expr)))
         (iter (gensym "iter")))
    `(let ((,iter ,generator))
       (labels ((f (,var)
                  ,@body
                  (if (not (null (iter-next ,iter)))
                      (let ((res (funcall (iter-next ,iter))))
                        (if (not (null (iter-next ,iter)))
                            (f res))))))
         (f (funcall (iter-next ,iter)))))))

