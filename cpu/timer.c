#include "timer.h"
#include "isr_irq.h"
#include "../drivers/screen.h"
#include "../kernel/utils.h"
#include "../drivers/ports.h"

u32 tick = 0;

static void timer_interrupt_callback(registers_t regs)
{
	tick++;
	//kprint("Tick: ");
	//char tick_ascii[256];
	//int_to_ascii(tick, tick_ascii);
	//kprint(tick_ascii);
	//kprint("\n");
}

void init_timer_interrupt(u32 frequency)
{
	register_interrupt_handler(IRQ0, &timer_interrupt_callback);

	u32 divisor = 1193180 / frequency;

	port_byte_out(0x43, 0x36); // 00110110 -> 00(6, 7) - Chanel 0, 11(4, 5) - lobyte/hibyte access, 011(1, 2, 3) - Square wave generator (reload), 0(0) - 16-bit

	//Divisor = lobyte + hibyte
	u8 lobyte = (u8)(divisor & 0xFF);
	u8 hibyte = (u8)((divisor >> 8) & 0xFF);

	//Send the frequency divisor
	port_byte_out(0x40, lobyte);
	port_byte_out(0x40, hibyte);
}