(in-package :cl-user)

(defpackage cl-generator
  (:nicknames generator)
  (:use cl)
  (:import-from cl-cont
		#:with-call/cc
		#:call/cc)
  (:export #:lambda*
	   #:defun*
	   #:defmacro*
	   #:yield))
