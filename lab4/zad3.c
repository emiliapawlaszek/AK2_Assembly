#include <stdio.h>

char str[] = "abcabcabc";		// Deklaracja zmiennej z ciągiem znaków
const int len = 9;			// Stała z długością tego ciągu

int main(void)
{
    // Wstawka asemblerowa z szyfrem cezara
    // : zwracane wartości
    // : argumenty
    // : używane rejestry
    asm(
    "mov $0, %%rbx \n"			// Zerowanie licznika pętli

    "petla: \n"				// Etykieta powrotu do pętli

    "mov (%0, %%rbx, 1), %%al \n"	// Skopiowanie ostatniego znaku napisu do rej al
    // %0 to alias rejestru w którym pojawi się pierwszy parametr wejściowy
    // (wskaźnik na pierwszą komórkę stringa)

    "cmp $'Z', %%al \n"
    "jle duze \n"

	"male: \n"
	    "add $4, %%al \n"
            "cmp $'z', %%al \n"
            "jle zapisz \n"
            "sub $26, %%al \n"
            "jmp zapisz \n"

        "duze: \n"
            "add $4, %%al \n"
            "cmp $'Z', %%al \n"
            "jle zapisz \n"
            "sub $26, %%al \n"

    "zapisz: \n"
    "mov %%al, (%0, %%rbx, 1) \n"	// Zapisanie nowej wartości do stringa

    "inc %%rbx \n"			// Zwiększenie licznika pętli
    "cmp len, %%ebx \n"			// Porównanie licznika pętli ze stałą len
    "jl petla \n"			// Powrót na początek pętli

    : // r=, brak param wyj

    :"r"(&str) // Lista parametrów wejściowych - zmiennych które zostaną
    // zapisane do rejestrów i będzie możliwy ich odczyt w kodzie asm.
    // Są one dostępne jako aliasy na rejestry - %0, %1

    :"%rax", "%rbx" // Rejestry których będziemy używać w kodzie asm

    );
    printf("Rezultat: %s\n", str);		// Wyświetlenie wyniku
    return 0;				// Zwrot wartości EXIT_SUCCESS
}
