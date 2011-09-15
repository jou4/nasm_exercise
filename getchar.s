extern _printf
extern _getchar

extern print
extern println
extern puts
extern exit

section .data
    number_format   db      "%d", 0x0a, 0

section .text
global _main

_main:
    push rbp
    mov rbp, rsp

    sub rsp, 80

    mov qword [rbp - 8], 0          ; counter

loop_begin:
    cmp qword [rbp - 8], 50
    jge loop_end
    call _getchar

    mov rcx, [rbp - 8]
    mov [rbp - 64 + rcx], rax

    inc qword [rbp - 8]

    cmp rax, 0x0a
    jne loop_begin
loop_end:

    lea rax, [rbp - 64]
    mov qword [rsp], rax
    mov rax, [rbp - 8]
    mov qword [rsp + 8], rax
    call puts

    call exit


print_number:
    push rbp
    mov rbp, rsp
    sub rsp, 16
print_number_1:
    mov [rbp - 8], rdi
    mov [rbp - 16], rsi
print_number_2:
    mov rsi, [rbp + 16]
    mov rdi, number_format
    mov rax, 0
    call _printf
print_number_3:
    mov rdi, [rbp - 8]
    mov rsi, [rbp - 16]
print_number_4:
    mov rsp, rbp
    pop rbp
    ret


