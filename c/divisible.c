#include <stdio.h>
#include <stdlib.h>

int main() {
    int input0;
    int input1;
    int input2;
    printf("Please input three numbers:");
    //store 3 input into variable
    scanf("%d %d %d", &input0, &input1, &input2);

    //to see if the 2nd and 3rd input can be divided completely by the first input
    if(input1 % input0 == 0 && input2 % input0 ==0){
        //compare 3 inputs to see if they are increasing
        if (input1>input0 && input2 >input1){
            printf("Divisible & Increasing");
            exit(0);
        } else{
            printf("Divisible & Not increasing");
            exit(2);
        }
    }
    else{
        if (input1>input0 && input2 >input1){
            printf("Not divisible & Increasing");
            exit(1);
        } else{
            printf("Not divisible & Not increasing");
            exit(3);
        }
    }

}

