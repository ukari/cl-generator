# cl-generator

## provides

### cl-generator
* `lambda*`
* `defun*`
* `defmacro*`
* `yield`

### cl-generator-util
* `for`

## usage
``` lisp
(require 'cl-generator)
(use-package 'cl-generator)
(use-package 'cl-generator-util)
```


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
       do (print (nth-value 1 (funcall (funcall f i))))
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

### for
``` lisp
(defun* number-generator (x)
  (let ((i 0))
    (loop while (< i x)
       do (yield i)
         (incf i))))

(for (x (number-generator 10)) (print x))
```

## LICENSE
MIT
