%{ 
#include <stdio.h> 
#include <stdlib.h> 
#include <string.h> 
 
char input_text[10] ;
int input_date = 0 ;
int input_month = 0 ;
 
int valid=0,var=0;
int arrDay[]={0,31,60,91,121,152,182,213,244,274,305,335};
int arrVal[366]={0};
     
struct transaction{
    	int d;
    	int m;
    	char custId[100];
    	int val;
};
struct transaction t1;
struct transaction arrCust[366];
char customer[100];
%} //To use printf
%s REC
%%
"//"(.)* ;
$(" ")?[A-Z]+[0-9]+ {
    strcpy(customer,yytext);
    printf("\n%s-",customer);
    BEGIN REC;
}
     
<REC>[0-9]+ {
    t1.val=atoi(yytext);

    arrVal[t1.d -1 + arrDay[t1.m-1]]++;
    if(arrVal[t1.d -1 + arrDay[t1.m-1]]==0 || arrCust[t1.d -1 + arrDay[t1.m-1]].val < t1.val  )
    {
        // printf("aloooooooooooooooo\n") ;
        arrCust[t1.d -1 + arrDay[t1.m-1]]=t1;
    }
}
     
<REC>[0-9]+"/"[0-9]+(" ") {
    char dy[3];
    dy[0]=yytext[0]; dy[1]=yytext[1]; dy[2]='\0';
    char mt[3];
    mt[0]=yytext[3]; mt[1]=yytext[4]; mt[3]='\0';
 
    t1.d=atoi(dy);
    t1.m=atoi(mt);
 
    printf("date, month%d-%d",t1.d,t1.m);
    strcpy(t1.custId,customer);
}
<REC>;(" ") {BEGIN REC;}
<REC>;(\n)? {BEGIN 0;} 
     
%%
int main(){
    yyin=fopen("data.txt","r+");
    FILE *input = fopen("input.txt", "r");
    fscanf(input,"%s",input_text);
    // strcpy(input_text,input);
    input_date = (input_text[0] - '0')*10 + (input_text[1] - '0');
    input_month = (input_text[3] - '0')*10 + (input_text[4] - '0');
    yylex();
    // printf("Enter day and month as dd mm: ");
    // int d,m;
     
    // scanf("%d %d",&d,&m);
     
    printf("\n$%d%s#",arrVal[input_date-1+arrDay[input_month-1]],(arrCust[input_date-1+arrDay[input_month-1]]).custId);
     
}
     