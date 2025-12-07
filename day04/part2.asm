; nasm -felf64 part1.asm && ld part1.o && ./a.out

%define SIZE 137

global    _start

section .bss
  map1 resb (SIZE + 1)*SIZE
  map2 resb (SIZE + 1)*SIZE
  cols resd 1
  rows resd 1

section .data
  outbuf db '          ', 10 ; map1 for digits + newline


section   .text

_start:   mov rax, 0                ; read(
          mov rdi, 0                ;   stdin,
          mov rsi, map1             ;   &out,
          mov rdx, (SIZE + 1)*SIZE  ;   bytes to read
          syscall                   ; )

          mov r15, 0    ; sum
          
          ; Loop until step returns 0
L0:       call step
          add r15, rax
          cmp rax, 0
          je exit
          jmp L0

exit:
          mov rax, r15
          call print_rax_to_stdout
          mov rax, 60     ; exit (0)
          mov rdi, 0      ;
          syscall         ;


; ---------------------------------------------
; function check_cell_filled
; rax = number of rolls of paper removed
; ---------------------------------------------
step:
          ; Copy map1 to map2
          mov rsi, map1
          mov rdi, map2
          mov rcx, (SIZE + 1)*SIZE
          rep movsb

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

          call remove_if_possible

          cmp rax, 1
          jl .L1
          inc r14
  .L1:    inc r13
          jmp loop_cols
  loop_cols_done:
          inc r12
          jmp loop_rows
loop_rows_done:

          ; Copy map2 to map1
          mov rsi, map2
          mov rdi, map1
          mov rcx, (SIZE + 1)*SIZE
          rep movsb

          mov rax, r14
          ret




; ---------------------------------------------
; function check_cell_filled
; rax = 1 if map1[rdi][rsi] == '@', else 0
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
          add rax, map1           ; rax = &map1[row * cols_per_row + col]
          mov al, [rax]
          cmp al, '@'
          jne .L0
          mov rax, 1
          ret
.L0:
          mov rax, 0
          ret


; ---------------------------------------------
; function clear_cell
; Sets map2[rdi][rsi] = '.'
; ---------------------------------------------
clear_cell:
          mov rax, rdi            ; rax = row
          imul rax, (SIZE + 1)    ; rax = row * cols_per_row
          add rax, rsi            ; rax = row * cols_per_row + col
          add rax, map2           ; rax = &map2[row * cols_per_row + col]
          mov byte [rax], 'x'
          mov rax, rdi
          mov rax, rsi
          ret


; ---------------------------------------------
; function count_neighbors
; rax = 1 if removed, else 0
; Also sets map2[rdi][rsi] = 1 if counted < 4
; ---------------------------------------------
remove_if_possible:
          ; Skip cells not filled
          call check_cell_filled
          cmp rax, 1
          jne .L0


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

          ; Remove if less than 4 neighbors
          cmp rdx, 4
          jge .L0
          call clear_cell        
          mov rax, 1
          ret
.L0:      mov rax, 0
          ret


; ---------------------------------------------
; Function print_rax_to_stdout
; ---------------------------------------------
print_rax_to_stdout:
          mov rcx, outbuf + 10 ; Point to the end of the map1 (for reverse filling)
          mov byte [rcx], 10   ; '\n
          dec rcx

convert_loop:
          xor rdx, rdx
          mov rbx, 10
          div rbx              ; RAX = RAX / 10, RDX = RAX % 10

          add dl, '0'          ; Store digit in map1
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
