# cl-generator

## provides
* defun*
* lambda*
* yield

## usage
``` lisp
(defun* test (f)
  (let ((i 0))
    (loop while (< i 10) do (multiple-value-bind (_ v) (funcall f i) (declare (ignore _)) (print v)) (incf i))))

(test (lambda* (x) (yield x)))
```

``` lisp
(lambda* ()
	 (let ((i 0))
	   (loop while (< i 10) do (print (yield i)) (incf i))))
```

## LICENSE
MIT
