(define (null-ld? obj)
	(if (pair? obj)
	(if (eq? (car obj) (cdr obj)) #t #f)
	#f)
)


(define (listdiff? obj)
		(if (pair? obj)
			(
				let ((head (car obj)) (tail (cdr obj)))
				(	if (eq? head tail)
					#t
					( if(pair? head)
						(listdiff? (cons (cdr head) tail))
						#f
					)
				)
			)
			#f
		)
)

(define (cons-ld obj ld)
	(
		let ((nc (cons obj (car ld))))
		(cons nc (cdr ld))
	)
)

(define (car-ld ld)
	(
		if(and (listdiff? ld) (not(null-ld? ld)))
		(
			car (car ld)
		)
		(
			display "error\n"
		)
	)
)

(define (cdr-ld ld)
	(
		if(null-ld? ld)
		(
			display "error\n"
		)
		(
			let ((head (cdr (car ld))))
			(cons head (cdr ld))
		)
	)
)

( define (listdiff . args)
	 (
	 		if (null? args)
				(display "Error")
	 			(cons args '())
	)
)

(define (length-ld ld)
	(if (listdiff? ld)
		(
			if(null-ld? ld)
				0
				( let ((head (cdr (car ld))))
					(+ 1 (length-ld (cons head (cdr ld))))
				)
		)
		(display "error\n")
	)

)

(define (append-ld-helper l)
	(if(null? l)
		'()
		(append (listdiff->list (car l)) (append-ld-helper (cdr l)))
	)
)

(define (append-ld . args)
	(cons (append-ld-helper args) '())
)



(define (assq-ld obj alistdiff)
	(
		if(null-ld? alistdiff)
			#f
			(
				if(eq? obj (car (car-ld alistdiff)))
					(car-ld alistdiff)
					(assq-ld obj (cdr-ld alistdiff))
			)
	)
)

(define (list->listdiff list)
	(cons list '())
)

(define (listdiff->list ld)
	(
		if(pair? ld)
		(
			if(eq? (car ld) (cdr ld))
				'()
				(
					let ((first (cdr (car ld))) (tail (cdr ld)))
					(cons (car (car ld)) (listdiff->list (cons first tail)))
				)
		)
		(cons (car ld) '())
	)

)

(define (expr-returning ld)
	(append '(quote) (cons (cons (listdiff->list ld) '()) '()))
)
