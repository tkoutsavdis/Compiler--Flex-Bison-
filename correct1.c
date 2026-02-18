#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "kappalib.h"


const char* s = "Hello! This is the first correct test\n";

const char* s1 = "Give me a number between 1 - 10\n";


const char* s2 = "Try again with a valid number 1-10\n";


const char* s3 = "\n";


const char* s4 = "This is the first array:\n";


const char* s5 = "This is the second array:\n";


void printArray(int n, int *arrayy)
{
	for (int i = 0; i <= n - 1; i+=1) {
	writeInteger(arrayy[i]);
	writeStr(s3);
	}
}


void printArray2(int n, int *a)
{
	int* half = (int*)malloc(100*sizeof(int));
	for(int a_i=0;a_i<100;++a_i){
		half[a_i] = a[a_i]+10;
	}
	for (int i = 0; i <= n - 1; i+=1) {
	writeInteger(half[i]);
	writeStr(s3);
	}
}


int main()
{
	int n;
	int mybool;
	mybool = 1;
	writeStr(s);
	writeStr(s1);
	while(mybool){
		n = readInteger();
	if(n >= 1 && n <= 10){
		int* a = (int*)malloc(n*sizeof(int));
	for(int i = 0;i<n;++i){
		a[i] = i;
	}
	mybool = 0;
	writeStr(s4);
	printArray(n, a);
	writeStr(s5);
	printArray2(n, a);	
	}
	else{
		mybool = 1;
	writeStr(s2);
	}
	}

	return 0;
}


