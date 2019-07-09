.data
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
STDOUT = 1
STDIN = 0
EXIT_SUCCESS = 0

buf: .ascii "Hello, world!\n"
buf_len = .-buf

.text 
.globl _start

_start:

movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $buf, %rsi
movq $buf_len, %rdx
syscall

movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall
