.data
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
STDOUT = 1
STDIN = 0
EXIT_SUCCESS = 0
BUFLEN = 512

msg: .ascii "Wpisz liczbę w systemie trójkowym \n"
msg_len = . - msg

buferror: .ascii "Wprowadzona liczba jest niepoprawna!\n"
buferror_len = .-buferror

.bss
.comm firststring, 512          	# bajty na napis w formacie trójkowym
.comm secondstring, 512	       		# bajty na napis w formacie siódemkowym 

.text
.globl _start
_start:
movq $SYSWRITE, %rax			# wyświetlenie napisu początkowego
movq $STDOUT, %rdi
movq $msg, %rsi
movq $msg_len, %rdx
syscall
					# wczytanie liczby
movq $SYSREAD,  %rax            	# załadowanie polecenia odczytu dla systemu
movq $STDIN, %rdi               	# wskazanie wyjścia z którego ma być pobrany parametr
movq $firststring, %rsi			# bufor do którego tekst zostanie wczytany
movq $BUFLEN, %rdx			# długość buforu
syscall                         	# wczytanie liczby od użytkownika (przerwanie systemowe)

movq $3, %rcx				# podstawa systemu = 3
movq $0, %rbp				# tam zapiszemy liczbe jako całkowitą wartość w dziesiętnym
movq %rax, %rsp				# zaoamiętanie zawartosci rejestru rax


dec %rax				# pominięcie znkau końca linii
movq $0, %rdi				# licznik
movq %rax, %r8				# zaoamiętanie zawartosci rejestru rax

petla:	                		# sprawdzenie czy liczba jest w sys trójkowym
movb firststring(,%rdi,1), %bl		# wczytuje kolejny znak do rejestru
#cmp $0x19, %bl				# pominięcie nulla
#jl dalej
cmp $'0', %bl
jl display_error
cmp $'2', %bl
jl display_error


sub $48, %bl				# odejmuje od '0' numer znaku ascii danej cyfry
#movq $1, %rax				# tam będzie mnożnik
movq %rdi, %rsi				# zapamiętujemy sprawdzany indeks


jmp first
second:
inc %rsi
mul %rcx				# mnożenie razy 3 (podniesienie do kolejnej potęgi)
first:
cmp r8, %rsi				# porównujemy obecny indeks z zerem
jne second

mul %bl					# mnożymy wartość liczby razy mnożnik
add %rax, %rbp				# dodajemy wartość do całej wartości liczby
dalej:
dec %rdi				# zmniejszamy indeks o 1
cmp %r8, %rdi				# sprawdzenie czy wczytaliśmy całą liczbę
jl petla				# jeżeli nie wczytaliśmy całej liczby to wczytujemy kolejną poz

zmiana_systemu:
movq %rbp, %rax				# tymczasowy wynik przenosimy do rax
movq $0, %rsi
movq $7, %rcx				# podstawa systemu = 7

schemat_hornera:
movq $0, %rdx				# wyczyszczenie rdx
div %rcx				# dzielimy przez 7, wynik w rax, reszta w rdx
add $48, %rdx				# kodujemy powstałą cyfrę na znak ascii
movb %dl, secondstring(, %rsi, 1)	# dodanie znaku do zamienionej liczby
inc %rsi				# zwiększamy licznik o 1
cmp %rsp, %rdi				# sprawdzamy czy zamieniliśmy całą liczbę
jne schemat_hornera


koniec:
movq $SYSWRITE, %rax            	# załadowanie polecenia odczytu dla systemu
movq $STDOUT, %rdi              	# wskazanie wyjścia na które tekst ma zostać wyświetlony
movq $secondstring, %rsi         	# źródło wyświetlanego tekstu
movq $BUFLEN, %rdx			# długość buforu
syscall

jmp quit
display_error:
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $buferror, %rsi
movq $buferror_len, %rdx
syscall

quit:
movq $SYSEXIT, %rax             	# polecenie zakończenia programu
movq $EXIT_SUCCESS, %rdi        	# parametr oznaczający poprwane zakończenie programu
syscall
