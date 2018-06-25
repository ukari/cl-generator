(in-package :cl-generator)

(defstruct iter
  (cur nil :type function)
  (next nil :type (or null function)))

(defstruct pass
  (cont nil :type (or null function))
  (results nil :type list))

(defmethod iter-id ((end null))
  (make-iter :cur (lambda () (iter-id end))))

(defmethod iter-id ((cont function))
  (let ((iter (make-iter :cur (lambda () (iter-id cont)))))
    (setf (iter-next iter) (gen-next iter cont))
    iter))

(defmethod pass-next ((pass null)))

(defmethod pass-next ((pass pass))
  (pass-cont pass))

(defmethod gen-next ((iter iter) (cont function))
  (lambda (&optional (x nil supplied))
    (let* ((res (if supplied (funcall cont x) (funcall cont)))
           (next (gen-next iter (pass-next res))))
      (setf (iter-next iter) next)
      (setf (iter-cur iter) (lambda () (iter-id (pass-next res))))
      (values-list (pass-results res)))))

(defmethod gen-next ((iter iter) (pass pass))
  (gen-next iter (pass-cont pass)))

(defmethod gen-next ((iter iter) (end null)))

(defmacro gen-pass (expr cont)
  (let ((list (gensym)))
    `(let ((,list (multiple-value-list ,expr)))
       (make-pass :cont ,cont :results ,list))))

(defmethod proxy ((inner iter) (cont function))
  ;; (let ((iter (make-iter :cur (lambda () (proxy inner cont)))))
  ;;   (setf (iter-next iter) (iter-next inner))
  ;;   iter)
  (print inner)
  (let ((res))
    (if (null (iter-next inner))
        (setf res (multiple-value-list (funcall cont)))
        (setf res (multiple-value-list (funcall (iter-next inner)))))
    (print res)
    (if (null (iter-next inner))
        (make-pass :cont cont :results res)
        (make-pass :cont (lambda () (proxy inner cont)) :results res)))
  )

(defmacro isolate-cont (&body body)
  `(without-call/cc (iter-id (lambda () (progn ,@body)))))

(defmacro yield (&optional expr)
  (declare (ignore expr))
  (error "yield is not defined"))

(defmacro yield* (expr)
  (declare (ignore expr))
  (error "yield* is not defined"))

(defmacro local-macros (&body body)
  (let ((k1 (gensym))
        (k2 (gensym))
        (x (gensym))
        (res (gensym "res")))
    `(macrolet ((yield (&optional expr)
                  (let ((,k1 (gensym)))
                    `(call/cc (with-call/cc (lambda (,,k1) (gen-pass ,expr ,,k1))))))
                (yield* (expr)
                  (let ((,k2 (gensym))
                        (,x (gensym))
                        (,res (gensym "res")))
                    `(let ((,,res ,expr))
                       (if (eq (type-of ,,res) 'iter)
                           (call/cc (lambda (,,k2) (proxy ,,res ,,k2)))
                           (if (listp ,,res)
                               (loop for ,,x in ,,res do (yield ,,x))
                               (error "invalid yield* argument")))))))
       ,@body)))

(defmacro enable-yield (&body body)
  `(with-call/cc (gen-pass (local-macros ,@body) nil)))

(defmacro lambda* (args &body body)
  `(lambda ,args (isolate-cont (enable-yield () ,@body))))

(defmacro defun* (name args &body body)
  `(defun ,name ,args (isolate-cont (enable-yield () ,@body))))

(defmacro defmacro* (name args &body body)
  `(defmacro ,name ,args `(isolate-cont (enable-yield () ,,@body))))
