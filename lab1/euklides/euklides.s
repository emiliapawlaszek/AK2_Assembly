.data
SYSWRITE = 1
SYSEXIT = 60
STDOUT = 1
EXIT_SUCCESS = 0
DZIELNA_A = 14
DZIELNIK_B = 35

.text
.globl _start

_start:
movq $DZIELNA_A, %rax
movq $DZIELNIK_B, %rbx

poczatek:
movq $0, %rdx		#zerowanie rdx, bo nie będzie takich dużych liczb
cmp %rax, %rbx		#porównanie A i B (dzielnej i dzielnika)
je koniec

algorytm:
div %rbx		#dzielna-rax, dzielnik-rbx, wynik-rax, reszta-rdx
movq %rbx, %rax		#dzielnik staje się dzielną
movq %rdx, %rbx		#reszta staje się dzielnikiem
cmp $0, %rdx		#if reszta==0 to nwd==rax
jne poczatek

koniec:
movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall
