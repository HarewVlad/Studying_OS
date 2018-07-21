#include "../kernel/utils.h"

void memory_copy(char *source, char *dest, int nbytes)
{
	int i;
	for (i = 0; i < nbytes; i++)
	{
		*(dest + i) = *(source + i);
	}
}

void int_to_ascii(int n, char str[]) {
    int i, sign;
    if ((sign = n) < 0) n = -n;
    i = 0;
    do {
        str[i++] = n % 10 + '0';
    } while ((n /= 10) > 0);

    if (sign < 0) str[i++] = '-';
    str[i] = '\0';

    reverse(str);
}

void reverse(char string[])
{
    int temp;
    for (int begin = 0, end = strlen(string) - 1; begin < end; begin++, end--)
    {
        temp = string[begin];
        string[begin] = string[end];
        string[end] = temp;
    }
}

int strlen(char string[])
{
    int i = 0;
    while (string[i] != '\0') ++i;
    return i;
}

void append(char s[], char n)
{
    int len = strlen(s);
    s[len] = n;
    s[len + 1] = '\0';
}

void backspace(char s[])
{
    int len = strlen(s);
    s[len - 1] = '\0';
}

int strcmp(char s1[], char s2[])
{
    int i;
    for (i = 0; s1[i] == s2[i]; i++)
    {
        if (s1[i] == '\0') return 0;
    }

    return s1[i] - s2[i];
}