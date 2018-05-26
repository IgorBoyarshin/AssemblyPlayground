; Prints the program name, its command-line arguments
; and environmental variables.
BITS 64
global _start
;------------------------------------------------------------------------------
section .data
    MSG_PARAMETERS: db '--- Program name and command-line parameters:', 10
    MSG_PARAMETERS_LEN equ $ - MSG_PARAMETERS
    MSG_ENVIRONMENT_VARS: db '--- Program environment variables:', 10
    MSG_ENVIRONMENT_VARS_LEN equ $ - MSG_ENVIRONMENT_VARS
    NEW_LINE: db 10
;------------------------------------------------------------------------------
section .text
_start:
    ; Print program name and command-line parameters
    mov rax, 1 ; sys_write
    mov rdi, 1 ; stdout
    mov rsi, MSG_PARAMETERS
    mov rdx, MSG_PARAMETERS_LEN
    syscall

    mov rcx, 1 ; to skip argc, which is at [rsp]
l1:
    mov rax, 1 ; sys_write
    mov rdi, 1 ; stdout
    mov rsi, [rsp + 8 * rcx]
    call get_len ; fills RDX based on RSI
    push rcx ; syscall might alter RCX, we need it
    syscall

    call put_line

    pop rcx ; restore
    inc rcx
    cmp rcx, [rsp] ; [rsp] is argc
    jle l1


    ; Print environment variables
    mov rax, 1 ; sys_write
    mov rdi, 1 ; stdout
    mov rsi, MSG_ENVIRONMENT_VARS
    mov rdx, MSG_ENVIRONMENT_VARS_LEN
    push rcx ; syscall might alter RCX, we need it
    syscall
    pop rcx

    ; RCX now points at 0 right after the end of argv
    ; RCX+1 will be the first env var
    inc rcx
l2:
    mov rsi, [rsp + 8 * rcx]
    cmp rsi, 0
    jz the_end ; iterate until RSI == 0 (marks the end of env vars)
    mov rax, 1 ; sys_write
    mov rdi, 1 ; stdout
    call get_len ; fills RDX based on RSI
    push rcx ; syscall might alter RCX, we need it
    syscall

    call put_line

    pop rcx ; restore
    inc ecx
    jmp l2
the_end:


; Exit
    mov rax, 60             ; sys_exit
    xor rdi, rdi            ; code 0
    syscall
;------------------------------------------------------------------------------
; Procedure get_len
; Input:
;   RSI - buffer address
; Output:
;   RDX - amount of chars in buffer before 0
get_len:
    xor rdx, rdx
    push rax ; we will be modifying it
get_len_loop:
    mov al, [rsi + rdx]
    cmp al, 0
    jz get_len_end
    inc rdx
    jmp get_len_loop
get_len_end:
    pop rax
    ret
;------------------------------------------------------------------------------
; Procedure put_line
put_line:
    mov rax, 1 ; sys_write
    mov rdi, 1 ; stdout
    mov rsi, NEW_LINE
    mov rdx, 1
    syscall
    ret
