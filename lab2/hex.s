.data
STDIN = 0
STDOUT = 1
SYSREAD = 0
SYSWRITE = 1
SYSOPEN = 2
SYSCLOSE = 3
FREAD = 0
FWRITE = 1
SYSEXIT = 60
EXIT_SUCCESS = 0
fileWithFirstNumber: .ascii "first.txt\0"	# Plik z pierwszą liczbą
fileWithSecondNumber: .ascii "second.txt\0"	# Plik z drugą liczbą
fileWithOutNumber: .ascii "out.txt\0"		# Plik do którego zostanie zapisany wynik

.bss
.comm firstIn, 1024		# Bufor zawierający pierwszy ciąg znaków
.comm secondIn, 1024		# Bufor zawierający drugi ciąg znaków
.comm out, 1024			# Bufor zawierający wynikowy ciąg znaków

.comm firstValue, 1024		# Bufor z wartościami kolejnych bajtów pierwszej odczytanej liczby
.comm secondValue, 1024		# Drugiej
.comm outValue, 1024		# Wyjściowej

.text
.globl main
main:
#-----------------------------------------------------------------------------------------------
		# Wczytanie pierwszego ciągu
		# Wyzerowanie bufora dla wartości pierwszej liczby
movq $1024, %r8			# Licznik
movb $0, %al

loop1_0:
dec %r8
movb %al, firstValue(, %r8, 1)	# Wypełnienie bufora na wartość pierwszej liczby zerami
cmp $0, %r8
jg loop1_0

		# Otworzenie pierwszego pliku
movq $SYSOPEN, %rax		# Numer wywołania systemowego
movq $fileWithFirstNumber, %rdi	# Nazwa pliku
movq $FREAD, %rsi		# Sposób otwarcia pliku (do odczytu)
movq $0, %rdx			# Prawa dostępu
syscall
movq %rax, %r10			# Przypisanie identyfikatora otwartego pliku do r10

		# Odczyt z pliku
movq $SYSREAD, %rax
movq %r10, %rdi
movq $firstIn, %rsi
movq $1024, %rdx
syscall
movq %rax, %r8			# Zapisanie liczby odczytanych bajtów do r8

		# Zamknięcie pliku
movq $SYSCLOSE, %rax
movq %r10, %rdi			# id otwartego pliku
movq $0, %rsi
movq $0, %rdx
syscall
Zerujemy
#--------------------------------------------------------------------------------------------------
		# Dekodowanie wartości pierwszego ciągu
dec %r8				# Pominięcie znaku końca linii, r8 - liczba odczytanych bajtów
movq $1024, %r9			# Licznik do pętli działającej od końca
		#Uzyskanie wartosci liczby z jej kodu ascii
loop1_1:
dec %r8
dec %r9

movb firstIn (, %r8, 1), %al	# Dekodowanie pierwszych 4 bitów
cmp $'A', %al
jge letter1_0 			# Skok jeśli większe lub równe

sub $'0', %al			# Odkodowanie normalnej cyfry
jmp loop1_2
letter1_0:
sub $55, %al			# Odkodowanie cyfry z litery poprzez odjęcie 55 od kodu ascii

loop1_2:
cmp $0, %r8			# Sprawdzenie czy odczytaliśmy wszystkie bajty z firstIn
jle loop1_4			# Jeśli mniejsze lub równe to wychodzimy

spr0:
		# Dekodowanie kolejnych 4 bitów
movb %al, %bl
dec %r8
movb firstIn(, %r8, 1), %al

cmp $'A', %al
jge letter1_1

sub $'0', %al
jmp loop1_3

letter1_1:
sub $55, %al

#--
loop1_3:
movb $16, %cl
mul %cl				# Pomnożenie przez 16 większej części bajtu
add %bl, %al			# Dodanie tej wartości do liczby w buforze

loop1_4:
movb %al, firstValue(, %r9, 1)	# Zapisanie odkodowanego bajtu do bufora
spr1:				# %rax = 0xef
cmp $0, %r8
jg loop1_1			# Skok na początek pętli jeśli większe

spr2:

#----------------------------------------------------------------------------------------------
		# Wczytanie drugiego ciągu
                # Wyzerowanie bufora dla wartości drugiej liczby
movq $1024, %r8                 # Licznik dla pętli zerującej
movb $0, %al                    # Wartość wstawiana do bufora

loop2_0:
dec %r8
movb %al, secondValue(, %r8, 1) # Wypełnienie bufora na wartość drugiej liczby zerami
cmp $0, %r8                     # Powrót do loop2 jeśli licznik > 0
jg loop2_0

                # Otworzenie drugiego pliku:
movq $SYSOPEN, %rax             # Numer wywołania systemowego
movq $fileWithSecondNumber, %rdi # Nazwa pliku
movq $FREAD, %rsi               # Sposób otwarcia pliku (do odczytu)
movq $0, %rdx                   # Prawa dostępu
syscall
movq %rax, %r10                 # Przypisanie identyfikatora otwartego pliku do r10

                # Odczyt z pliku do bufora:
movq $SYSREAD, %rax
movq %r10, %rdi
movq $secondIn, %rsi
movq $1024, %rdx
syscall
movq %rax, %r8                  # Zapisanie ilości odczytanych bajtów do r8

                # Zamknięcie pliku
movq $SYSCLOSE, %rax
movq %r10, %rdi
movq $0, %rsi
movq $0, %rdx
syscall

