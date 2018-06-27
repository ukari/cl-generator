(defsystem cl-generator-test
  :description "unit tests for cl-generator"
  :author "Muromi Ukari"
  :license "MIT"
  :serial t
  :depends-on (lisp-unit cl-generator)
  :pathname "t/"
  :components
  ((:file "package")
   (:file "base")
   (:file "util")))
