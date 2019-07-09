#include <stdio.h>
#include <math.h>

extern int sprawdzWyjatki();	// zwraca inta - liczbę definującą wyjątki
extern void maskujWyjatki(int);	// ustawienie wybranych masek wyjątków
extern void wyczyscMaski();
extern void dzieleniePrzezZero();

int main(void){
    int choice, exceptions;
    do{
        printf( "\n\n1: Sprawdź wyjątki\n"
                "2: Maskuj wyjątki\n"
                "3: Wyczyść wszystkie maski\n"
                "4: Podziel przez zero\n"
                "0: Wyjście\n"
		"TWÓJ WYBÓR: ");
        scanf("%d", &choice);

        if (choice == 1){
            exceptions = sprawdzWyjatki();
            if (exceptions == 0){
                printf("Brak wyjątków\n");
                continue;
            }
            // operacje %2 to sprawdzenie czy jest ustawiony bit 1
            if (exceptions % 2 == 1)    // bit 0
                printf("Invalid-Operation Exception\n");

            exceptions = exceptions >> 1; //przesunięcie bitowe w prawo
            if (exceptions % 2 == 1)    // bit 1
                printf("Denormalized-Operand Exception\n");

            exceptions = exceptions >> 1;
            if (exceptions % 2 == 1)    // bit 2
                printf("Zero-Divide Exception\n");

            exceptions = exceptions >> 1;
            if (exceptions % 2 == 1)    // bit 3
                printf("Overflow Exception\n");

            exceptions = exceptions >> 1;
            if (exceptions % 2 == 1)    // bit 4
                printf("Underflow Exception\n");

            exceptions = exceptions >> 1;
            if (exceptions % 2 == 1)    // bit 5
                printf("Precision Exception\n");
        }
	
	// wybranie maski do ustawienia
        else if (choice == 2){
            printf("\n\nWYBIERZ WYJĄTEK DO ZAMASKOWANIA: \n"
            "0: Invalid-Operation Exception\n"
            "1: Denormalized-Operand Exception\n"
            "2: Zero-Divide Exception\n"
            "3: Overflow Exception\n"
            "4: Underflow Exception\n"
            "5: Precision Exception\n"
	    "TWÓJ WYBÓR: ");
            scanf("%d", &exceptions);
            if (exceptions > 5 || exceptions < 0){
                printf("Niepoprawny wybór\n");
                continue;
            }
		// cyfra 2 podniesiona do potęgi równej wybranej masce. w ten sposób 
		// uzyskiwany jest ustawiony bit na pozycji odpowiadającej wybranej masce.
          maskujWyjatki((int)pow(2,exceptions));

          // need to compile with -lm after c file
        }

        else if (choice == 3){
            wyczyscMaski();
        }

        else if (choice == 4){
            dzieleniePrzezZero();
        }
    } while(choice != 0);
}
