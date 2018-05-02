# cl-generator

## provides
* lambda*
* yield

## usage
``` lisp
(lambda* ()
	 (let ((i 0))
	   (loop while (< i 10) do (print (yield i)) (incf i))))
```

## LICENSE
MIT
