(in-package :cl-generator)

(defstruct iter
  (value nil)
  (next nil :type (or null function)))

(defclass separate-continuation ()
  ((function :initarg :function))
  (:metaclass c2mop:funcallable-standard-class))

(defmacro isolate-cont (&body body)
  (let ((instance (gensym)))
    `(let ((,instance (make-instance 'separate-continuation)))
       (set-funcallable-instance-function ,instance (without-call/cc (lambda () (funcall ,@body))))
       ,instance)))

(defmacro multi (list functor empty)
  `(values-list (or (mapcar ,functor ,list)
                    (list ,empty))))

(defmacro multiple (expr functor empty)
  (let ((list (gensym)))
   `(let ((,list (multiple-value-list ,expr)))
      (multi ,list ,functor ,empty))))

(defun proxy (inner-list cont)
  (let* ((inner (car inner-list))
         (next (iter-next inner)))
    (if (null next)
        (setf inner (funcall cont (mapcar (lambda (x) (iter-value x)) inner-list)))
        (setf (iter-next inner) (lambda (&optional x) (proxy (multiple-value-list (funcall next x)) cont))))
    (multi inner-list
           (lambda (x) (make-iter :next (iter-next inner) :value (iter-value x)))
           inner)))

(defmacro yield (&optional expr)
  (let ((k (gensym))
        (x (gensym)))
    `(call/cc (with-call/cc (lambda (,k) (multiple ,expr
                                                   (lambda (,x) (make-iter :next ,k :value ,x))
                                                   (make-iter :next ,k :value nil)))))))

(defmacro lambda-yield (&body body)
  (let ((x (gensym)))
    `(with-call/cc
       (lambda () (multiple (progn ,@body)
                            (lambda (,x) (make-iter :next nil :value ,x))
                            (make-iter :next nil :value nil))))))

(defmacro lambda* (args &body body)
  `(lambda ,args (isolate-cont (lambda-yield () ,@body))))

(defmacro defun* (name args &body body)
  `(defun ,name ,args (isolate-cont (lambda-yield () ,@body))))

(defmacro defmacro* (name args &body body)
  `(defmacro ,name ,args (list 'isolate-cont (list 'lambda-yield () ,@body))))

(defmacro yield* (expr)
  (let ((k (gensym))
        (x (gensym))
        (cont (gensym "cont")))
    `(let ((,cont ,expr))
       (if (eq (type-of ,cont) 'separate-continuation)
           (values-list (call/cc (lambda (,k) (proxy (multiple-value-list (funcall ,cont)) ,k))))
           (if (listp ,cont)
               (loop for ,x in ,cont do (yield ,x))
               (error "invalid yield* argument"))))))
