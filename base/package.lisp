(in-package :cl-user)

(defpackage cl-generator
  (:nicknames generator)
  (:use cl)
  (:import-from cl-cont
		#:with-call/cc
		#:call/cc)
  (:shadowing-import-from cl-cont #:funcallable/cc)
  (:export #:header
           #:lambda*
	   #:defun*
	   #:defmacro*
	   #:yield
           #:yield*))
