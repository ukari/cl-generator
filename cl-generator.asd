(defsystem cl-generator
  :description "cl-generator, a generator implementation for common lisp"
  :author "Muromi Ukari"
  :license "MIT"
  :serial t
  :depends-on (cl-cont cl-annot closer-mop)
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
