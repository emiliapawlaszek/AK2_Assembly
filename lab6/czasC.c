#include <stdio.h>

float tab[4];
float tab1[4] = {1.2, 20.76, 56.97, 5.8};
float tab2[4] = {6.4, 1.20, 100.8, 3.57};

extern unsigned long long getczas();


void dodaj()
{
	for(int i=0; i<4; i++) {
		tab[i] = tab1[i]+tab2[i];
	}
}

int main(void){

	unsigned long long int czas1, czas2;
	double wynik1, wynik2;

	czas1 = getczas() ;
	dodaj;
	czas2 = getczas();

printf("%llu \n",czas2-czas1);
}


