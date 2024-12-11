#include <stdio.h>
#include <string.h>

int main(int argc,char *argv[]) {
    //get the arguments from command line
    char *s1=argv[1];
    char *s2=argv[2];
    int l;
    int number;
    
    //first check if the two input have the same length, if not end this program
    if(strlen(s1) != strlen(s2)){
        printf("Not an anagram");
        return 1;
    }

    //at this step, both input have the same length, store one of them as the length
    l= strlen(s1);

    //we can sort letter from both s1, s2 in ascending order, then compare letters in two string one by one
    //first loop start from first position and dont consider the final letter
    //inner loop start from second position
    for (int i=0; i<l-1;i++){
        for (int j=i+1;j<l;j++){
            if(s1[i]>s1[j]){
                //using swap here
                //number is a temporary variable to store value
                //it let the 2nd variable "move" forward one position
                //then send back the value
                number=s1[i];
                s1[i]=s1[j];
                s1[j]=number;
            }
        }
    }
    //do the same for the second string
    for (int i=0; i<l-1;i++){
        for (int j=i+1;j<l;j++){
            if(s2[i]>s2[j]){
                //using swap here
                //number is a temporary variable to store value
                //it let the 2nd variable "move" forward one position
                //then send back the value
                number=s2[i];
                s2[i]=s2[j];
                s2[j]=number;
            }
        }
    }

    //after sorting, we iterate both string to compare if the letters are the same in same position.
    for(int i=0; i<l;i++){
        if(s1[i] != s2[i]){
            printf("Not an anagram");
            return 1;
        }
    }
    printf("Anagram");
    return 0;
}
