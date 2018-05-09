(in-package :cl-generator)

(header)

(defmacro yield (&optional expr)
  (let ((k (gensym))
        (x (gensym))
        (list (gensym "list")))
    `(let ((,list (multiple-value-list ,expr)))
       (print ,list)
       (call/cc (lambda (,k) (values-list (or (mapcar (lambda (,x) (make-iterable-object :next ,k :value ,x))
                                                                    ,list)
                                                            (list (make-iterable-object :next ,k :value nil)))))))))

(defmacro lambda* (args &body body)
  (let ((x (gensym)))
    `(lambda ,args
       (with-call/cc
	 (lambda () (values-list (or (mapcar (lambda (,x) (make-iterable-object :next nil :value ,x))
                                             (multiple-value-list (progn ,@body)))
                                     (list (make-iterable-object :next nil :value nil)))))))))

(defmacro lambda-yield (&body body)
  (let ((x (gensym)))
    `(with-call/cc
       (lambda () (values-list (or (mapcar (lambda (,x) (make-iterable-object :next nil :value ,x))
                                           (multiple-value-list (progn ,@body)))
                                   (list (make-iterable-object :next nil :value nil))))))))

(defmacro defun* (name args &body body)
  `(defun ,name ,args (lambda-yield () ,@body)))

(defmacro defmacro* (name args &body body)
  `(defmacro ,name ,args (list 'lambda-yield () ,@body)))

(defmacro yield* (expr)
  (let ((x (gensym "x"))
        (cont (gensym "cont")))
    `(let ((,cont ,expr))
       (if (eq (type-of ,cont) 'funcallable/cc)
           (funcall ,cont)
           (if (listp ,cont)
               (loop for ,x in ,cont do (yield ,x))
               (error "invalid yield* argument"))))))



;(defun* a () (yield 1) (yield 2) (values 3 4 5))

;(defun* b () (yield (yield* (a))))
;; 1 2 {3 4 5}

;(defun* c () (yield* (a)))
;; 1 2 
