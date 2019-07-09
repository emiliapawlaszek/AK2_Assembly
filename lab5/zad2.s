.data
silnia: .double 1.0		# wartość pierwszej silni

.text
.global taylor
.type taylor, @function
 
# Funkcja obliczająca przybliżenie wartości e^x wykorzysując szereg Taylora
taylor:
    push %rbp
    mov %rsp, %rbp
    				# Przyjmowane przez funkcje argumenty:
    				# rdi - liczba wyrazów ciągu
    				# xmm0 - niewiadoma, x
    sub $8, %rsp
    movsd %xmm0, (%rsp)
    fldl (%rsp)  		# ST(2) = niewiadoma, x
    fld %st     		# ST(1) = aktualna suma ciągu (początkowo równa x)
    fld %st     		# ST(0) = aktualny wyraz ciągu (początkowo równy x)

    movq $0, %rsi		# Licznik do pętli
    fwait			# Oczekiwanie na zakończenie wykonywanych przez FPU obliczeń
 
    petla:
        cmp %rdi, %rsi
        je koniec		# Wyskok z pętli po obliczeniu wszystkich wyrazów
        inc %rsi		# Zwiększenie licznika pętli
 
        			#LICZNIK
        fmul %st(2), %st 	# ST(0) *= x, czyli aktualny wyraz ciągu = poprzedni wyraz ciągu * x
 

        			#MIANOWNIK, CZYLI SILNIA
        fld1    		# ST(2) = 1
        fld1    		# ST(1) = wynik silni (początkowo 1)
        fldl silnia 		# ST(0) = numer wyrazu silni (pobrany z "silnia")


        fadd %st(2), %st	# (poprzedni nr silni + 1)
        fmul %st, %st(1)	# (poprzedni nr silni + 1)*wynik silni
 												
        fstpl silnia 		# Zapisanie nr ostatniego wyr silni do zmiennej i ściągnięcie go z FPU
 
        			# SPRZĄTANKO 
        fxch %st(1) 		# Zamiana miejscami ST(0) i ST(1)
        fstp %st    		# Ściągnięcie z FPU ostatniej wartości
 
				# Aktualny stan rejestrów:
				# ST(3) - niewiadoma, x
				# ST(2) - aktualna suma ciągu
				# ST(1) - mianownik (aktualny wyraz ciągu)
				# ST(0) - silnia (aktualny dzielnik)
 
        fdivr %st, %st(1) 	# Dzielenie obecnego wyrazu przez silnię - wynik trafi do ST(1)
 
        fstp %st 		# Usunięcie obecnego dzielnika z FPU
                    		# Zawartość rejestrów jak na początku pętli
 
        fadd %st, %st(1) 	# Dodanie wartości obecnego wyrazu do wyniku globalnego
 
        jmp petla 		# Powrót na początek pętli
 
    koniec:			# Przeniesienie wyniku z rejestru ST(0) (sumy ciągu)
    fstp %st			# do rejestru xmm0 przez stos i zakończenie funkcji
    fstpl (%rsp)
    movsd (%rsp), %xmm0
 
mov %rbp, %rsp
pop %rbp
ret
