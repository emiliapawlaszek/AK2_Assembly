#include <stdio.h>
 
extern double taylor(double niewiadoma, int iteracje);
 
int main(void)
{
    double niewiadoma;
    int iteracje;

    printf("Niewiadoma, czyli potęga (e^x): ");
    scanf("%lf", &niewiadoma);
    printf("Liczba wyrazow ciagu: ");
    scanf("%d", &iteracje);
    printf("Przybliżany wynik to: %lf\n", taylor(niewiadoma, iteracje)+1);
    return 0;
}
