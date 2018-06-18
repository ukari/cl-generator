(defsystem cl-generator-test
  :serial t
  :depends-on (lisp-unit cl-generator)
  :pathname "t/"
  :components
  ((:file "package")
   (:file "base")
   (:file "util")))