#---------------------------------------------------------------------------------------------
		# Dekodowanie wartości drugiego ciągu
dec %r8                         # Pominięcie znaku końca linii, ilość odczytanych bajtów
movq $1024, %r9                 # Licznik do pętli działającej od końca

loop2_1:
dec %r8
dec %r9

movb secondIn (, %r8, 1), %al   # Dekodowanie pierwszych 4 bitów
cmp $'A', %al
jge letter2_0                   # Skok jeśli większe lub równe

sub $'0', %al                   # Odkodowanie normalnej cyfry
jmp loop2_2
letter2_0:
sub $55, %al                    # Odkodowanie cyfry z litery

loop2_2:
cmp $0, %r8
jle loop2_4                     # Wyjście z pętli jeśli odkodowano wszystkie cyfry z firstIn

                # Dekodowanie kolejnych 4 bitów
movb %al, %bl
dec %r8
movb secondIn(, %r8, 1), %al

cmp $'A', %al
jge letter2_1

sub $'0', %al
jmp loop2_3

letter2_1:
sub $55, %al

loop2_3:
movb $16, %cl
mul %cl                         # Pomnożenie przez 16 odkodowanej liczby (drugiej części bajtu)
add %bl, %al                    # Dodanie tej wartości do do liczby w buforze

loop2_4:
movb %al, secondValue(, %r9, 1) # Zapisanie odkodowanego bajtu do bufora
cmp $0, %r8
jg loop2_1                      # Skok na początek pętli jeśli większe

#----------------------------------------------------------------------------------------------
spr3:
		# Dodanie obydwóch liczb
clc				# Ustawia flagę przeniesienia na 0, wyczyszczenie flagi
pushfq				# Umieszczenie rejestru flagowego na stosie
movq $1024, %r8			# Licznik pętli

loop3:
movb firstValue(, %r8, 1), %al	# Odczytanie pierwszej wartości
movb secondValue(, %r8, 1), %bl	# Odczytanie drugiej wartości
popfq				# Pobranie zawartości rejestru flagowego ze stosu
adc %bl, %al			# Sumuje z przeniesieniem
				# sumuje A, B oraz flag cf

pushfq				# Umieszczenie rejestru flagowego na stosie
movb %al, outValue(, %r8, 1)	# Zapisanie nowo otrzymanej wartości dodawania do bufora wyj
dec %r8				# Zmniejszeje licznika pętli o jeden
cmp $0, %r8
jg loop3			# Skok na początek pętli jeśli większe

spr4:
#---------------------------------------------------------------------------------------------------
		# Konwersja na system ósemkowy

		# Odczytanie 3 kolejnych bajtów z wartości outValue
		# Sklejenie w jednym rejestrze
		# Wyłuskanie kolejnych trójek bitów
movq $1023, %r8			# Licznik bajtów z outValue, mniejszy o 1
movq $1022, %r9			# Licznik znaków ósemkowych z out

loop4:
		# Aby pobrać do rax kolejne 3 bajty z outValue w odpowiedniej kolejności

		# Trzykrotne kopiowanie po jednym bajcie z pamieci i przesuwanie w lewo
movq $0, %rax
sub $2, %r8			# Odjęcie 2 bajtów od bufora outValue
movb outValue(, %r8, 1), %al	# Pobranie pierwszego bajtu


shl $8, %rax			# Przesunięcie zawartości rejestru rax o 8 bitów w lewo
inc %r8
movb outValue(, %r8, 1), %al	# Pobranie drugiego bajtu
shl $8, %rax
inc %r8
movb outValue(, %r8, 1), %al	# Pobranie trzeciego bajtu
sub $3, %r8

		# W wyniku w rax będzie 0x ab cd ef

		# 24 bity - 6 znaków szesnastkowo, 8 znaków ósemkowo
movq $8, %r10			# Licznik dla pętli dla odczytu 8 znaków ósem z liczby 3 bajtowej

loop5:
movb %al, %bl			# Pierwszy bajt liczby do rejestru bl
and $7, %bl			# Wyłuskujemy 3 najmniej znaczące bity, usuwamy reszte bitów
				# Te bity są wartością cyfry w systemie ósemkowym
add $'0', %bl			# W tym celu zamiana na ascii
movb %bl, out(, %r9,1)		# Zapis otrzymanego znaku ascii do out

shr $3, %rax			# Przesunięcie bitowo rax o 3 bity w prawo
				# Pozbywamy się 3 odkodowanych bitów
dec %r9
dec %r10
cmp $0, %r10			# Sprawdzenie czy odczytana cała liczba 3 bajtowa
jg loop5

cmp $0, %r8
jg loop4			# Do pobrania kolejnych 3 bajtów z bufora outValue

spr5:
#-------------------------------------------------------------------------------------------------
		# Zapisanie wyniku
movq $SYSOPEN, %rax
movq $fileWithOutNumber, %rdi
movq $FWRITE, %rsi
movq $0, %rdx
syscall
movq %rax, %r8

		# Zapis bufora out do pliku
movq $1024, %r9
movb $0x0A, out(, %r9, 1)
movq $SYSWRITE, %rax
movq %r8, %rdi
movq $out, %rsi
movq $1025, %rdx
syscall

		# Zamknięcie pliku
movq $SYSCLOSE, %rax
movq %r8, %rdi
movq $0, %rsi
movq $0, %rdx
syscall

movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall

#--------------------------------------------------------------------------------------------------
