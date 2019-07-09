#include <stdio.h>

// Deklaracja funkcji zewnętrznych
extern void szyfr_cezara(char * str, int len); // Typ zwracany i typ przesyłanych argumentów

// Deklaracja zmiennych
char str[] = "abcabcabc";
int len = 9;

int main(void)
{
    szyfr_cezara(&str, len);			// Wywołanie funkcji Asemblerowej

    printf("Rezultat: %s\n", str);		// Wyświetlenie wyniku

    return 0;					// Zwrot wartości EXIT_SUCCESS
}
