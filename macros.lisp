(in-package :time-table)

;; Javascript ;;;
;================

(parenscript:defpsmacro $$ ((selector event-binding) &body body)
  `((@ ($ ,selector) ,event-binding) (lambda () ,@body)))


(parenscript:defpsmacro radio-fun (pan sub)
  `($$ ((concatenate 'string "#" ,pan) change)
     (if (@ this checked)
	 (progn
	   ((@ ($ "td .fa-lg") css) "visibility" "hidden")
	   ((@ ($ (concatenate 'string "." ,sub)) css) "visibility" "visible")))))

(parenscript:defpsmacro default-radio ()
  `($$ ("#Eagle" change)
       (if (@ this checked)
	   ((@ ($ "td .fa-lg") css) "visibility" "visible"))))


;; Variables ;;
;==============


(defun process-class (classes alphabet)
  (loop for class across classes nconc
       (loop for char across alphabet
	  collect (coerce (list class char) 'string))))

(defparameter *class-list*
  (process-class (reverse "6789") (reverse "ABCDEG")))

(defparameter *class-list-2*
  (process-class "6789" "ABCDEG"))


(defparameter *panel-list*
    '("Math" "Literature" "English" "Physics" "Chemistry" "Biology" "PE" "History" "Geography" "Art" "Civic" "IT" "Technology"))

(defparameter *subject-list*
  '("Math" "Liter" "Eng" "Phy" "Chem" "Bio" "PE" "His" "Geo" "Art" "Civic" "IT" "Tech"))

(defparameter *2cl-subjects*
  '("Eng" "Chem" "Bio" "PE" "His")
  "A list of subjects have 2 classes per week")

(defparameter *1cl-subjects*
  '("Civic" "Tech" "IT" "Geo" "Art")
  "A list of subjects have 1 class per week")


(defparameter *subjects-67*
  '("Math" "Math" "Liter" "Liter"
    "Math" "Math" "Liter" "Liter"
    "Eng" "Eng" "Eng"
    "PE" "PE" "Phy" "Phy"
    "Bio" "Bio" "His" "His"
    "Civic" "Tech" "IT" "Geo" "Art")
  "A list of subjects appear in timetable of grade 6,7")

(defparameter *subjects-89*
  '("Math" "Math" "Liter" "Liter"
    "Math" "Math" "Liter" "Liter"
    "Eng" "Eng" "Eng"
    "PE" "PE" "Phy" "Phy"
    "Chem" "Chem" "His" "Civic"
    "Tech" "IT" "Geo" "Bio" "Art")
  "A list of subjects appear in timetable of grade 8,9.")




;; Macros && wanted functions ;;
;===============================

(defmacro aif (test-form then-form &optional else-form)
  "An anaphoric if macro."
  `(let ((it ,test-form))
     (if it ,then-form ,else-form)))

(defmacro awhen (test-form &body body)
  "An anaphoric when macro."
  `(aif ,test-form
	(progn ,@body)))

(defmacro standard-page ((&key title) &body body)
  `(cl-who:with-html-output-to-string (cl:*standard-output* nil :prologue t :indent t)
     (:html
      (:head
       (:title ,title)
       (:link :rel "stylesheet" :href "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css")
       (:link :rel "stylesheet" :href "https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css")
       (:link :rel "stylesheet" :href "style.css"))
      (:body
       (:div
	:class "container"
	(:div
	 :class "row"
	 (:div
	  :class "col-md-10"
	  (:table
	   :class "table table-bordered"
	   (:tr
	    (:th "Class")
	    (:th "Monday")
	    (:th "Tuesday")
	    (:th "Wednesday")
	    (:th "Thursday")
	    (:th "Friday"))
	   ,@(my-table *class-list-2*)))
	 (:div
	  :class "col-md-2"
	  (:div
	   :class "panel panel-info"
	   :style "margin-top: 50px"
	   (:div :class "panel-heading")
	   (:div
	    :class "panel-body"
 	    (:div
	     :class "radio"
	     ,@(my-radio *subject-list* *panel-list*)))))))
       ,@body))))

(defun my-radio (sub-list pan-list)
  (cons (render-default-radio)
	(loop
	   for sub in sub-list
	   for pan-sub in pan-list
	   collect (render-radio sub pan-sub))))


(defun render-radio (sub pan-sub)
  (list :label
	(list :input :type "radio" :name "sub-opt"
	      :id pan-sub
	      (render-fa-with sub)
	      (concatenate 'string "&nbsp; " pan-sub))))

(defun render-default-radio ()
  (list :label
	(list :input :type "radio" :checked "checked"
	      :id "Eagle" :name "sub-opt"
	      (list :i
		    :class "fa-fw-2x fa-lg fa fa-ra Eagle"
		    :style "padding: 3px; color: brown")
	      "&nbsp; Eagle view") :br :br))


(defun my-table (class-list)
  "Return a list of table rows."
  (loop
     for periods in *periods-lst*
     for class in class-list
     collect (my-row-2 class periods)))


(defun my-row-2 (class periods)
  (let ((mon (subseq periods 0 4))
	(tue (subseq periods 4 9))
	(wed (subseq periods 9 14))
	(thu (subseq periods 14 19))
	(fri (subseq periods 19 24)))
    (list :tr
	  (list :td class)
	  (render-day-2 (cons "Assem" mon))
	  (render-day-2 tue)
	  (render-day-2 wed)
	  (render-day-2 thu)
	  (render-day-2 fri))))

(defun render-day-2 (sub-lst)
  (cons :td
	(loop for sub in sub-lst
	   collect (render-fa-with sub))))


(defun my-row (class subject-list)
  "Return a list of subjects as table (:tr (:td) (:td) ... )."
  (let ((sh (shuffle-until-valid subject-list)))
    (list :tr
	  (list :td class)
	  (render-day (reverse (cons "Assem" (subseq sh 0 4))))
	  (render-day (subseq sh 4 9))
	  (render-day (subseq sh 9 14))
	  (render-day (subseq sh 14 19))
	  (render-day (subseq sh 19 24)))))

(defun render-day (sub-list)
  "Render subjects as font-awesome icons."
  (let ((res nil))
    (cons :td
	  (dolist (sub sub-list res)
	    (push (render-fa-with sub) res)))))

(defun render-fa-with (sub)
  (alexandria:switch (sub :test #'equal)
    ("Assem" (fa sub "fa fa-flag" "darkgoldenrod"))
    ("Math"  (fa sub "fa fa-percent" "olive"))
    ("Liter" (fa sub "fa fa-book" "orange"))
    ("Eng"   (fa sub "fa fa-language" "blue"))
    ("Phy"   (fa sub "fa fa-rocket" "silver"))
    ("Chem"  (fa sub "fa fa-flask" "navy"))
    ("Bio"   (fa sub "fa fa-leaf" "green"))
    ("PE"    (fa sub "fa fa-male" "lightblue"))
    ("His"   (fa sub "fa fa-fort-awesome" "burlywood"))
    ("Geo"   (fa sub "fa fa-globe" "deepskyblue"))
    ("Art"   (fa sub "fa fa-paint-brush" "turquoise"))
    ("Civic" (fa sub "fa fa-graduation-cap" "lavender"))
    ("IT"    (fa sub "fa fa-code" "black"))
    ("Tech"  (fa sub "fa fa-wrench" "teal"))
    (otherwise (fa sub "fa fa-times-circle" "red"))))

(defun fa (class icon color)
  (list :i
	:class (concatenate 'string "fa-fw-2x fa-lg " icon " " class)
	:style (concatenate 'string "padding: 3px; color: " color)))

(defun shuffle-until-valid (sub-list)
  (loop
     do (setf sub-list (alexandria:shuffle sub-list))
     when (validp sub-list) return sub-list))

(defun validp (lst)
  "This lst will be valid if
   * No subject appears 3 or more times a day
   * Subjects have 2-3 classes per week appear exactly once a day
   * No day has 2 Math + 2 Liter
   * Consecutive Math and consecutive Literature appears once a week"
  (let* ((mon (subseq lst 0 4))
	 (tue (subseq lst 4 9))
	 (wes (subseq lst 9 14))
	 (thu (subseq lst 14 19))
	 (fri (subseq lst 19 24))
	 (week (list mon tue wes thu fri))
	 (res nil))
    (dolist (day week)
      (push (and (< (largest-subject-freq day) 3)
		 (appear-once-p *2cl-subjects* day)
		 (not-tw-same-day "Math" "Liter" day))
	    res))
    (if (member 'nil res)
	nil
	(if (and (appear-conse-1-p "Math" week)
		 (appear-conse-1-p "Liter" week))
	    t
	    nil))))

(defun largetst-pos-freq (lst)
  (let ((uniq-lst (remove-duplicates lst))
	(res nil))
    (dolist (num uniq-lst)
      (push (count num lst) res))
    (car (sort res #'>))))

(defun largest-subject-freq (day)
  "Return an integer that is the largest subject frequency on this day"
  (let ((res nil))
    (dolist (sub day)
      (push (count sub day :test #'equal) res))
    (car (sort res #'>))))

(defun appear-once-p (sub-list day)
  "Return true if subject in sub-list appear once a day"
  (let ((res nil))
    (dolist (sub sub-list)
      (push (count sub day :test #'equal) res))
    (if (= (car (sort res #'>)) 1)
	t
	nil)))

(defun not-tw-same-day (sub1 sub2 day)
  "Sub1 and sub2 do not appear together twice on this day"
  (if (and (= (count sub1 day :test #'equal) 2)
	   (= (count sub2 day :test #'equal) 2))
      nil
      t))

(defun appear-conse-1-p (sub week)
  "Return true if this subject appears consecutively once a week"
  (let ((res nil))
    (dolist (day week)
      (if (<= (count sub day :test #'equal) 1)
	  (push 'nil res)
	  (if (= (abs (apply #'- (all-positions sub day)))
		 1)
	      (push 't res)
	      (push 'nil res))))
    (if (= (count 't res) 1)
	t
	nil)))

(defun all-positions (needle haystack)
  "Return a list of all positions of needle in haystack"
  (loop
     for elt in haystack
     and position from 0
     when (equal elt needle) collect position))


;;==============

(defun school-periods (sub-lst)
  (loop repeat 24
     collect (shuffle-until-valid (copy-list sub-lst))))

(defparameter *periods-lst*
  (school-periods *subjects-67*))

(defun period-positions (sub periods)
  "Returns a list of period positions of this subject in classes '(6A 6B 6C ... 9E 9G)"
  (loop for pe in periods
       collect (position sub pe :test #'equal)))

(defun largest-ppos-freq (checklst)
  "Return the frequency of the most common period position in this check-list"
  (let ((uniq-lst (remove-duplicates checklst)))
    (loop for num in uniq-lst
       collecting (count num checklst) into res
       finally (return (car (sort res #'>))))))

(defun occurences (num-lst)
  "Return a hash table has (k,v) = (period-position,frequency)"
  (let ((freq (make-hash-table)))
    (dolist (num num-lst)
      (incf (gethash num freq 0)))
    freq))


(defun occur-alist (num-lst)
  "Return a sorted assoc list of elements's frequency in this list."
  (sort (alexandria:hash-table-alist (occurences num-lst))
	#'> :key #'cdr))


(defun uniq-ppos (sub periods)
  "Return a sorted list of unique positions that this subjects possess in the periods."
  (sort (remove-duplicates (period-positions sub periods))
	#'<))

(defun lack-of-ppos (sub periods)
  "Return a list of period positions that this subject currently doesn't have."
  (let ((test-lst (uniq-ppos sub periods)))
    (loop for i from 0 to 24
       when (not (member i test-lst)) collect i)))


(defun freq-ppos-gt2 (alst)
  "Returns an assoc list of period positions that have frequency greater than 2"
  (remove-if-not #'(lambda (x) (> (cdr x) 2))
		 alst))


(defun mrotate-ppos (input-list periods)
  "Rotate multiple period positions of subjects in this input list until:
   * Each period position in each subject has frequency <= 2"
  (let ((matrix (loop for sub in input-list
		   collect (period-positions sub periods))))
    (dolist (sub input-list)
      (let* ((sub-pos-in-matrix (position sub input-list :test #'equal))
	     (sub-ppos (nth sub-pos-in-matrix matrix))
	     (sub-common-ppos (freq-ppos-gt2 (occur-alist sub-ppos)))
	     (other-subs-ppos (remove sub-ppos matrix :test #'equal)))
	(dolist (ppos sub-common-ppos)
	  (let* ((pp   (car ppos))
		 (freq (cdr ppos))
		 (rotate-times (- freq 2))
		 (pos-of-pp (all-positions pp sub-ppos)))
	    (dolist (pos pos-of-pp)
	      (if (= rotate-times 0)
		  (return)
		  (let ((column (loop for matrix-child in matrix
				   collect (nth pos matrix-child)))
			(sub-pp-column   (nth pos sub-ppos))
			(other-pp-column (loop for ppos in other-subs-ppos
					    collect (nth pos ppos)))
			(sub-missing-pos (lack-of-ppos sub periods)))
		    (dolist (miss-pos sub-missing-pos)
		      (awhen (position miss-pos other-pp-column)
			;; we check frequency of sub-pp-column in oreka-place.
			(let* ((oreka-place (nth it other-subs-ppos))
			       (sub-pp-column-freq (cdr (assoc sub-pp-column
							       (occur-alist oreka-place)))))
			  (when (or (eq sub-pp-column-freq nil)
				    (=  sub-pp-column-freq 1))
			    (decf rotate-times)
			    (rotatef (nth pos (nth sub-pos-in-matrix matrix))
				     (nth pos (nth (position miss-pos column) matrix)))
			    (return))))))))))))
    matrix))

;; Unit Tests ;;
;; ========== ;;
(define-test test-matrix
  (let ((r-matrix (mrotate-ppos *1cl-subjects* *periods-lst*)))
    (dolist (lst r-matrix)
      (assert-equal 2 (largest-ppos-freq lst)))))
