(cl:in-package #:cluffer-simple-buffer)

(defmethod cluffer:update
    ((buffer buffer) time sync skip modify create)
  (let* ((contents (contents buffer))
	 (length (length contents))
	 (i 0)
	 (skip-count 0))
    (tagbody
     skipping
       (cond ((= i length)
	      (unless (zerop skip-count)
		(funcall skip skip-count))
	      (go out))
	     ((> (create-time (aref contents i)) time)
	      (funcall create (cluffer-internal:line (aref contents i)))
	      (incf i)
	      (go not-skipping))
	     ((> (modify-time (aref contents i)) time)
	      (funcall modify (cluffer-internal:line (aref contents i)))
	      (incf i)
	      (go not-skipping))
	     (t
	      (incf skip-count)
	      (incf i)
	      (go skipping)))
     not-skipping
       (cond ((= i length)
	      (go out))
	     ((> (create-time (aref contents i)) time)
	      (funcall create (cluffer-internal:line (aref contents i)))
	      (incf i)
	      (go not-skipping))
	     ((> (modify-time (aref contents i)) time)
	      (funcall modify (cluffer-internal:line (aref contents i)))
	      (incf i)
	      (go not-skipping))
	     (t
	      (funcall sync (cluffer-internal:line (aref contents i)))
	      (setf skip-count 0)
	      (incf i)
	      (go skipping)))
     out)))
