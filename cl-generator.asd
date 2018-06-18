(defsystem cl-generator
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
	     (:file "util")))))
