#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "kappalib.h"


const char* s = "\n";

typedef struct Student{
			char* name;
	int roll_number;
	int age;
	double total_marks;
} Student;

int main()
{
	int i, n;
	i = 0;
	n = 5;
	struct Student student[n];
	student[0].roll_number = 1;
	student[0].name = "student0";
	student[0].age = 12;
	student[0].total_marks = 78.50;
	student[1].roll_number = 1;
	student[1].name = "student1";
	student[1].age = 10;
	student[1].total_marks = 56.84;
	student[2].roll_number = 2;
	student[2].name = "student2";
	student[2].age = 11;
	student[2].total_marks = 87.94;
	student[3].roll_number = 3;
	student[3].name = "student3";
	student[3].age = 12;
	student[3].total_marks = 89.78;
	student[4].roll_number = 4;
	student[4].name = "student4";
	student[4].age = 13;
	student[4].total_marks = 78.55;
	for (int i = 0; i <= n - 1; i+=1) {
	writeStr(student[i].name);
	writeStr(s);
	writeInteger(student[i].roll_number);
	writeStr(s);
	writeInteger(student[i].age);
	writeStr(s);
	writeScalar(student[i].total_marks);
	writeStr(s);
	writeStr(s);
	writeStr(s);
	}
	return 0;
}


