[org 0x7c00]
KERNEL_OFFSET equ 0x1000

	mov [BOOT_DRIVE], dl

	pusha

	mov dx, 0x3f2
	in al, dx
	or al, 00001000b
	out dx, al

	popa

	mov bp, 0x9000
	mov sp, bp
	
	mov bx, MSG_REAL_MODE
	call print_string

	call load_kernel

	call switch_to_pm

	jmp $

%include "boot/print_string.asm"
%include "boot/switch_pm.asm"
%include "boot/gdt.asm"
%include "boot/print_string_32bit.asm"
%include "boot/disk_load.asm"

[bits 16]
load_kernel:
	mov bx, MSG_LOAD_KERNEL
	call print_string

	mov bx, KERNEL_OFFSET
	mov dh, 15
	mov dl, [BOOT_DRIVE]
	call disk_load

	ret

[bits 32]
BEGIN_PM:
	mov ebx, MSG_PROT_MODE
	call print_string_pm
	call KERNEL_OFFSET

	jmp $

MSG_REAL_MODE:
	db "We are in 16-bit Real Mode", 0

MSG_LOAD_KERNEL:
	db "We are loading the kernel from memory", 0

MSG_PROT_MODE:
	db "We are in 32-bit Protected Mode", 0

BOOT_DRIVE:
	db 0

times 510 - ($ - $$) db 0
dw 0xaa55