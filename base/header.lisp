(in-package :cl-generator)

(defmacro header ()
  `(defstruct iterable-object (value nil) (next nil :type (or null function))))
