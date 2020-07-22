%{
#include <stdio.h>
#include <stdlib.h>

extern FILE *yyin;
extern FILE *yyout;

typedef struct _complexNumber {
	float realPart;
	float imaginaryPart;
} complexNumber;

complexNumber *memory[26];

complexNumber* add(complexNumber*, complexNumber*);
complexNumber* sub(complexNumber*, complexNumber*);
complexNumber* multiply(complexNumber*, complexNumber*);
complexNumber* divide(complexNumber*, complexNumber*);

void print(complexNumber*);
complexNumber* create(float, float);

%}

%union{
	float number;
	int variable;
	struct _complexNumber *compNo;
}

%token <number> NUMBER
%token <variable> VARIABLE

%type <compNo> complex expression;

%left '+' '-'

%%

file : file complex '\n' { print($2);}
     | file '\n'
     | /*empty*/
     ;

complex : VARIABLE '=' expression	  { $$ = $3; memory[$1] = $3;}
	| expression 			  { $$ = $1;}
	;
	
expression : expression '+' expression			{ $$ = add($1, $3);}
	   | expression '-' expression			{ $$ = sub($1, $3);}
	   | expression '*' expression			{ $$ = multiply($1, $3);}
	   | expression '/' expression			{ $$ = divide($1, $3);}
	   | '(' expression ')'				{ $$ = $2;}
	   | '<' NUMBER ',' NUMBER 'j' '>'		{ $$ = create($2, $4);}
	   | '<' NUMBER ',' 'j' '>'			{ $$ = create($2, 1.0f);}
	   | '<' NUMBER ',' '-' NUMBER 'j' '>'		{ $$ = create($2, -$5);}
	   | '<' NUMBER ',' '-' 'j' '>'			{ $$ = create($2, -1.0f);}
	   | '<' NUMBER 'j' '>'				{ $$ = create(0.0f, $2);}
	   | '<' 'j' '>'				{ $$ = create(0.0f, 1.0f);}
	   | '<' '-' NUMBER 'j' '>'			{ $$ = create(0.0f, -$3);}
	   | '<' '-' 'j' '>'				{ $$ = create(0.0f, -1.0f);}
	   | NUMBER					{ $$ = create($1, 0.0f);}
	   | VARIABLE					{ $$ = memory[$1];}
	   ;

%%

complexNumber* add(complexNumber *x, complexNumber *y) {
	complexNumber *rezult = (complexNumber *)malloc(sizeof(complexNumber));
	rezult->realPart = x->realPart + y->realPart;
	rezult->imaginaryPart = x->imaginaryPart + y->imaginaryPart;
	return rezult;
}

complexNumber* sub(complexNumber *x, complexNumber *y) {
	complexNumber *rezult = (complexNumber *)malloc(sizeof(complexNumber));
	rezult->realPart = x->realPart - y->realPart;
	rezult->imaginaryPart = x->imaginaryPart - y->imaginaryPart;
	return rezult;
}

complexNumber* multiply(complexNumber *x, complexNumber *y) {
	complexNumber *rezult = (complexNumber *)malloc(sizeof(complexNumber));
	rezult->realPart = x->realPart * y->realPart - x->imaginaryPart * y->imaginaryPart;
	rezult->imaginaryPart = x->realPart * y->imaginaryPart + y->realPart * x->imaginaryPart;
	return rezult;
}

complexNumber* divide(complexNumber *x, complexNumber *y) {
	complexNumber *rezult = (complexNumber *)malloc(sizeof(complexNumber));
	float numitor = y->realPart * y->realPart + y->imaginaryPart * y->imaginaryPart;
	rezult->realPart = x->realPart * y->realPart + x->imaginaryPart * y->imaginaryPart / numitor;
	rezult->imaginaryPart = x->imaginaryPart * y->realPart - x->realPart * y->imaginaryPart / numitor;
	return rezult;
}

void print(complexNumber *number) {
	fprintf(yyout, "<");
	if(number->realPart != 0) {
	   fprintf(yyout, "%f", number->realPart);	
	   if(number->imaginaryPart != 0) {
	      fprintf(yyout, ", %fj>", number->imaginaryPart);
	   }
	} else{
	   if(number->imaginaryPart != 0) {
	      fprintf(yyout, "%fj>", number->imaginaryPart);
	   }
	}
	fprintf(yyout, "\n");
}

complexNumber* create(float realPart, float imaginaryPart) {
	complexNumber *newNumber = (complexNumber *)malloc(sizeof(complexNumber));
	newNumber->realPart = realPart;
	newNumber->imaginaryPart = imaginaryPart;
	return newNumber;
}

int yyerror(char *msg) {
	fprintf(yyout, "KO-%s\n",msg);
        exit(1); 
}

int main(int argc, char *argv[]) {
	FILE *input = fopen(argv[1], "r");
	FILE *output = fopen(argv[2], "w");

	if(!input) return -1;
	else yyin = input;

	if(!output) return -1;
	else yyout = output;

	if(!yyparse()) fprintf(yyout, "OK\n");
        else fprintf(yyout, "KO\n"); 

	return 0; 
}
