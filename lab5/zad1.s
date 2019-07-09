.bss
    .comm controlWord, 2

.text
.global sprawdzWyjatki, wyczyscMaski, maskujWyjatki, dzieleniePrzezZero
.type sprawdzWyjatki, @function
.type maskujWyjatki, @function
.type dzieleniePrzezZero, @function

# Zad1. Sprawdzenie wskazanej flagi w Status Word
sprawdzWyjatki:
    mov $0, %rax		# wyczyszczenie rax
    fstsw %ax			# wczytanie zawartości status word do rejestru ax
    fwait			# następna instrukcja wykona się po wczytaniu status word
    and $0x0ff, %ax     	# czyszczenie starszej części rej aby zostawić tylko flagi wyjątków
ret                     	# wynik w rax, if = 0 then no exceptions

# Wyczyszczenie masek - bo domyślnie są ustawione. Jak wyczyścimy to możliwe wykonanie wyjątku
wyczyscMaski:
    fstcw controlWord		# wczytanie zawartości rejestru kontrolnego do pamięci
    fwait
    mov controlWord, %ax	# zkopiowanie rejestru kontrolnego do ax
    and $0xffc0, %ax		# czyszczenie 6 młodszych bitów rejestru - masek wyjątków
    mov %ax, controlWord	# 
    fldcw controlWord   	# załadowanie zawartości rax do rejestru kontrolnego
ret

#Zad2. Modyfikacja ustawień maskowania wyjątków w Control Word
maskujWyjatki:                	# typ wyjątku w rdi
    fstcw controlWord		# wczytanie zawartości rejestru kontrolnego
    fwait
    mov controlWord, %ax
    or %di, %ax			# ustawienie odpowiednich masek
    mov %ax, controlWord
    fldcw controlWord		# załadowanie zawartości rax do rejestru kontrolnego
ret	

# Przykład dzielenia przez zero - aby wywołać wyjątek
dzieleniePrzezZero:
    fldz			# załadowanie do stosu FPU 0, ST(1) = 0
    fld1			# załadowanie do stosu FPU 1, ST(0) = 1
    fdivp			# dzielenie ST(0) / ST(1), usuwa też wartość na szczycie stosu
    fstp %st			# usunięcie ostatniej wartości pozostającej na stosie
ret
