print_string:
	pusha
	_main_print_string:
		mov ah, 0x0e
		mov al, [bx]
		cmp al, 0
		jz return_print_string

		int 0x10
		add bx, 1

		jmp _main_print_string

print_hex:
	pusha

	mov cx, 0

	_main_change_values:
		cmp cx, 4 ;Counter 4 digits
		je return_print_hex ;End of routine
		
		mov ax, dx ;Move argument to bx
		and ax, 0x000f ;Get less significant digit. Alternative (and ax, 0xf000 ;; shr ax, 12)
		add al, 0x30 ;Cast digit to char
		jmp _main_fix_handler ;Handler for hex values
	return_point:
		mov bx, temp_buff + 5
		sub bx, cx
		mov [bx], al ;mov fixed char to output buffer

		shr dx, 4 ;0x3456 -> 0x0345

		inc cx ;increment counter
		jmp _main_change_values ;jump to beginning of the loop

	_main_fix_handler:
		cmp al, 0x39 ;cmp if greater than 9
		jle return_point ; al <= 0x39 return else add al, 0x7
		add al, 0x7 ;
		jmp return_point

print_nl:
	pusha
	mov ah, 0x0e
	mov al, 0x0A
	int 0x10

	mov al, 0x0D
	int 0x10

	popa
	ret

return_print_string:
	call print_nl
	popa
	ret

return_print_hex:
	mov bx, temp_buff
	call print_string
	popa
	ret

temp_buff:
	db '0x0000', 0