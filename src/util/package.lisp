(in-package :cl-user)

(defpackage cl-generator-util
  (:nicknames generator-util)
  (:use cl)
  (:import-from cl-generator
                #:iter-next
                #:iter-value)
  (:export #:for))
