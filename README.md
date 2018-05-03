# cl-generator

## provides
* `lambda*`
* `defun*`
* `defmacro*`
* `yield`

## usage

### lambda*
``` lisp
(lambda* ()
  (let ((i 0))
    (loop while (< i 10)
       do (print (yield i))
         (incf i))))
```

### defun*
``` lisp
(defun* test (f)
  (let ((i 0))
    (loop while (< i 10)
       do (print (nth-value 1 (funcall f i)))
         (incf i))))

(test (lambda* (x) (yield x)))
```

### defmacro*
``` lisp
(defmacro* test (f)
  `(let ((i 0))
    (loop while (< i 10) do
	 (print (funcall ,f i))
	 (incf i))))

(test (lambda (x) (yield x)))
```

## LICENSE
MIT
