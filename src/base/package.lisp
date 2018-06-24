(in-package :cl-user)

(defpackage cl-generator
  (:nicknames generator)
  (:use cl)
  (:import-from cl-cont
		#:with-call/cc
                #:without-call/cc
		#:call/cc)
  (:import-from closer-mop
                #:funcallable-standard-class
                #:set-funcallable-instance-function)
  (:export #:iter-next
           #:iter-cur
           #:iter-p
           #:lambda*
	   #:defun*
	   #:defmacro*
	   #:yield
           #:yield*))
