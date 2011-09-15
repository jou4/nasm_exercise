; nasm -f macho64 print.s
; nasm -f macho64 util.s
; gcc -o print print.o util.o
; ./print

extern _printf

extern strlen
extern print
extern println
extern puts
extern exit

section .data
    true            db      "true", 0
    true_len        equ     $ - true
    false           db      "false", 0
    false_len       equ     $ - false
    hello_world     db      "Hello World!", 0x0a, 0
    hello_world_len equ     $ - hello_world
    number_format   db      "%d", 0x0a, 0
    number_format_len equ   $ - number_format
    is_nat_string   db      "is_nat = ", 0


section .text
global _main

_main:
    push rbp
    mov rbp, rsp

    sub rsp, 32

    ; argc
    mov [rbp - 8], rdi
    mov [rsp], rdi
    call print_number

    ; argv
_main_argv:
    mov rbx, 0
_main_argv_cmp:
    cmp rbx, [rbp - 8]
    jge _main_argv_end
    mov rax, [rsi + rbx * 8]
    mov [rsp], rax
    call println
    inc rbx
    jmp _main_argv_cmp
_main_argv_end:

    ; print_hello_n
    mov qword [rsp], 3
    call print_hello_n

    ; is nat: -1
    mov rax, is_nat_string
    mov qword [rsp], rax
    call print
    mov qword [rsp], -1
    call is_nat

    ; is nat: 0
    mov rax, is_nat_string
    mov qword [rsp], rax
    call print
    mov qword [rsp], 0
    call is_nat

    ; is nat: 1
    mov rax, is_nat_string
    mov qword [rsp], rax
    call print
    mov qword [rsp], 1
    call is_nat

    ; strlen
    mov rax, hello_world
    mov qword [rsp], rax
    call strlen
    mov qword [rsp], rax
    call print_number

    ; print
    mov rax, true
    mov qword [rsp], rax
    call println

    ; exit
    call exit


print_hello_n:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov qword [rbp - 8], 0
print_hello_n_cmp:
    mov rcx, [rbp - 8]
    cmp rcx, [rbp + 16]
    jge print_hello_n_end
    call print_hello
    inc qword [rbp - 8]
    jmp print_hello_n_cmp
print_hello_n_end:
    mov rsp, rbp
    pop rbp
    ret


is_nat:
    push rbp
    mov rbp, rsp
    sub rsp, 16
is_nat_cmp:
    mov rax, [rbp + 16]
    cmp rax, 0
    jg is_nat_true
    call print_false
    jmp is_nat_end
is_nat_true:
    call print_true
is_nat_end:
    mov rsp, rbp
    pop rbp
    ret


print_hello:
    push rbp
    mov rbp, rsp
    sub rsp, 16
print_hello_1:
    mov rax, hello_world
    mov qword [rsp], rax
    call print
print_hello_2:
    mov rsp, rbp
    pop rbp
    ret


print_true:
    push rbp
    mov rbp, rsp
    sub rsp, 16
print_true_1:
    mov rax, true
    mov qword [rsp], rax
    call println
print_true_2:
    mov rsp, rbp
    pop rbp
    ret


print_false:
    push rbp
    mov rbp, rsp
    sub rsp, 16
print_false_1:
    mov rax, false
    mov qword [rsp], rax
    call println
print_false_2:
    mov rsp, rbp
    pop rbp
    ret


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


