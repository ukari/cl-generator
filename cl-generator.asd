(defsystem cl-generator
  :serial t
  :depends-on (cl-cont)
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
	     (:file "util")))))
