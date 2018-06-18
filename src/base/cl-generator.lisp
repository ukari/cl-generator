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

(defun no-value-p (x)
   (and (listp x) (= 0 (length x))))

(defmacro multi (list functor)
  `(if (no-value-p ,list)
       (values)
       (values-list (mapcar ,functor ,list))))

(defmacro multiple (expr functor)
  (let ((list (gensym)))
   `(let ((,list (multiple-value-list ,expr)))
      (multi ,list ,functor))))

(defmacro multiple-iter (expr next)
  (let ((x (gensym)))
    `(multiple ,expr (lambda (,x) (make-iter :next ,next :value ,x)))))

(defun proxy (inner-list cont)
  (let* ((return-list (mapcar (lambda (x) (iter-value x)) inner-list))
         (inner (car inner-list))
         (next (iter-next (or inner (make-iter :next nil :value nil)))))
    (if (null next)
        (values-list (multiple-value-list (funcall cont return-list)))
        (values-list (list (make-iter :next (lambda (&optional x) (proxy (multiple-value-list (funcall next x)) cont)) :value (iter-value inner)))))))

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
        (cont (gensym "cont")))
    `(macrolet ((yield (&optional expr)
                  (let ((,k1 (gensym)))
                    `(call/cc (with-call/cc (lambda (,,k1) (multiple-iter ,expr ,,k1))))))
                (yield* (expr)
                  (let ((,k2 (gensym))
                        (,x (gensym))
                        (,cont (gensym "cont")))
                    `(let ((,,cont ,expr))
                       (if (eq (type-of ,,cont) 'separate-continuation)
                           (values-list (call/cc (lambda (,,k2) (proxy (multiple-value-list (funcall ,,cont)) ,,k2))))
                           (if (listp ,,cont)
                               (loop for ,,x in ,,cont do (yield ,,x))
                               (error "invalid yield* argument")))))))
       ,@body)))

(defmacro enable-yield (&body body)
  `(with-call/cc (lambda () (multiple-iter (local-macros ,@body) nil))))

(defmacro lambda* (args &body body)
  `(lambda ,args (isolate-cont (enable-yield () ,@body))))

(defmacro defun* (name args &body body)
  `(defun ,name ,args (isolate-cont (enable-yield () ,@body))))

(defmacro defmacro* (name args &body body)
  `(defmacro ,name ,args `(isolate-cont (enable-yield () ,,@body))))
