;;; time-table.asd

(asdf:defsystem #:time-table
  :description "Describe time-table here"
  :author "Long Nguyen"
  :license "MIT"
  :depends-on (#:hunchentoot
               #:cl-who
               #:alexandria
               #:parenscript
	       #:lisp-unit)
  :serial t
  :components ((:file "package")
	       (:file "macros")
               (:file "time-table")))

