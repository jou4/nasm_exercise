; nasm -f macho64 data.s
; nasm -f macho64 util.s
; gcc -o test data.o util.o
; ./test

extern _printf

extern print
extern println
extern exit


section .data
    var1            dq      0
    var2            dq      0
    num             equ     200
    true            db      "true", 0
    false           db      "false", 0
    number_format   db      "%d", 0x0a, 0
    char_format     db      "%c", 0x0a, 0
    ptr_format      db      "%p", 0x0a, 0

section .text
global _main

_main:
    push rbp
    mov rbp, rsp

    ; var1 = print_true
    mov rax, print_true
    mov qword [qword var1], rax

    ; var2 = print_false
    mov rax, print_false
    mov qword [qword var2], rax

    ; call var1
    mov rax, [qword var1]
    call rax

    ; call var2
    mov rax, [qword var2]
    call rax

    ; print var1
    mov rax, [qword var1]
    mov qword [rsp], rax
    call print_ptr

    ; print print_true
    mov rax, print_true
    mov qword [rsp], rax
    call print_ptr

    ; print var2
    mov rax, [qword var2]
    mov qword [rsp], rax
    call print_ptr

    ; print print_false
    mov rax, print_false
    mov qword [rsp], rax
    call print_ptr

    ; var1 = num
    mov rax, num
    mov qword [qword var1], rax

    ; print var1
    mov rax, [qword var1]
    mov qword [rsp], rax
    call print_number

    ; print true[1]
    mov rax, true
    mov rbx, [rax + 1]
    mov qword [rsp], rbx
    call print_char

    ; var2 = 123
    mov rax, 123
    mov qword [qword var2], rax

    ; if var2 == 0 then exit else print var2
    mov rax, [qword var2]
    cmp rax, 0
    je exit
    mov rax, [qword var2]
    mov qword [rsp], rax
    call print_number

    call exit


print_true:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov rax, true
    mov qword [rsp], rax
    call println
    mov rsp, rbp
    pop rbp
    ret


print_false:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov rax, false
    mov qword [rsp], rax
    call println
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


print_char:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov [rbp - 8], rdi
    mov [rbp - 16], rsi
    mov rsi, [rbp + 16]
    mov rdi, char_format
    mov rax, 0
    call _printf
    mov rdi, [rbp - 8]
    mov rsi, [rbp - 16]
    mov rsp, rbp
    pop rbp
    ret


print_ptr:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov [rbp - 8], rdi
    mov [rbp - 16], rsi
    mov rsi, [rbp + 16]
    mov rdi, ptr_format
    mov rax, 0
    call _printf
    mov rdi, [rbp - 8]
    mov rsi, [rbp - 16]
    mov rsp, rbp
    pop rbp
    ret
