# cl-generator
generator in common lisp

## supports
- yield
- yield*
- works with anonymous and macros
- common lisp multiple values
- copy iter with continuation

## provides

### cl-generator
* `yield`
* `yield*`
* `with-yield`
* `lambda*`
* `defun*`
* `defmethod*`
* `defmacro*`
* `iter-next`
* `iter-cur`

### cl-generator-util
* `for`

## install
``` lisp
(ql:quickload 'cl-generator)
```

## usage
``` lisp
(require 'cl-generator)
(use-package 'cl-generator)
(use-package 'cl-generator-util)
```

### yield
``` lisp
(defun* test (x)
  (print (yield x)))

(defparameter iter (test 0))
(funcall (iter-next iter))
(funcall (iter-next iter) 1)
```

``` lisp
(defun* matryoshka (x)
  (yield (yield (yield x))))
```
the same thing as in javascript
``` javascript
function* matryoshka(x) {
	return yield yield yield x;
}
```

### with-yield
`with-yield` returns a `ITER`. `lambda*`, `defun*`, `defmethod*`, `defmacro*` are implement on the top of `with-yield`.

``` lisp
(defparameter tmp (with-yield (+ (yield) 1)))
(funcall (iter-next tmp))
(funcall (iter-next tmp) 2)
```

### lambda*
``` lisp
(lambda* ()
  (let ((i 0))
    (loop while (< i 10)
       do (yield i)
         (incf i))))
```

### defun*
``` lisp
(defun* test ()
  (let ((i 0))
    (loop while (< i 10)
       do (yield i)
         (incf i))))

(test)
```

### defmethod*
``` lisp
(defmethod* test ()
  (let ((i 0))
    (loop while (< i 10)
       do (yield i)
         (incf i))))

(test)
```

### defmacro*
``` lisp
(defmacro* test (f)
  `(let ((i 0))
     (loop while (< i 10)
        do (funcall ,f i)
          (incf i))))

(test (lambda (x) (yield x)))
```

### yield*
``` lisp
(defun* a ()
  (yield 1)
  (yield 2)
  (print "end"))

(defun* b ()
  (yield* '(7 8 9))
  (yield* (a)))

(defun* c ()
  (yield* (list (yield 1) (yield 2))))
```

``` lisp
(defun* a ()
  (yield 1)
  (yield 2)
  (values 3 4 5))

(defun* b ()
  (yield (yield* (a))))
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

### iter-next
``` lisp
(defun* ten-generator ()
  (let ((i 0))
    (loop while (< i 10)
       do (yield i)
         (incf i))))
(defparameter x (ten-generator))
(defparameter res (funcall (iter-next x)))
(loop until (null (iter-next x))
   do (print res)
     (setf res (funcall (iter-next x))))
```

### iter-cur
copy a iter with it's current continuation

``` lisp
(defun* test ()
  (yield 1)
  (yield 2)
  (yield 3))

(defparameter raw (test))
(defparameter copy (funcall (iter-cur raw)))
(print (funcall (iter-next raw)))
(defparameter copy2 (funcall (iter-cur raw)))
(print (funcall (iter-next raw)))
(print (funcall (iter-next copy)))
(print (funcall (iter-next copy2)))
```

## test
``` lisp
(require 'cl-generator-test)
(cl-generator-test:run)
```

## LICENSE
MIT
