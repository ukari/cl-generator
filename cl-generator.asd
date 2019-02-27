(defsystem cl-generator
  :description "cl-generator, a generator implementation for common lisp"
  :author "Muromi Ukari"
  :license "MIT"
  :version "1.3.0"
  :homepage "https://github.com/ukari/cl-generator"
  :serial t
  :depends-on (cl-cont)
  :pathname "src/"
  :components
  ((:module "base"
	    :serial t
	    :components
	    ((:file "package")
	     (:file "cl-generator")))
   (:module "util"
            :serial t
            :components
            ((:file "package")
             (:file "util")))
   ))
