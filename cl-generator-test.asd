(defsystem cl-generator-test
  :description "unit tests for cl-generator"
  :author "Muromi Ukari"
  :license "MIT"
  :version "1.1.0"
  :homepage "https://github.com/ukari/cl-generator"
  :serial t
  :depends-on (lisp-unit cl-generator)
  :pathname "t/"
  :components
  ((:file "package")
   (:file "base")
   (:file "util")))
