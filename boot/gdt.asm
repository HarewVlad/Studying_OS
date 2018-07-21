gdt_start:
	gdt_null:
		dd 0x0
		dd 0x0

	gdt_code:
		dw 0xffff ; limit 0 - 15
		dw 0x0 ; base 0 - 15
		db 0x0 ; base 16 - 23
		db 10011010b ; P DPL(2 bits) 11 C R A = 8 bits
		db 11001111b ; G D 0 AVL limit(16 - 19 bits)
		db 0x0

	gdt_data:
		dw 0xffff ; limit 0 - 15
		dw 0x0 ; base 0 - 15
		db 0x0 ; base 16 - 23
		db 10010010b ; P DPL(2 bits) 10 E W A 
		db 11001111b ; B G 0 AVL limit (16 - 19)
		db 0x0

	gdt_end:

	gdt_descriptor:
		dw gdt_end - gdt_start - 1

		dd gdt_start

	CODE_SEG equ gdt_code - gdt_start
	DATA_SEG equ gdt_data - gdt_start

; Segment base address (base) - 32-bit value defining the base address of the segment in the linear space
; Segment limit -  20-bit field defining the largest offset of the segment. The limit can be byte (Granularity = 0)
; or Page (Granularity = 1, shifts the linear address by 4Kb)
; D(default) - indicates whether the segment 32-bit(D = 1) or 16-bit(D = 0)
; E(Expansion Direction) - used with data segments, indicates whether the segment extends from its base address up ;to ; base address + limit (E = 0), of from the maximum offset down to the limit (E = 1). A data stack is usually
; expand-down(E = 1)
; B(big) - for data segments, indicates the maximum offset as 0xffffffffh (B = 1) and 0000ffffh (B = 0). Significant
; only for expand-down segments
; Access rigths :
; 	P(Present) - segment in physical memory (P = 1) or not (P = 0)
;	A(Accessed) - indicates whether the segment was accessed (A = 1)
;	DPL(Discriptor Privilege Level) - indicates privilege level of the segment as a number 0, 1, 2, 3 (0 - kernel)
;	(3 - user application) DPL of current code segments indicates CPL
; R(readable) - in case of code segments indicates whether the code segment is readable (R = 1) or not (R = 0)
; Code segments is always executable
; W(writable) - for data segments (W = 1, W = 0). Data segmens are always readable
; Data segments for stack should be writable
; AVL - available for use by system software