%{
#include <stdio.h>
#include <stdlib.h>

extern FILE *yyin;
extern FILE *yyout;

void add(int p[10], int q[10], int r[10]);
void sub(int p[10], int q[10], int r[10]);
void print(int p[10]);
void initialize(int p[10]);
%}

%union{
	int number;
	int array[10];
}

%token <number> NUMBER
%token VARIABLE

%type <array> polynomial monom

%left '+' '-'

%%

file : file polynomial '\n' { print($2);}
     | file '\n'
     | /* empty */
     ;

polynomial : polynomial '+' polynomial  { add($1, $3, $$);}
	   | polynomial '-' polynomial 	{ sub($1, $3, $$);}
	   | '(' polynomial ')' 	{ for(int i = 0; i < 10; i++) 
						$$[i] = $2[i];
					}
	   | monom
	   ;

monom : NUMBER '*' VARIABLE '^' NUMBER		{ initialize($$); $$[$5] = $1; }
      | '-' NUMBER '*' VARIABLE '^' NUMBER 	{ initialize($$); $$[$6] = -$2; }
      | VARIABLE '^' NUMBER 			{ initialize($$); $$[$3] = 1; }
      | '-' VARIABLE '^' NUMBER 		{ initialize($$); $$[$4] = -1; }
      | NUMBER '*' VARIABLE 			{ initialize($$); $$[1] = $1; }
      | '-' NUMBER '*' VARIABLE 		{ initialize($$); $$[1] = -$2; }
      | NUMBER 					{ initialize($$); $$[0] = $1; }
      | '-' NUMBER 				{ initialize($$); $$[0] = -$2; }
      | VARIABLE 				{ initialize($$); $$[1] = 1; }
      | '-' VARIABLE 				{ initialize($$); $$[1] = -1; }
      ;

%%

void add(int p[10], int q[10], int r[10]) {
	for(int i = 0; i < 10; i++) {	
	   r[i] = p[i] + q[i];	
	}
}

void sub(int p[10], int q[10], int r[10]) {
	for(int i = 0; i < 10; i++) {	
	   r[i] = p[i] - q[i];	
	}
}

void print(int p[10]) {
	fprintf(yyout, "Coeficientii polinomului rezultat sunt: ");
	for(int i = 9; i >= 0 ; i--) {
	   if(p[i] != 0) 
	      fprintf(yyout, "%d*x^%d ", p[i], i);
	}
	fprintf(yyout, "\n");
}

void initialize(int p[10]) {
	for(int i = 0; i < 10; i++) {	
	   p[i] = 0;	
	}
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
