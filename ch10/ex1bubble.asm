; fill an array with random 4 byte integers
; and sort with bubble sort
       segment .data
asize  dq 0                     ; array size
aptr   dq 0                     ; pointer to array
i      dq 0                     ; array index
       segment .text
       global main
       global fillarray
       global sortarray
       extern atol
       extern malloc
       extern random
main:
       push rbp
       mov rbp,rsp
; Get array size from command line arguments
       cmp rdi,2                ; check for two arguments, second is size
       jl .done
       mov rdi,qword [rsi+8]          ; load pointer to string which is array size number
       call atol                      ; convert character string to integer.
       mov [asize],rax                ; save array size 
; Call malloc to allocate the array memory
       mov rdi,[asize]                ; load array size
       imul rdi,4                     ; convert to bytes
       call malloc                    ; allocate memory
       mov [aptr],rax                 ; store pointer to array
; Fill the array
       call fillarray           ; fill array with random integers
; Sort the array
       call sortarray           ; sort the array
.done:
       xor eax,eax              ; return code 0
       leave                    ; fix stack
       ret                      ; return
fillarray:
; add asize entries into array pointed to by aptr
; call unix function random() 
       push rbp
       mov rbp,rsp 
.looptop:
       call random              ; get random int in rax
       mov r8,[i]               ; load array index
       mov r9,[aptr]            ; load array pointer
       mov dword [r9+4*r8],eax  ; save in array only bottom 4 bytes
       inc r8                   ; increment array index
       mov [i],r8               ; save index
       cmp r8,[asize]           ; check if max number of entries
       jl .looptop
       leave
       ret
sortarray:
; sort array a using bubble sort
       push rbp
       mov rbp,rsp 
       mov r8,[asize]       ; load size of array
       dec r8               ; subtract 1 - max index of bubble sort element compare
       mov r9,[aptr]        ; load array pointer in r9
nextpass:
       xor rax,rax          ; rax is 0 if no elements were swapped in this pass
       xor rbx,rbx          ; rbx is index into array start at 0 = i
nextelement:
       mov ecx,[r9+4*rbx]   ; ecx = a[i]
       mov edx,[r9+4*rbx+4] ; edx = a[i+1]
       cmp ecx,edx          ; compare a[i] and a[i+1]
       jle noswap           ; if a[i]<=a[i+1] don't swap
       inc rax              ; rax has count of swaps
       mov [r9+4*rbx+4],ecx ; swap using values in registers
       mov [r9+4*rbx],edx   ; a[i] and a[i+1] swapped
noswap:
       inc rbx              ; i++
       cmp rbx,r8           ; index max is asize-2
       jl nextelement       ; move to next element
       cmp rax,0            ; see if any swaps were done
       jg  nextpass         ; make another pass through array
       leave
       ret