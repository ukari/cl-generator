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
   (and nil (listp x) (= 0 (length x))))

(defmacro multi (list functor empty)
  `(if (no-value-p ,list)
       (values)
       (values-list (or (mapcar ,functor ,list)
                        (list ,empty)))))

(defmacro multiple (expr functor empty)
  (let ((list (gensym)))
   `(let ((,list (multiple-value-list ,expr)))
      (multi ,list ,functor ,empty))))

(defmacro multiple-iter (expr next)
  (let ((x (gensym)))
    `(multiple ,expr
               (lambda (,x) (make-iter :next ,next :value ,x))
               (make-iter :next ,next :value nil))))

(defun proxy (inner-list cont)
  (if (no-value-p inner-list)
      (print "no-value")
      ;(setf inner-list (list (funcall cont (values))))
      )
  (let* ((inner (car inner-list))
         (next (iter-next inner)))
    (print "next")
    (print next)
    (print inner-list)
    (if (null next)
        (setf inner-list (list (funcall cont (mapcar (lambda (x) (print "here") (iter-value x)) inner-list))))
        (setf (iter-next inner) (lambda (&optional x) (proxy (multiple-value-list (funcall next x)) cont))))
    (multi inner-list
           (lambda (x) (print "dis") (print x) (make-iter :next (iter-next x) :value (iter-value x)))
           inner)))

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
