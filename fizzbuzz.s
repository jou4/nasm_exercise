; nasm -f macho64 fizzbuzz.s
; gcc -o fizzbuzz fizzbuzz.o
; ./fizzbuzz
; ./fizzbuzz 100

extern _printf
extern _atoi

section .data
    br              db      0x0a, 0
    number_format   db      `%d\n`, 0
    fizz            db      "Fizz", 0
    buzz            db      "Buzz", 0


section .text
global _main

_main:
    push rbp
    mov rbp, rsp

    sub rsp, 32

    mov [rbp - 8], rdi              ; argc
    mov [rbp - 16], rsi             ; argv
    mov qword [rbp - 24], 30        ; initial limit

_handle_arg_begin:
    ; args handling
    mov rax, [rbp - 8]
    cmp rax, 1
    jle _handle_args_end
    mov rax, [rbp - 16]
    mov rdi, [rax + 8]              ; param
    call _atoi
    mov [rbp - 24], rax
_handle_args_end:

    ; fizzbuzz
    mov rax, [rbp - 24]
    mov [rsp], rax
    call fizzbuzz

    ; exit
    call exit


fizzbuzz:
    push rbp
    mov rbp, rsp
    sub rsp, 32

    mov qword [rbp - 8], 0          ; counter
    mov rax, [rbp + 16]
    mov qword [rbp - 16], rax       ; limit

_loop_begin:
    mov rax, [rbp - 8]
    mov rbx, [rbp - 16]
    cmp rax, rbx
    jge _loop_end

    inc qword [rbp - 8]

_loop_fizzbuzz:
    mov rax, [rbp - 8]
    mov rbx, 15
    mov rdx, 0
    div rbx
    cmp rdx, 0
    jne _loop_buzz
    call print_fizzbuzz
    jmp _loop_begin
_loop_buzz:
    mov rax, [rbp - 8]
    mov rbx, 5
    mov rdx, 0
    div rbx
    cmp rdx, 0
    jne _loop_fizz
    call print_buzz
    jmp _loop_begin
_loop_fizz:
    mov rax, [rbp - 8]
    mov rbx, 3
    mov rdx, 0
    div rbx
    cmp rdx, 0
    jne _loop_number
    call print_fizz
    jmp _loop_begin
_loop_number:
    mov rax, [rbp - 8]
    mov [rsp], rax
    call print_number
    jmp _loop_begin

_loop_end:

    mov rsp, rbp
    pop rbp
    ret


print_fizz:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    mov rax, fizz
    mov qword [rsp], rax
    call println

    mov rsp, rbp
    pop rbp
    ret

print_buzz:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    mov rax, buzz
    mov qword [rsp], rax
    call println

    mov rsp, rbp
    pop rbp
    ret

print_fizzbuzz:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    mov rax, fizz
    mov qword [rsp], rax
    call print

    mov rax, buzz
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


strlen:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov qword [rbp - 8], 0
strlen_cmp:
    cmp byte [rax], 0
    je strlen_end
    inc rax
    inc qword [rbp - 8]
    jmp strlen_cmp
strlen_end:
    mov rax, [rbp - 8]  ; return
    mov rsp, rbp
    pop rbp
    ret


print:
    push rbp
    mov rbp, rsp
    sub rsp, 32
print_1:
    ; get length of string
    mov rax, [rbp + 16]
    mov [rsp], rax
    call strlen
    mov [rbp - 8], rax
    ; print string
    mov rax, [rbp + 16]
    mov [rsp], rax
    mov rax, [rbp - 8]
    mov [rsp + 8], rax
    call puts
print_2:
    mov rsp, rbp
    pop rbp
    ret

println:
    push rbp
    mov rbp, rsp
    sub rsp, 16
println_1:
    ; print string
    mov rax, [rbp + 16]
    mov [rsp], rax
    call print
    ; print breakline
    mov rax, br
    mov [rsp], rax
    call print
println_2:
    mov rsp, rbp
    pop rbp
    ret


puts:
    push rbp
    mov rbp, rsp
    sub rsp, 16
puts_1:
    mov [rbp - 8], rdi
    mov [rbp - 16], rsi
puts_2:
    ; print string
    mov rax, 0x2000004      ; System call write = 4
    mov rdi, 1              ; Write to standard out = 1
    mov rsi, [rbp + 16]     ; The address of string
    mov rdx, [rbp + 24]     ; The size to write
    syscall                 ; Invoke the kernel
puts_3:
    mov rdi, [rbp - 8]
    mov rsi, [rbp - 16]
puts_4:
    mov rsp, rbp
    pop rbp
    ret


exit:
    mov rax, 0x2000001      ; System call number for exit = 1
    mov rdi, 0              ; Exit success = 0
    syscall                 ; Invoke the kernel
