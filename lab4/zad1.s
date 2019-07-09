# Wczytanie argumentu całkowitoliczbowego i 2 zmiennoprzecinkowych za pomocą funkcji bibliotecznej scanf,
# Wywołanie funkcji napisanej w jęz. C:
# double func(int x, float y, float z)
# {
#     return x*x + y*y + z*z;
# }
# Wypisanie wyniku za pomocą funkcji printf

.data
    SYSEXIT = 60
    EXIT_SUCCESS = 0

    decimal: .asciz "%d"
    float: .asciz "%f"
    result: .asciz "%lf\n"
.bss
    .comm num1, 4
    .comm num2, 4
    .comm num3, 4
.text
    .global main
main:
push %r8			# Umieszczenie czegokolwiek na stosie bo inaczej nie działa
call funkcja
add $8, %rsp
funkcja:
push %rbp
mov %rsp, %rbp

# wczytanie liczby całkowitej
    mov $0, %rax		# liczba argumentów zmiennoprzecinkowych przekazywanych do funkcji
    mov $decimal, %rdi		# pierwszy argument funkcji - format zapisanej liczby
    mov $num1, %rsi		# drugi argument funkcji - adres bufora gdzie ma być zapisana liczba
    call scanf			# wywołanie funkcji scanf

# wczytanie liczby zmiennoprzecinkowej
    mov $0, %rax
    mov $float, %rdi
    mov $num2, %rsi
    call scanf

# wczytanie liczby zmiennoprzecinkowej
    mov $0, %rax
    mov $float, %rdi
    mov $num3, %rsi
    call scanf

wyw_fun:
    mov $2, %rax		# liczba przesyłanych argumentów zmiennoprzecinkowych
    mov num1, %rdi		# parametr typu całkowitego
    movss num2, %xmm0		# parametr typu zmiennoprzecinkowego
    movss num3, %xmm1		# parametr typu zmiennoprzecinkowego
    call func
				# wynik w xmm1

    mov $1, %rax		# przesłanie 1 parametru zmiennoprzecinkowego
    mov $result, %rdi
    call printf


    movq $SYSEXIT, %rax
    movq $EXIT_SUCCESS, %rdi
    syscall
