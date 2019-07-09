.data
    STDIN = 0
    STDOUT = 1
    SYSWRITE = 1
    SYSREAD = 0
    SYSEXIT = 60
    EXIT_SUCCESS = 0

NUMER = 5			# Numer szukanego wyrazu ciągu
ZEROWY_WYRAZ = -1		# Wartość zerowego wyrazu ciągu
PIERWSZY_WYRAZ = 2		# Wartość pierwszego wyrazu ciągu

.text
.globl main
main:

movq $NUMER, %r8
push %r8			# Umieszczenie r8 na stosie
call funkcja			# Wywołanie funkcji
add $8, %rsp			# Usunięcie parametru ze stosu

koniec:
movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall

funkcja:
# jeśli i=0 to zwróć -1;
# jeśli i=1 to zwróć 2;
# jeśli i>1 to zwróć -2*n(i-1)+3*n(i-2);

push %rbp			# Umieszczenie na stosie poprzedniej wartości rejestru bazowego
movq %rsp, %rbp			# Pobranie wskażnika na ostatni element stosu do rejestru bazowego
sub $8, %rsp			# Zwiększenie wskaźnika stosu o jedną pozycję
movq 16(%rbp), %rax		# Pobranie zawartości drugiego elementu stosu (nr wyrazu) do rax

cmp $1, %rax			# Porównanie numeru wyrazu ciągu
jl zerowy
je pierwszy

# Jeśli większy od 1
movq $0, %rcx			# Miejsce na wynik

# Dwukrotne wykonanie funkcji dla n=n-1, za każdym razem wynik będzie odejmowany od rcx
dec %rax			# Zmniejszamy rax o 1, bo n=n-1

push %rcx			# Odłożenie na stos
push %rax
call funkcja
pop %rax			# Zabranie ze stosu
pop %rcx
sub %rbx, %rcx			# Odjecie jednej iteracji od wyniku, rbx - wynik częściowy

push %rcx
push %rax
call funkcja
pop %rax
pop %rcx
sub %rbx, %rcx

# Trzykrotne wykonanie funkcji dla n=n-2, za każdym razem wynik będzie dodawany do rcx
dec %rax			# Jeszcze raz zmniejszamy rax

push %rcx
push %rax
call funkcja
pop %rax
pop %rcx
add %rbx, %rcx

push %rcx
push %rax
call funkcja
pop %rax
pop %rcx
add %rbx, %rcx

push %rcx
push %rax
call funkcja
pop %rax
pop %rcx
add %rbx, %rcx


movq %rcx, %rbx			# Zwrot wyliczonej wartosci z rcx do rbx
movq %rbp, %rsp			# Zapisanie rejestru bazowego do wskaźnika szczytu stosu
pop %rbp			# Ściągnięcie ze stosu ostatniego elementu
ret				# Powrót do miejsca wywołania funkcji

zerowy:				# zwrot wartości zerowego wyrazu jeśli n=0
movq $ZEROWY_WYRAZ, %rbx
movq %rbp, %rsp
pop %rbp
ret

pierwszy:			# Zwrot wartości pierwszego wyrazu jeśli n=1
movq $PIERWSZY_WYRAZ, %rbx
movq %rbp, %rsp
pop %rbp
ret

