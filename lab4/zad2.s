.data

.text
.global szyfr_cezara			# Zadeklarowanie funkcji
.type szyfr_cezara, @function


szyfr_cezara:
    push %rbp				# Odłożenie rejestru bazowego na stos
    mov %rsp, %rbp			# Skopiowanie obecnej wartości wskaźnika stosu do rejestru bazowego

    # Parametry wywołania funkcji w rdi i rsi.
    # rdi - wskaźnik na pierwszą komórkę stringa.
    # rsi - długość tego stringa.

    mov $0, %rax			# Zerowanie licznika pętli
    petla:				# Pętla wykonująca się dla każdego znaku

        mov (%rdi, %rax, 1), %bl	# Skopiowanie ostatniego znaku stringa do rejestru bl
        cmp $'Z', %bl			# Szyfrowanie
        jle duze

        male:
            add $4, %bl
            cmp $'z', %bl
            jle dopisz
            sub $26, %bl
            jmp dopisz

        duze:
            add $4, %bl
            cmp $'Z', %bl
            jle dopisz
            sub $26, %bl

        dopisz:
        mov %bl, (%rdi, %rax, 1)	# Zapis zmienionego znaku do stringa

    # Instrukcje sterujące dla pętli
    inc %rax
    cmp %rsi, %rax
    jl petla

    mov %rbp, %rsp			# Przywrócenie poprzedniej wartości rejestru bazowego
    pop %rbp				# i wskaźnika stosu

ret					# Powrót do miejsca wywołania funkcji
