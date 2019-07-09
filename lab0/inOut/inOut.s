.data
STDIN = 0
STDOUT = 1
SYSWRITE = 1
SYSREAD = 0
SYSEXIT = 60
EXIT_SUCCESS = 0
BUFLEN = 512

.bss
.comm textin, 512
.comm textout, 512

.text
.global main
main:
movq $SYSREAD, %rax
movq $STDIN, %rdi
movq $textin, %rsi
movq $BUFLEN, %rdx
syscall

dec %rax
movq $0, %rdi

zamien_wielkosc_liter:
movb textin(, %rdi, 1), %bh
movb $0x20, %bl
xor %bh, %bl
movb %bl, textout(,%rdi, 1)
inc %rdi
cmp %rax, %rdi
jl zamien_wielkosc_liter

movb $'\n', textout(, %rdi, 1)
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $textout, %rsi
movq $BUFLEN, %rdx
syscall
movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall
