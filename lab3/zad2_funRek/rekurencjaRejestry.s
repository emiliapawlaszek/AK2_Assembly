.data
STDIN = 0
STDOUT = 1
SYSWRITE = 1
SYSREAD = 0
SYSEXIT = 60
EXIT_SUCCESS = 0
NUMER = 6                       # Numer szukanego wyrazu ciągu
ZEROWY_WYRAZ = -1               # Wartość zerowego wyrazu ciągu
PIERWSZY_WYRAZ = 2              # Wartość pierwszego wyrazu ciągu

.text
.globl main
main:

movq $NUMER, %r8		# To jest i
movq %r8, %r9			# Zapamiętanie r8
push %r8
call funkcja                    # Wywołanie funkcji
add $8, %rsp

koniec:
movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall

funkcja:
# jeśli i=0 to zwróć -1;
# jeśli i=1 to zwróć 2;
# jeśli i>1 to zwróć -2*n(i-1)+3*n(i-2)

movq %r9, %rax

cmp $1, %rax
jl zerowy
je pierwszy

# Jeśli większy od 1
movq $0, %rcx			# Miejsce na wynik

# Dwukrotne wykonanie funkcji dla n=n-1, za każdym razem wynik będzie odejmowany od rcx
dec %rax                        # Zmniejszamy rax o 1, bo n=n-1

call funkcja
sub %rbx, %rcx

call funkcja
sub %rbx, %rcx

# Trzykrotne wykonanie funkcji dla n=n-2, za każdym razem wynik będzie dodawany do rcx
dec %rax                        # Jeszcze raz zmniejszamy rax

call funkcja
add %rbx, %rcx

call funkcja
add %rbx, %rcx

call funkcja
add %rbx, %rcx

movq %rcx, %rbx
call funkcja

zerowy:
movq $ZEROWY_WYRAZ, %rbx
ret

pierwszy:
movq $PIERWSZY_WYRAZ, %rbx
ret

