.data
EXIT = 60
EXIT_SUCCESS = 0

val1:
.float 1.2, 20.76, 56.97, 5.8
val2:
.float 6.4, 1.20, 100.8, 3.57

.bss
.comm arr, 512				# bufor zawierający tablicę

.text
.globl main
main:

rdtsc		# pobranie pierwszego czasu. licznik w edx(pierwsza połowa):eax(druga połowa)
xorl %ebx, %ebx				# zerowanie ebx
xorl %ecx, %ecx				# zerowanie ecx

addl %edx, %ebx				# zapis pierwszej połowy do ebx
addl %eax, %ecx				# zapis drugiej połowy do ecx

movups val1, %xmm0
movups val2, %xmm1
addps %xmm1, %xmm0			# wynik dodawania w xmm0
clc					# czyści flagi

rdtsc		# pobranie drugiego czasu. licznik w edx(pierwsza połowa):eax(druga połowa)
sbbl %ecx, %eax				# odjęcie drugiej połowy
sbbl %ebx, %edx				# odjęcie pierwszej połowy, wynik w edx:eax

spr:
movq $EXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall
