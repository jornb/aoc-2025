; nasm -felf64 part1.asm && ld part1.o && ./a.out

global    _start

section .bss
  buffer resb 2560000
  cols resd 1
  rows resd 1

section .data
  outbuf db '          ', 10 ; Buffer for digits + newline


section   .text

_start:   mov rax, 0              ; read(
          mov rdi, 0              ;   stdin,
          mov rsi, buffer         ;   &out,
          mov rdx, (137 + 1)*137  ;   bytes to read
          syscall                 ; )
          mov r15, rax            ; r15 = length of file

          mov r12, 0    ; row
          mov r14, 0    ; sum

loop_rows:
          mov r13, 0    ; col
          cmp r12, 137
          je loop_rows_done 
  loop_cols:
          cmp r13, 137
          je loop_cols_done

          mov rdi, r12
          mov rsi, r13

          ; Skip cells not filled
          call check_cell_filled
          cmp rax, 1
          jne .L1

          call count_neighbors

          cmp rax, 4
          jge .L1
          inc r14
.L1:      inc r13
          jmp loop_cols
  loop_cols_done:
          inc r12
          jmp loop_rows
loop_rows_done:


exit:
          mov rax, r14
          call print_rax_to_stdout

          mov rax, 60     ; syscall number for exit
          mov rdi, 0      ; exit code (0 for success)
          syscall         ; execute the exit system call


; ---------------------------------------------
; function check_cell_filled
; rax = 1 if buffer[rdi][rsi] == '@', else 0
; ---------------------------------------------
check_cell_filled:
          mov rax, rdi       ; rax = row
          imul rax, (137 + 1)      ; rax = row * 11
          add rax, rsi      ; rax = row * 11 + col
          add rax, buffer   ; rax = &buffer[row * 11 + col]
          mov al, [rax]
          cmp al, '@'
          jne .L0
          mov rax, 1
          ret
.L0:
          mov rax, 0
          ret


; ---------------------------------------------
; function count_neighbors
; rax = # of filled neighbors of buffer[rdi][rsi]
; ---------------------------------------------
count_neighbors:
          ; rdi = row
          ; rsi = col
          xor rdx, rdx
          
          ; check [-1, -1]
          dec rdi
          dec rsi
          cmp rdi, 0
          jl .L0
          cmp rdi, 137
          jge .L0
          cmp rsi, 0
          jl .L0
          cmp rsi, 137
          jge .L0
          call check_cell_filled
          add rdx, rax
.L0       inc rdi
          inc rsi
          
          ; check [-1, 0]
          dec rdi
          cmp rdi, 0
          jl .L1
          cmp rdi, 137
          jge .L1
          cmp rsi, 0
          jl .L1
          cmp rsi, 137
          jge .L1
          call check_cell_filled
          add rdx, rax
.L1       inc rdi
          
          ; check [-1, 1]
          dec rdi
          inc rsi
          cmp rdi, 0
          jl .L2
          cmp rdi, 137
          jge .L2
          cmp rsi, 0
          jl .L2
          cmp rsi, 137
          jge .L2
          call check_cell_filled
          add rdx, rax
.L2       inc rdi
          dec rsi
          
          ; check [0, -1]
          dec rsi
          cmp rdi, 0
          jl .L3
          cmp rdi, 137
          jge .L3
          cmp rsi, 0
          jl .L3
          cmp rsi, 137
          jge .L3
          call check_cell_filled
          add rdx, rax
.L3       inc rsi
       
          
          ; check [0, 1]
          inc rsi
          cmp rdi, 0
          jl .L5
          cmp rdi, 137
          jge .L5
          cmp rsi, 0
          jl .L5
          cmp rsi, 137
          jge .L5
          call check_cell_filled
          add rdx, rax
.L5       dec rsi
          
          ; check [1, -1]
          inc rdi
          dec rsi
          cmp rdi, 0
          jl .L6
          cmp rdi, 137
          jge .L6
          cmp rsi, 0
          jl .L6
          cmp rsi, 137
          jge .L6
          call check_cell_filled
          add rdx, rax
.L6       dec rdi
          inc rsi
          
          ; check [1, 0]
          inc rdi
          cmp rdi, 0
          jl .L7
          cmp rdi, 137
          jge .L7
          cmp rsi, 0
          jl .L7
          cmp rsi, 137
          jge .L7
          call check_cell_filled
          add rdx, rax
.L7       dec rdi
          
          ; check [1, 1]
          inc rdi
          inc rsi
          cmp rdi, 0
          jl .L8
          cmp rdi, 137
          jge .L8
          cmp rsi, 0
          jl .L8
          cmp rsi, 137
          jge .L8
          call check_cell_filled
          add rdx, rax
.L8       dec rdi
          dec rsi
          
          mov rax, rdx
          ret


; ---------------------------------------------
; Function print_rax_to_stdout
; ---------------------------------------------
print_rax_to_stdout:
          mov rcx, outbuf + 10 ; Point to the end of the buffer (for reverse filling)
          mov byte [rcx], 10   ; Add a newline character
          dec rcx              ; Move to the previous position

convert_loop:
          xor rdx, rdx         ; Clear RDX for division
          mov rbx, 10          ; Divisor
          div rbx              ; RAX = RAX / 10, RDX = RAX % 10

          add dl, '0'          ; Convert digit to ASCII
          mov [rcx], dl        ; Store digit in buffer
          dec rcx              ; Move to the previous position

          cmp rax, 0           ; Check if RAX is zero
          jne convert_loop     ; Loop if not zero

          ; Print the string
          mov rax, 1           ; sys_write
          mov rdi, 1           ; stdout
          lea rsi, [rcx + 1]   ; Address of the start of the string
          mov rdx, outbuf + 11 ; End of the buffer (including newline)
          sub rdx, rsi         ; Calculate length
          syscall

          ret
