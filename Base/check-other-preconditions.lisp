(cl:in-package #:cluffer-base)

(defmethod cluffer:insert-item-at-position :before
    ((line cluffer:line) item position)
  (when (minusp position)
    (error 'cluffer:beginning-of-line))
  (when (> position (cluffer:item-count line))
    (error 'cluffer:end-of-buffer)))

(defmethod cluffer:find-line :before ((buffer cluffer:buffer) line-number)
  (when (minusp line-number)
    (error 'cluffer:beginning-of-buffer))
  (when (>= line-number (cluffer:line-count buffer))
    (error 'cluffer:end-of-buffer)))