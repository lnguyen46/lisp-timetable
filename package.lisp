;;;; package.lisp
(defpackage #:time-table
  (:use #:cl
	#:hunchentoot
	#:alexandria
	#:parenscript
	#:lisp-unit)
  (:shadowing-import-from :parenscript :switch :in :for)
  (:shadowing-import-from :lisp-unit :set-equal))


