#ifndef IDT_H
#define IDT_H

#include "types.h"

//Segment Selectors
#define KERNEL_CS 0x08
#define KERNEL_DS 0x10

//How every interrupt gate is defined
typedef struct
{
	u16 offset_1;
	u16 selector;
	u8 always_zero;
	u8 type_attr;
	u16 offset_2;
}__attribute__((packed)) idt_gate_t; //Smallest possible space for that structure

typedef struct
{
	u16 limit;
	u32 base;
}__attribute__((packed)) idt_register_t;

#define IDT_ENTRIES 256
idt_gate_t idt[IDT_ENTRIES];
idt_register_t idt_reg;

void set_idt_gate(int n, u32 handler);
void set_idt();

#endif