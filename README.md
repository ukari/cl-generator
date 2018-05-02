# cl-generator

## provides
* defun*
* lambda*
* yield

## usage
``` lisp
(defun* test (f)
  (let ((i 0))
    (loop while (< i 10) do (print (funcall f i)) (incf i))))

(test (lambda* (x) (yield x)))
```

``` lisp
(lambda* ()
	 (let ((i 0))
	   (loop while (< i 10) do (print (yield i)) (incf i))))
```

## LICENSE
MIT
