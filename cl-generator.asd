(defsystem cl-generator
  :serial t
  :depends-on (cl-cont cl-annot closer-mop)
  :components
  ((:module "base"
	    :serial t
	    :components
	    ((:file "package")
             (:file "header")
	     (:file "cl-generator")))
   (:module "util"
	    :serial t
	    :components
	    ((:file "package")
	     (:file "util")))))
