; nasm -felf64 part1.asm && ld part1.o && ./a.out

%define SIZE 137

global    _start

section .bss
  map resb (SIZE + 1)*SIZE
  cols resd 1
  rows resd 1

section .data
  outbuf db '          ', 10 ; map for digits + newline


section   .text

_start:   mov rax, 0                ; read(
          mov rdi, 0                ;   stdin,
          mov rsi, map              ;   &out,
          mov rdx, (SIZE + 1)*SIZE  ;   bytes to read
          syscall                   ; )

          mov r12, 0    ; row
          mov r14, 0    ; sum

loop_rows:
          mov r13, 0    ; col
          cmp r12, SIZE
          je loop_rows_done 
  loop_cols:
          cmp r13, SIZE
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

          mov rax, 60     ; exit (0)
          mov rdi, 0      ;
          syscall         ;


; ---------------------------------------------
; function check_cell_filled
; rax = 1 if map[rdi][rsi] == '@', else 0
; ---------------------------------------------
check_cell_filled:
          mov rax, rdi       ; rax = row


          ; Check range [0, SIZE) for rdi and rsi
          cmp rdi, 0
          jl .L0
          cmp rdi, SIZE
          jge .L0

          cmp rsi, 0
          jl .L0
          cmp rsi, SIZE
          jge .L0

          imul rax, (SIZE + 1)    ; rax = row * cols_per_row
          add rax, rsi            ; rax = row * cols_per_row + col
          add rax, map            ; rax = &map[row * cols_per_row + col]
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
; rax = # of filled neighbors of map[rdi][rsi]
; ---------------------------------------------
count_neighbors:
          ; rdi = row
          ; rsi = col
          xor rdx, rdx
          
          ; check [-1, -1]
          dec rdi
          dec rsi
          call check_cell_filled
          add rdx, rax
          inc rdi
          inc rsi
          
          ; check [-1, 0]
          dec rdi
          call check_cell_filled
          add rdx, rax
          inc rdi
          
          ; check [-1, 1]
          dec rdi
          inc rsi
          call check_cell_filled
          add rdx, rax
          inc rdi
          dec rsi
          
          ; check [0, -1]
          dec rsi
          call check_cell_filled
          add rdx, rax
          inc rsi
       
          
          ; check [0, 1]
          inc rsi
          call check_cell_filled
          add rdx, rax
          dec rsi
          
          ; check [1, -1]
          inc rdi
          dec rsi
          call check_cell_filled
          add rdx, rax
          dec rdi
          inc rsi
          
          ; check [1, 0]
          inc rdi
          call check_cell_filled
          add rdx, rax
          dec rdi
          
          ; check [1, 1]
          inc rdi
          inc rsi
          call check_cell_filled
          add rdx, rax
          dec rdi
          dec rsi
          
          mov rax, rdx
          ret


; ---------------------------------------------
; Function print_rax_to_stdout
; ---------------------------------------------
print_rax_to_stdout:
          mov rcx, outbuf + 10 ; Point to the end of the map (for reverse filling)
          mov byte [rcx], 10   ; '\n
          dec rcx

convert_loop:
          xor rdx, rdx
          mov rbx, 10
          div rbx              ; RAX = RAX / 10, RDX = RAX % 10

          add dl, '0'          ; Store digit in map
          mov [rcx], dl
          dec rcx

          cmp rax, 0
          jne convert_loop

          ; Print the string
          mov rax, 1           ; write(
          mov rdi, 1           ;  stdout,
          lea rsi, [rcx + 1]   ;  start,
          mov rdx, outbuf + 11 ;  num_bytes
          sub rdx, rsi         ;
          syscall              ; )

          ret
