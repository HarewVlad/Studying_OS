disk_load:
	push dx

	mov ah, 0x02 ; Read from disk
	mov al, dh ; number of sections to read
	mov ch, 0x00 ; cylinder (0x0 ... 0x3FF)
	mov dh, 0x00 ; head number (0x0 ... 0xF)
	mov cl, 0x02 ; sector 0x01 - boot sector, 0x02 - first avaliable sector ... (0x1 ... 0x11)
				 ; dl - drive number . Again BIOS stores our boot drive in dl. We will set this var
	int 0x13
	jc disk_error

	pop dx
	cmp dh, al
	jne disk_error

	ret

disk_error:
	mov bx, DISK_ERROR_MSG
	call print_string
	jmp $

DISK_ERROR_MSG:
	db 'Disk read error!', 0