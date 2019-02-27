(in-package :cl-user)

(defpackage cl-generator
  (:nicknames generator)
  (:use cl)
  (:import-from cl-cont
		#:with-call/cc
                #:without-call/cc
		#:call/cc)
  (:export #:iter
           #:iter-next
           #:iter-cur
           #:iter-p
           #:with-yield
           #:lambda*
	   #:defun*
	   #:defmacro*
           #:defmethod*
	   #:yield
           #:yield*))
