#include "ports.h"
#include "../cpu/isr_irq.h"
#include "../drivers/screen.h"
#include "../kernel/utils.h"
#include "../kernel/kernel.h"

#define BACKSPACE 0x0e
#define ENTER 0x1C


static char key_buffer[256];

const char *sc_name[] = 
{
	"ERROR", "Esc", "1", "2", "3", "4", "5", "6", 
    "7", "8", "9", "0", "-", "=", "Backspace", "Tab", "Q", "W", "E", 
    "R", "T", "Y", "U", "I", "O", "P", "[", "]", "Enter", "Lctrl", 
    "A", "S", "D", "F", "G", "H", "J", "K", "L", ";", "'", "`", 
    "LShift", "\\", "Z", "X", "C", "V", "B", "N", "M", ",", ".", 
    "/", "RShift", "Keypad *", "LAlt", "Spacebar"
};

const char *sc_ascii[] = 
{
	'?', '?', '1', '2', '3', '4', '5', '6',     
    '7', '8', '9', '0', '-', '=', '?', '?', 'Q', 'W', 'E', 'R', 'T', 'Y', 
    'U', 'I', 'O', 'P', '[', ']', '?', '?', 'A', 'S', 'D', 'F', 'G', 
    'H', 'J', 'K', 'L', ';', '\'', '`', '?', '\\', 'Z', 'X', 'C', 'V', 
    'B', 'N', 'M', ',', '.', '/', '?', '?', '?', ' '
};

static void keyboard_callback(registers_t regs)
{
	u8 scancode = port_byte_in(0x60); //Read port 0x60
	if (scancode == BACKSPACE)
	{
		backspace(key_buffer);
		kprint_backspace();
	}
	else if (scancode == ENTER)
	{
		kprint("\n");
		user_input(key_buffer);
		key_buffer[0] = '\0';
	}
	else
	{
		char letter = sc_ascii[(int)scancode];
		char str[2] = {letter, '\0'};
		append(key_buffer, str);
		kprint(str);
	}
}

void init_keyboard()
{
	register_interrupt_handler(IRQ1, keyboard_callback); //Map keyboard_callback to first free handler(IRQ1)
}