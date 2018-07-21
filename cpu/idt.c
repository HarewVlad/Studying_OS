#include "idt.h"

void set_idt_gate(int n, u32 handler)
{
	idt[n].offset_1 = low_16(handler);
	idt[n].selector = KERNEL_CS;
	idt[n].always_zero = 0;
	idt[n].type_attr = 0x8E;
	idt[n].offset_2 = high_16(handler);
}

void set_idt()
{
	idt_reg.base = (u32)&idt;
	idt_reg.limit = IDT_ENTRIES * sizeof(idt_gate_t) - 1;
	asm volatile("lidtl (%0)" : : "r" (&idt_reg));
}