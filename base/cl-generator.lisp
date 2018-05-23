(in-package :cl-generator)

(header)

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
;;(defun* a () (yield 2) (yield 3))
;;(defun* test () (yield* (a)) (print "hi"))

(defun proxy (inner-list cont)
  (let ((inner (car inner-list)))
    (let ((next (iterable-object-next inner)))
      (if (null next)
          (setf inner (funcall cont (mapcar (lambda (x) (iterable-object-value x)) inner-list)))
          (setf (iterable-object-next inner) (lambda (&optional x) (proxy (multiple-value-list (funcall next x)) cont))))
      (multi inner-list
             (lambda (x) (make-iterable-object :next (iterable-object-next inner) :value (iterable-object-value x)))
             inner))))

(defmacro yield (&optional expr)
  (let ((k (gensym))
        (x (gensym)))
    `(call/cc (with-call/cc (lambda (,k) (multiple ,expr
                                                   (lambda (,x) (make-iterable-object :next ,k :value ,x))
                                                   (make-iterable-object :next ,k :value nil)))))))

(defmacro lambda* (args &body body)
  (let ((x (gensym)))
    `(isolate-cont
       (lambda ,args
         (with-call/cc
           (lambda () (multiple (progn ,@body)
                                (lambda (,x) (make-iterable-object :next nil :value ,x))
                                (make-iterable-object :next nil :value nil))))))))

(defmacro lambda-yield (&body body)
  (let ((x (gensym)))
    `(with-call/cc
       (lambda () (multiple (progn ,@body)
                            (lambda (,x) (make-iterable-object :next nil :value ,x))
                            (make-iterable-object :next nil :value nil))))))

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



;; (defun* a () (yield 1) (yield 2) (values 3 4 5))

;; (defun* b () (yield (yield* (a))))
;; 1 2 {3 4 5}

;; (defun* c () (yield* (a)))
;; 1 2


;; (defun* a () (yield 1) (yield 2) (values 3 4 5))
;; (defun* b () (funcall (a)) (print "hi"))
;; (defun c () (print (funcall (b))) nil)
