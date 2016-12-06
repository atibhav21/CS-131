(define (assq-ld obj alistdiff)

)



(define (listdiff->list ld)

)

(define (expr-returning ld)
)

if(eq? obj (car (car alistdiff)))
	(car alistdiff)
	(assq-ld obj (cdr alistdiff))

	(
		let ((elem1 (listdiff->list ld1)) (ld2 (car args)))

			(
				let ((m_ld2 (cons-ld elem1 ld2)))
				(
					if(null? (cdr args))
						m_ld2
						(append-ld (cons m_ld2 args))
				)
			)
	)

	(append-ld (cons (cons modified_next_car (cdr next)) rest))


	(define (append-ld . args)
		(
			if(= (length args) 1)
				(car args)
				( append-ld
					(cons
						(list->listdiff
							(append (listdiff->list (car args)) (listdiff->list (car (cdr args))))
						)
						(cdr (cdr args))
					)
				)
		)
	)

	(define (append-ld . args)
		(
			if(= (length args) 1)
				(car args)
				( append-ld
					(append
						(list->listdiff
							(append (listdiff->list (car args)) (listdiff->list (car (cdr args))))
						)
						(cdr (cdr args))
					)
				)
		)
	)
