;;;; time-table.lisp

(in-package #:time-table)


(push (create-static-file-dispatcher-and-handler "/hack.js" "asset/hack.js") *dispatch-table*)
(push (create-static-file-dispatcher-and-handler "/style.css" "asset/style.css") *dispatch-table*)

(setf *js-string-delimiter* #\")


(define-easy-handler (javascript :uri "/helper.js") ()
  (setf (content-type*) "text/javascript")
  (ps
    ($$ (document ready)
	(default-radio)
	(radio-fun "Math" "Math")
	(radio-fun "Literature" "Liter")
	(radio-fun "English" "Eng")
	(radio-fun "Physics" "Phy")
	(radio-fun "Chemistry" "Chem")
	(radio-fun "Biology" "Bio")
	(radio-fun "PE" "PE")
	(radio-fun "History" "His")
	(radio-fun "Geography" "Geo")
	(radio-fun "Music" "Music")
	(radio-fun "Art" "Art")
	(radio-fun "Civic" "Civic")
	(radio-fun "IT" "IT")
	(radio-fun "Technology" "Tech"))))



(define-easy-handler (index :uri "/") ()
  (setf (hunchentoot:content-type*) "text/html")
  (standard-page 
      (:title "Timetable")
      (:script :src "https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"
	       :type "text/javascript")))

