%{ 
#include <stdio.h> 
#include <stdlib.h> 
#include <string.h> 

char input_text[10] ;
int input_date = 0 ;
int input_month = 0 ;
int valid=0,var=0;
int arrDay[]={1,31,61,91,121,151,181,211,241,271,301,331};
int arrVal[366]={0};

int temp = 0 ; //stores index in the array
struct transaction{
	int date;
	int month;
	char custId[100];
	int val;
};
struct transaction t1;
struct transaction arrCust[366];
char customer[100];
%}

%s RECORD
%%
$(" ")?[A-Z]+[0-9]+ {
	strcpy(customer,yytext);
	printf("\n%s-",customer);
	BEGIN RECORD;
} 

<RECORD>[0-9][0-9]"/"[0-9][0-9] {
	printf("alooo");
	char dy[3];
 	dy[0]=yytext[0]; dy[1]=yytext[1]; dy[2]='\0';
 	char mt[3];
 	mt[0]=yytext[3]; mt[1]=yytext[4]; mt[3]='\0';
 	t1.date=atoi(dy);
	if(t1.date > 30 || t1.date < 1)
	{
		printf("0");
		exit(EXIT_FAILURE);
	}
	t1.month=atoi(mt);
	if(t1.month > 12 || t1.month < 1)
	{
		printf("0");
		exit(EXIT_FAILURE);
	}
	printf("%d-%d",t1.date,t1.month);
 	strcpy(t1.custId,customer);
}

<RECORD>[0-9]+ {
	t1.val=atoi(yytext);
	printf("%d ",t1.date);
	printf("%d \n",t1.month);
	arrVal[t1.date  + arrDay[t1.month-1]]++; //updates counter
	if(temp == (t1.month -1)*30 + t1.date)
		printf("sfsdfsd\n");
	if( arrCust[t1.date  + arrDay[t1.month-1]].val < t1.val  )
	{ 
		arrCust[t1.date  + arrDay[t1.month-1]]=t1; // updating max value
	}
}


<RECORD>; {BEGIN RECORD;}
<RECORD>;\n {BEGIN 0;}
"\n" {return 1;}
"//" {}
. {}
%%

int main(){
yyin=fopen("data.txt","r+");
FILE *input = fopen("input.txt", "r");


fscanf(input,"%s",input_text);
// strcpy(input_text,input);
input_date = (input_text[0] - '0')*10 + (input_text[1] - '0');
input_month = (input_text[3] - '0')*10 + (input_text[4] - '0');

yylex();
temp = (input_month -1)*30 + input_date;
printf("\n%d",temp);
printf("\n$%d%s",arrVal[input_date-1+arrDay[input_month-1]],(arrCust[input_date-1+arrDay[input_month-1]]).custId);
//int arrDay[]={0,31,60,91,121,152,182,213,244,274,305,335};

}

