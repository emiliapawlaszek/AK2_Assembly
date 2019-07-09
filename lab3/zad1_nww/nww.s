.data
PIERWSZA = 108
DRUGA = 72

.text
.globl main
main:

movq $PIERWSZA, %r8	# Zapis pierwszwej liczby do rejestru
movq $DRUGA, %r9

push %r8		# Umieszczenie pierwszego argumentu na stosie
push %r9		# Drugiego
call oblicz		# Wywołanie funkcji
#add $16, %rsp		# Usunięcie parametrów ze stosu

oblicz:
push %rbp		# Odłożenie na stos poprzedniej wartości rejestru bazowego
movq %rsp, %rbp		# Pobranie zawartości rsp, wskaźnika na ostatni element na stosie
sub $8, %rsp		# Do góry o jedną komórkę, zwiększenie wskaźnika stosu

movq 24(%rbp), %rax	# Pierwszy argument do rax
movq 16(%rbp), %rbx	# Drugi argument do rbx

	# Kod funkcji
mul %rbx		# wynik w rax
movq %rax, %r10		# Wynik mnożenia do r10


movq 24(%rbp), %rax     # Pierwszy argument do rax
movq 16(%rbp), %rbx     # drugi argument do rbx

		# Algorytm Euklidesa
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

spr:
movq %rax, %r11		# ostatnia reszta przed zerem
movq %r10, %rax		# a * b do rax
div %r11		# Podzielienie rax przez r11, wynik ostateczny w rax

koniec:
movq %rbp, %rsp		# Zakończenie wykonywania funkcji i zwrot wartości
pop %rbp
ret			# Powrót do miejsca wywołania funkcji
