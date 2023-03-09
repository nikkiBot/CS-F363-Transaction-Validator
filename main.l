%{ 
#include <stdio.h> 
#include <stdlib.h> 
#include <string.h> 

char *input_text = NULL ;
int input_date = 0 ;
int input_month = 0 ;
int valid=0,var=0;
int arrDay[]={0,31,60,91,121,152,182,213,244,274,305,335};
int arrVal[366]={0};

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

<RECORD>[0-9]+ {
	t1.val=atoi(yytext);
	if(arrVal[t1.date -1 + arrDay[t1.month-1]]==0 || arrCust[t1.date -1 + arrDay[t1.month-1]].val < t1.val  )
	{ 
		arrVal[t1.date -1 + arrDay[t1.month-1]]++;
		arrCust[t1.date -1 + arrDay[t1.month-1]]=t1;
	}
}

<RECORD>[0-9]+"/"[0-9]+ {
	char dy[3];
 	dy[0]=yytext[0]; dy[1]=yytext[1]; dy[2]='\0';
 	char mt[3];
 	mt[0]=yytext[3]; mt[1]=yytext[4]; mt[3]='\0';
 	t1.date=atoi(dy);
	if(t1.date > 30 || t1.date < 1)
	{
		exit(EXIT_FAILURE);
	}
	t1.month=atoi(mt);
	if(t1.month > 12 || t1.month < 1)
	{
		exit(EXIT_FAILURE);
	}
	printf("%d-%d",t1.date,t1.month);
 	strcpy(t1.custId,customer);
}
<RECORD>; {BEGIN RECORD;}
<RECORD>;\n {BEGIN 0;}
\n {return 1;}
"//" {}
%%

int main(){
yyin=fopen("data.txt","r+");
FILE *input = fopen("input.txt", "r");

yylex();


strcpy(input_text,input);
input_date = (input_text[0] - '0')*10 + (input_text[1] - '0');
input_month = (input_text[3] - '0')*10 + (input_text[4] - '0');

printf("\n$%d%s",arrVal[input_date-1+arrDay[input_month-1]],(arrCust[input_date-1+arrDay[input_month-1]]).custId);

}

