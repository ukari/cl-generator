(in-package :cl-generator-util)

(defmacro for (expr &body body)
  (let* ((vars (reverse (cdr (reverse `,expr))))
         (generator (eval (car (last `,expr))))
         (iter (gensym "iter")))
    `(let ((,iter ,generator))
       (labels ((f (,@vars)
                  ,@body
                  (if (not (null (iter-next ,iter)))
                      (let ((res (multiple-value-list (funcall (iter-next ,iter)))))
                        (if (not (null (iter-next ,iter)))
                            (apply #'f res))))))
         (apply #'f (multiple-value-list (funcall (iter-next ,iter))))))))

